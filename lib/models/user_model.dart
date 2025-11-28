class User {
  final String id;
  final String email;
  final String name;
  final String photoUrl;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.photoUrl,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'photoUrl': photoUrl,
    'createdAt': createdAt.toIso8601String(),
  };
}