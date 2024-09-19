
class FusionUser {
  int? id;
  String? username;
  String? email;
  String? role;
  DateTime? createdAt;
  FusionUser({this.id, this.username, this.email, this.role, this.createdAt});

  // Factory constructor for creating a User from JSON
  factory FusionUser.fromJson(Map<String, dynamic> json) {
    
    return FusionUser(
        id: json["id"] as int,
        username: json["username"] as String,
        email: json["email"] as String,
        role: json["role"] as String,
        createdAt: DateTime.parse(json["created_at"]) 
      );
  }

  // Method to convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'created_at': createdAt
    };
  }

  @override
  String toString() {
    return 'FusionUser{id: $id, username: $username, email: $email, role: $role, createdAt: ${createdAt?.toIso8601String()}}';
  }
}
