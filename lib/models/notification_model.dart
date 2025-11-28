class HabitNotification {
  final String id;
  final String userId;
  final String habitId;
  final String title;
  final String message;
  final String type; // 'reminder', 'achievement', 'streak', 'info'
  bool isRead;
  final DateTime createdAt;

  HabitNotification({
    required this.id,
    required this.userId,
    required this.habitId,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    required this.createdAt,
  });

  factory HabitNotification.fromJson(Map<String, dynamic> json) {
    return HabitNotification(
      id: json['id'] as String,
      userId: json['userId'] as String,
      habitId: json['habitId'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String? ?? 'info',
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'habitId': habitId,
    'title': title,
    'message': message,
    'type': type,
    'isRead': isRead,
    'createdAt': createdAt.toIso8601String(),
  };
}