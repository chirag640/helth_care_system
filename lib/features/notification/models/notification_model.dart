import 'package:equatable/equatable.dart';

/// Notification type enum matching backend
enum NotificationType {
  appointmentReminder('AppointmentReminder'),
  appointmentConfirmed('AppointmentConfirmed'),
  appointmentCancelled('AppointmentCancelled'),
  appointmentRescheduled('AppointmentRescheduled'),
  prescriptionReady('PrescriptionReady'),
  labResultReady('LabResultReady'),
  paymentReceived('PaymentReceived'),
  paymentDue('PaymentDue'),
  documentUploaded('DocumentUploaded'),
  messageReceived('MessageReceived'),
  telemedicineStart('TelemedicineStart'),
  general('General'),
  system('System');

  const NotificationType(this.value);
  final String value;

  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (type) => type.value.toLowerCase() == value.toLowerCase(),
      orElse: () => NotificationType.general,
    );
  }

  String get displayName {
    switch (this) {
      case NotificationType.appointmentReminder:
        return 'Appointment Reminder';
      case NotificationType.appointmentConfirmed:
        return 'Appointment Confirmed';
      case NotificationType.appointmentCancelled:
        return 'Appointment Cancelled';
      case NotificationType.appointmentRescheduled:
        return 'Appointment Rescheduled';
      case NotificationType.prescriptionReady:
        return 'Prescription Ready';
      case NotificationType.labResultReady:
        return 'Lab Results Ready';
      case NotificationType.paymentReceived:
        return 'Payment Received';
      case NotificationType.paymentDue:
        return 'Payment Due';
      case NotificationType.documentUploaded:
        return 'Document Uploaded';
      case NotificationType.messageReceived:
        return 'New Message';
      case NotificationType.telemedicineStart:
        return 'Video Call Starting';
      case NotificationType.general:
        return 'Notification';
      case NotificationType.system:
        return 'System';
    }
  }
}

/// Notification priority enum
enum NotificationPriority {
  low('Low'),
  medium('Medium'),
  high('High'),
  urgent('Urgent');

  const NotificationPriority(this.value);
  final String value;

  static NotificationPriority fromString(String value) {
    return NotificationPriority.values.firstWhere(
      (priority) => priority.value.toLowerCase() == value.toLowerCase(),
      orElse: () => NotificationPriority.medium,
    );
  }
}

/// Notification model
class NotificationModel extends Equatable {
  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.priority = NotificationPriority.medium,
    this.isRead = false,
    this.data,
    this.actionUrl,
    this.imageUrl,
    this.createdAt,
    this.readAt,
    this.expiresAt,
  });

  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final bool isRead;
  final Map<String, dynamic>? data;
  final String? actionUrl;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? readAt;
  final DateTime? expiresAt;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? json['body'] as String? ?? '',
      type: NotificationType.fromString(json['type'] as String? ?? ''),
      priority:
          NotificationPriority.fromString(json['priority'] as String? ?? ''),
      isRead: json['isRead'] as bool? ?? json['read'] as bool? ?? false,
      data: json['data'] as Map<String, dynamic>?,
      actionUrl: json['actionUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      readAt: json['readAt'] != null
          ? DateTime.tryParse(json['readAt'] as String)
          : null,
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type.value,
      'priority': priority.value,
      'isRead': isRead,
      if (data != null) 'data': data,
      if (actionUrl != null) 'actionUrl': actionUrl,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (readAt != null) 'readAt': readAt!.toIso8601String(),
      if (expiresAt != null) 'expiresAt': expiresAt!.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    NotificationType? type,
    NotificationPriority? priority,
    bool? isRead,
    Map<String, dynamic>? data,
    String? actionUrl,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? readAt,
    DateTime? expiresAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
      actionUrl: actionUrl ?? this.actionUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  /// Get relative time string
  String get timeAgo {
    if (createdAt == null) return '';

    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }

  /// Check if notification is from today
  bool get isToday {
    if (createdAt == null) return false;
    final now = DateTime.now();
    return createdAt!.year == now.year &&
        createdAt!.month == now.month &&
        createdAt!.day == now.day;
  }

  /// Check if notification is from this week
  bool get isThisWeek {
    if (createdAt == null) return false;
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return createdAt!.isAfter(weekStart) && !isToday;
  }

  /// Check if notification is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        message,
        type,
        priority,
        isRead,
        data,
        actionUrl,
        imageUrl,
        createdAt,
        readAt,
        expiresAt,
      ];
}

/// Notification preferences model
class NotificationPreferences extends Equatable {
  const NotificationPreferences({
    this.emailEnabled = true,
    this.pushEnabled = true,
    this.smsEnabled = false,
    this.appointmentReminders = true,
    this.appointmentUpdates = true,
    this.prescriptionAlerts = true,
    this.labResultAlerts = true,
    this.paymentAlerts = true,
    this.promotionalEmails = false,
    this.reminderHoursBefore = 24,
  });

  final bool emailEnabled;
  final bool pushEnabled;
  final bool smsEnabled;
  final bool appointmentReminders;
  final bool appointmentUpdates;
  final bool prescriptionAlerts;
  final bool labResultAlerts;
  final bool paymentAlerts;
  final bool promotionalEmails;
  final int reminderHoursBefore;

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      emailEnabled: json['emailEnabled'] as bool? ?? true,
      pushEnabled: json['pushEnabled'] as bool? ?? true,
      smsEnabled: json['smsEnabled'] as bool? ?? false,
      appointmentReminders: json['appointmentReminders'] as bool? ?? true,
      appointmentUpdates: json['appointmentUpdates'] as bool? ?? true,
      prescriptionAlerts: json['prescriptionAlerts'] as bool? ?? true,
      labResultAlerts: json['labResultAlerts'] as bool? ?? true,
      paymentAlerts: json['paymentAlerts'] as bool? ?? true,
      promotionalEmails: json['promotionalEmails'] as bool? ?? false,
      reminderHoursBefore: json['reminderHoursBefore'] as int? ?? 24,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emailEnabled': emailEnabled,
      'pushEnabled': pushEnabled,
      'smsEnabled': smsEnabled,
      'appointmentReminders': appointmentReminders,
      'appointmentUpdates': appointmentUpdates,
      'prescriptionAlerts': prescriptionAlerts,
      'labResultAlerts': labResultAlerts,
      'paymentAlerts': paymentAlerts,
      'promotionalEmails': promotionalEmails,
      'reminderHoursBefore': reminderHoursBefore,
    };
  }

  NotificationPreferences copyWith({
    bool? emailEnabled,
    bool? pushEnabled,
    bool? smsEnabled,
    bool? appointmentReminders,
    bool? appointmentUpdates,
    bool? prescriptionAlerts,
    bool? labResultAlerts,
    bool? paymentAlerts,
    bool? promotionalEmails,
    int? reminderHoursBefore,
  }) {
    return NotificationPreferences(
      emailEnabled: emailEnabled ?? this.emailEnabled,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      appointmentReminders: appointmentReminders ?? this.appointmentReminders,
      appointmentUpdates: appointmentUpdates ?? this.appointmentUpdates,
      prescriptionAlerts: prescriptionAlerts ?? this.prescriptionAlerts,
      labResultAlerts: labResultAlerts ?? this.labResultAlerts,
      paymentAlerts: paymentAlerts ?? this.paymentAlerts,
      promotionalEmails: promotionalEmails ?? this.promotionalEmails,
      reminderHoursBefore: reminderHoursBefore ?? this.reminderHoursBefore,
    );
  }

  @override
  List<Object?> get props => [
        emailEnabled,
        pushEnabled,
        smsEnabled,
        appointmentReminders,
        appointmentUpdates,
        prescriptionAlerts,
        labResultAlerts,
        paymentAlerts,
        promotionalEmails,
        reminderHoursBefore,
      ];
}

/// Unread count response
class UnreadCount extends Equatable {
  const UnreadCount({
    required this.total,
    this.byType = const {},
  });

  final int total;
  final Map<NotificationType, int> byType;

  factory UnreadCount.fromJson(Map<String, dynamic> json) {
    final byTypeJson = json['byType'] as Map<String, dynamic>? ?? {};
    final byType = <NotificationType, int>{};
    byTypeJson.forEach((key, value) {
      byType[NotificationType.fromString(key)] = value as int;
    });

    return UnreadCount(
      total: json['total'] as int? ?? json['count'] as int? ?? 0,
      byType: byType,
    );
  }

  @override
  List<Object?> get props => [total, byType];
}

/// Paginated notifications response
class PaginatedNotifications {
  const PaginatedNotifications({
    required this.notifications,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.unreadCount,
  });

  final List<NotificationModel> notifications;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final int unreadCount;

  factory PaginatedNotifications.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ??
        json['notifications'] as List<dynamic>? ??
        [];
    return PaginatedNotifications(
      notifications: data
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 1,
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  bool get hasMore => page < totalPages;
}
