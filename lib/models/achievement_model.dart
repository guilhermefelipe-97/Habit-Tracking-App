class Achievement {
  final String id;
  final String title;
  final String description;
  final int points;
  final String category;
  bool isUnlocked;
  final DateTime? unlockedAt;
  final String? icon;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.category,
    this.isUnlocked = false,
    this.unlockedAt,
    this.icon,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      points: json['points'] as int,
      category: json['category'] as String? ?? 'milestone',
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'points': points,
    'category': category,
    'isUnlocked': isUnlocked,
    'unlockedAt': unlockedAt?.toIso8601String(),
    'icon': icon,
  };
}