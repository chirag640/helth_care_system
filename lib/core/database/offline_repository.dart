import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

import '../utils/logger.dart';
import 'hive_database.dart';

/// Conflict resolution strategies
enum ConflictResolution {
  /// Server data wins
  serverWins,

  /// Local data wins
  localWins,

  /// Most recent timestamp wins
  lastWriteWins,

  /// Merge changes (for compatible data)
  merge,

  /// Prompt user to resolve
  manual,
}

/// Data conflict information
class DataConflict {
  const DataConflict({
    required this.key,
    required this.localData,
    required this.serverData,
    required this.localTimestamp,
    required this.serverTimestamp,
  });

  final String key;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> serverData;
  final DateTime localTimestamp;
  final DateTime serverTimestamp;

  /// Get data based on resolution strategy
  Map<String, dynamic> resolve(ConflictResolution resolution) {
    switch (resolution) {
      case ConflictResolution.serverWins:
        return serverData;
      case ConflictResolution.localWins:
        return localData;
      case ConflictResolution.lastWriteWins:
        return localTimestamp.isAfter(serverTimestamp) ? localData : serverData;
      case ConflictResolution.merge:
        return _mergeData();
      case ConflictResolution.manual:
        return localData; // Default to local, user should resolve
    }
  }

  Map<String, dynamic> _mergeData() {
    final merged = Map<String, dynamic>.from(serverData);

    // Override with local changes for fields that exist in both
    for (final key in localData.keys) {
      if (localData[key] != null) {
        merged[key] = localData[key];
      }
    }

    return merged;
  }
}

/// Local cache entry with metadata
class CacheEntry {
  CacheEntry({
    required this.key,
    required this.data,
    required this.timestamp,
    this.expiry,
    this.syncStatus = SyncStatus.synced,
  });

  final String key;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final DateTime? expiry;
  SyncStatus syncStatus;

  bool get isExpired => expiry != null && DateTime.now().isAfter(expiry!);

  bool get needsSync => syncStatus != SyncStatus.synced;

  Map<String, dynamic> toJson() => {
        'key': key,
        'data': data,
        'timestamp': timestamp.toIso8601String(),
        'expiry': expiry?.toIso8601String(),
        'syncStatus': syncStatus.name,
      };

  factory CacheEntry.fromJson(Map<String, dynamic> json) {
    return CacheEntry(
      key: json['key'] as String,
      data: Map<String, dynamic>.from(json['data'] as Map),
      timestamp: DateTime.parse(json['timestamp'] as String),
      expiry: json['expiry'] != null
          ? DateTime.parse(json['expiry'] as String)
          : null,
      syncStatus: SyncStatus.values.byName(json['syncStatus'] as String),
    );
  }
}

/// Sync status for cached data
enum SyncStatus {
  synced,
  pendingUpload,
  pendingDownload,
  conflict,
}

/// Offline data repository
class OfflineRepository {
  OfflineRepository({
    required this.boxName,
    this.defaultExpiry = const Duration(hours: 24),
    this.conflictResolution = ConflictResolution.lastWriteWins,
  });

  final String boxName;
  final Duration defaultExpiry;
  final ConflictResolution conflictResolution;

  Box<Map>? _box;
  final _conflictsController = StreamController<DataConflict>.broadcast();

  /// Stream of detected conflicts
  Stream<DataConflict> get conflicts => _conflictsController.stream;

  /// Initialize the repository
  Future<void> init() async {
    _box = await HiveDatabase.instance.openBox<Map>(boxName);
    AppLogger.debug('Offline repository "$boxName" initialized', 'OfflineRepo');
  }

  /// Get cached data by key
  Future<CacheEntry?> get(String key) async {
    _ensureInitialized();

    final raw = _box!.get(key);
    if (raw == null) return null;

    try {
      final entry = CacheEntry.fromJson(Map<String, dynamic>.from(raw));

      // Check expiry
      if (entry.isExpired) {
        await delete(key);
        return null;
      }

      return entry;
    } catch (e) {
      AppLogger.error('Failed to read cache entry', e, null, 'OfflineRepo');
      return null;
    }
  }

  /// Put data into cache
  Future<void> put(
    String key,
    Map<String, dynamic> data, {
    Duration? expiry,
    SyncStatus syncStatus = SyncStatus.synced,
  }) async {
    _ensureInitialized();

    final entry = CacheEntry(
      key: key,
      data: data,
      timestamp: DateTime.now(),
      expiry: DateTime.now().add(expiry ?? defaultExpiry),
      syncStatus: syncStatus,
    );

    await _box!.put(key, entry.toJson());
    AppLogger.debug('Cached: $key', 'OfflineRepo');
  }

  /// Delete cached data
  Future<void> delete(String key) async {
    _ensureInitialized();
    await _box!.delete(key);
    AppLogger.debug('Deleted from cache: $key', 'OfflineRepo');
  }

  /// Clear all cached data
  Future<void> clear() async {
    _ensureInitialized();
    await _box!.clear();
    AppLogger.warning('Cache cleared: $boxName', 'OfflineRepo');
  }

  /// Get all entries needing sync
  Future<List<CacheEntry>> getPendingSync() async {
    _ensureInitialized();

    final entries = <CacheEntry>[];

    for (final key in _box!.keys) {
      final raw = _box!.get(key);
      if (raw == null) continue;

      try {
        final entry = CacheEntry.fromJson(Map<String, dynamic>.from(raw));
        if (entry.needsSync) {
          entries.add(entry);
        }
      } catch (e) {
        AppLogger.error(
            'Failed to read entry for sync', e, null, 'OfflineRepo');
      }
    }

    return entries;
  }

  /// Handle server data update
  Future<void> updateFromServer(
    String key,
    Map<String, dynamic> serverData,
    DateTime serverTimestamp,
  ) async {
    _ensureInitialized();

    final localEntry = await get(key);

    if (localEntry == null || localEntry.syncStatus == SyncStatus.synced) {
      // No conflict, just update
      await put(key, serverData);
      return;
    }

    // Check for conflict
    if (localEntry.syncStatus == SyncStatus.pendingUpload) {
      final conflict = DataConflict(
        key: key,
        localData: localEntry.data,
        serverData: serverData,
        localTimestamp: localEntry.timestamp,
        serverTimestamp: serverTimestamp,
      );

      // Notify conflict
      _conflictsController.add(conflict);

      // Auto-resolve based on strategy
      final resolved = conflict.resolve(conflictResolution);
      await put(key, resolved, syncStatus: SyncStatus.pendingUpload);
    }
  }

  /// Mark entry as synced
  Future<void> markSynced(String key) async {
    final entry = await get(key);
    if (entry == null) return;

    entry.syncStatus = SyncStatus.synced;
    await _box!.put(key, entry.toJson());
  }

  /// Get cache statistics
  Map<String, dynamic> getStats() {
    _ensureInitialized();

    int total = 0;
    int synced = 0;
    int pending = 0;
    int expired = 0;

    for (final key in _box!.keys) {
      final raw = _box!.get(key);
      if (raw == null) continue;

      try {
        final entry = CacheEntry.fromJson(Map<String, dynamic>.from(raw));
        total++;

        if (entry.isExpired) {
          expired++;
        } else if (entry.syncStatus == SyncStatus.synced) {
          synced++;
        } else {
          pending++;
        }
      } catch (e) {
        // Skip invalid entries
      }
    }

    return {
      'total': total,
      'synced': synced,
      'pending': pending,
      'expired': expired,
    };
  }

  /// Cleanup expired entries
  Future<int> cleanupExpired() async {
    _ensureInitialized();

    final keysToDelete = <dynamic>[];

    for (final key in _box!.keys) {
      final raw = _box!.get(key);
      if (raw == null) continue;

      try {
        final entry = CacheEntry.fromJson(Map<String, dynamic>.from(raw));
        if (entry.isExpired && entry.syncStatus == SyncStatus.synced) {
          keysToDelete.add(key);
        }
      } catch (e) {
        // Remove invalid entries
        keysToDelete.add(key);
      }
    }

    for (final key in keysToDelete) {
      await _box!.delete(key);
    }

    if (keysToDelete.isNotEmpty) {
      AppLogger.info(
        'Cleaned up ${keysToDelete.length} expired entries',
        'OfflineRepo',
      );
    }

    return keysToDelete.length;
  }

  void _ensureInitialized() {
    if (_box == null || !_box!.isOpen) {
      throw StateError('OfflineRepository not initialized. Call init() first.');
    }
  }

  /// Dispose resources
  void dispose() {
    _conflictsController.close();
  }
}
