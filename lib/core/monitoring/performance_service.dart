import 'dart:async';

import 'package:flutter/widgets.dart';

import '../utils/logger.dart';

/// Performance metrics
class PerformanceMetrics {
  int frameCount = 0;
  int droppedFrameCount = 0;
  List<Duration> frameDurations = [];
  DateTime? lastFrameTime;

  double get fps {
    if (frameDurations.isEmpty) return 0;
    final avgDuration =
        frameDurations.reduce((a, b) => a + b) ~/ frameDurations.length;
    if (avgDuration.inMicroseconds == 0) return 0;
    return 1000000 / avgDuration.inMicroseconds;
  }

  double get droppedFramePercentage {
    if (frameCount == 0) return 0;
    return (droppedFrameCount / frameCount) * 100;
  }

  void reset() {
    frameCount = 0;
    droppedFrameCount = 0;
    frameDurations.clear();
    lastFrameTime = null;
  }

  Map<String, dynamic> toMap() => {
        'frameCount': frameCount,
        'droppedFrameCount': droppedFrameCount,
        'fps': fps.toStringAsFixed(1),
        'droppedFramePercentage':
            '${droppedFramePercentage.toStringAsFixed(1)}%',
      };
}

/// App lifecycle metrics
class LifecycleMetrics {
  DateTime? appStartTime;
  DateTime? firstFrameTime;
  Duration? startupDuration;
  int resumeCount = 0;
  int pauseCount = 0;
  Duration totalActiveTime = Duration.zero;
  DateTime? lastResumeTime;

  Map<String, dynamic> toMap() => {
        'startupDurationMs': startupDuration?.inMilliseconds,
        'resumeCount': resumeCount,
        'pauseCount': pauseCount,
        'totalActiveTimeSeconds': totalActiveTime.inSeconds,
      };
}

/// API metrics
class ApiMetrics {
  int totalRequests = 0;
  int successfulRequests = 0;
  int failedRequests = 0;
  Duration totalLatency = Duration.zero;
  Map<String, int> statusCodeCounts = {};
  Map<String, Duration> endpointLatencies = {};

  double get successRate {
    if (totalRequests == 0) return 100;
    return (successfulRequests / totalRequests) * 100;
  }

  double get averageLatencyMs {
    if (totalRequests == 0) return 0;
    return totalLatency.inMilliseconds / totalRequests;
  }

  void recordRequest({
    required String endpoint,
    required int statusCode,
    required Duration latency,
  }) {
    totalRequests++;
    totalLatency += latency;

    if (statusCode >= 200 && statusCode < 300) {
      successfulRequests++;
    } else {
      failedRequests++;
    }

    statusCodeCounts[statusCode.toString()] =
        (statusCodeCounts[statusCode.toString()] ?? 0) + 1;

    endpointLatencies[endpoint] = latency;
  }

  void reset() {
    totalRequests = 0;
    successfulRequests = 0;
    failedRequests = 0;
    totalLatency = Duration.zero;
    statusCodeCounts.clear();
    endpointLatencies.clear();
  }

  Map<String, dynamic> toMap() => {
        'totalRequests': totalRequests,
        'successRate': '${successRate.toStringAsFixed(1)}%',
        'averageLatencyMs': averageLatencyMs.toStringAsFixed(0),
        'statusCodes': statusCodeCounts,
      };
}

/// Memory metrics
class MemoryMetrics {
  int? heapSize;
  int? heapUsed;
  DateTime? lastMeasurement;

  double get usagePercentage {
    if (heapSize == null || heapUsed == null || heapSize == 0) return 0;
    return (heapUsed! / heapSize!) * 100;
  }

  Map<String, dynamic> toMap() => {
        'heapSizeMB': heapSize != null
            ? (heapSize! / 1024 / 1024).toStringAsFixed(1)
            : null,
        'heapUsedMB': heapUsed != null
            ? (heapUsed! / 1024 / 1024).toStringAsFixed(1)
            : null,
        'usagePercentage': '${usagePercentage.toStringAsFixed(1)}%',
      };
}

/// Performance monitoring service
class PerformanceMonitoringService with WidgetsBindingObserver {
  PerformanceMonitoringService._();

  static final PerformanceMonitoringService _instance =
      PerformanceMonitoringService._();
  static PerformanceMonitoringService get instance => _instance;

  bool _initialized = false;
  Timer? _metricsTimer;

  final PerformanceMetrics frameMetrics = PerformanceMetrics();
  final LifecycleMetrics lifecycleMetrics = LifecycleMetrics();
  final ApiMetrics apiMetrics = ApiMetrics();
  final MemoryMetrics memoryMetrics = MemoryMetrics();

  /// Initialize performance monitoring
  Future<void> init() async {
    if (_initialized) return;

    // Record app start time
    lifecycleMetrics.appStartTime = DateTime.now();

    // Add lifecycle observer
    WidgetsBinding.instance.addObserver(this);

    // Start metrics collection
    _startMetricsCollection();

    _initialized = true;
    AppLogger.success('Performance monitoring initialized', 'Performance');
  }

  /// Record first frame rendered
  void recordFirstFrame() {
    if (lifecycleMetrics.firstFrameTime != null) return;

    lifecycleMetrics.firstFrameTime = DateTime.now();
    if (lifecycleMetrics.appStartTime != null) {
      lifecycleMetrics.startupDuration = lifecycleMetrics.firstFrameTime!
          .difference(lifecycleMetrics.appStartTime!);
      AppLogger.info(
        '🚀 App startup completed in ${lifecycleMetrics.startupDuration!.inMilliseconds}ms',
        'Performance',
      );
    }
  }

  void _startMetricsCollection() {
    _metricsTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _collectMetrics();
    });
  }

  void _collectMetrics() {
    // Log metrics summary
    if (frameMetrics.frameCount > 0) {
      AppLogger.debug(
        '📊 Performance: ${frameMetrics.fps.toStringAsFixed(1)} FPS, '
            '${frameMetrics.droppedFramePercentage.toStringAsFixed(1)}% dropped, '
            'API: ${apiMetrics.successRate.toStringAsFixed(0)}% success',
        'Performance',
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        lifecycleMetrics.resumeCount++;
        lifecycleMetrics.lastResumeTime = DateTime.now();
        AppLogger.debug('App resumed', 'Lifecycle');
        break;
      case AppLifecycleState.paused:
        lifecycleMetrics.pauseCount++;
        if (lifecycleMetrics.lastResumeTime != null) {
          lifecycleMetrics.totalActiveTime +=
              DateTime.now().difference(lifecycleMetrics.lastResumeTime!);
        }
        AppLogger.debug('App paused', 'Lifecycle');
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  /// Record API request
  void recordApiRequest({
    required String endpoint,
    required int statusCode,
    required Duration latency,
  }) {
    apiMetrics.recordRequest(
      endpoint: endpoint,
      statusCode: statusCode,
      latency: latency,
    );
  }

  /// Get all metrics
  Map<String, dynamic> getAllMetrics() => {
        'frame': frameMetrics.toMap(),
        'lifecycle': lifecycleMetrics.toMap(),
        'api': apiMetrics.toMap(),
        'memory': memoryMetrics.toMap(),
      };

  /// Reset all metrics
  void resetMetrics() {
    frameMetrics.reset();
    apiMetrics.reset();
  }

  /// Dispose resources
  void dispose() {
    _metricsTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _initialized = false;
  }
}

/// Widget to track frame performance
class PerformanceOverlay extends StatefulWidget {
  const PerformanceOverlay({
    super.key,
    required this.child,
    this.enabled = false,
  });

  final Widget child;
  final bool enabled;

  @override
  State<PerformanceOverlay> createState() => _PerformanceOverlayState();
}

class _PerformanceOverlayState extends State<PerformanceOverlay> {
  Timer? _updateTimer;
  PerformanceMetrics _metrics = PerformanceMetrics();

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _updateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          _metrics = PerformanceMonitoringService.instance.frameMetrics;
        });
      });
    }
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 50,
          right: 10,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(
                  0xB3000000), // 70% opacity black (0xB3 = 179 = ~70% of 255)
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${_metrics.fps.toStringAsFixed(0)} FPS\n'
              '${_metrics.droppedFramePercentage.toStringAsFixed(0)}% dropped',
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 10,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
