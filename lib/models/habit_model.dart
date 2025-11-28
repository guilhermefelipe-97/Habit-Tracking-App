class Habit {
  final String id;
  final String userId;
  final String name;
  final String description;
  final String frequency;
  final String time;
  bool isCompleted;
  final DateTime createdAt;
  final DateTime? lastCompletedAt;

  Habit({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.frequency,
    required this.time,
    this.isCompleted = false,
    required this.createdAt,
    this.lastCompletedAt,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      frequency: json['frequency'] as String,
      time: json['time'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastCompletedAt: json['lastCompletedAt'] != null
          ? DateTime.parse(json['lastCompletedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'description': description,
    'frequency': frequency,
    'time': time,
    'isCompleted': isCompleted,
    'createdAt': createdAt.toIso8601String(),
    'lastCompletedAt': lastCompletedAt?.toIso8601String(),
  };
}