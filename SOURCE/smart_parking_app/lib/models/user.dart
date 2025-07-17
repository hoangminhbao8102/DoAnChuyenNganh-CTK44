class User {
  final int id;
  final String userName;
  final String fullName;
  final String role;

  User({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      fullName: json['fullName'],
      role: json['role'],
    );
  }
}
