class FollowupModel {
  int? id;
  String? name;
  String? phone;
  String? consumerBehavior;
  bool? isActive;
  String? remark;
  int? userId;
  DateTime? createdAt;
  FollowupModel(
      {this.id,
      this.name,
      this.phone,
      this.consumerBehavior,
      this.isActive,
      this.remark,
      this.userId,
      this.createdAt});

  // Factory constructor for creating a User from JSON
  factory FollowupModel.fromJson(Map<String, dynamic> json) {
    return FollowupModel(
        id: json["id"] as int,
        name: json["name"] as String,
        phone: json["phone"] as String,
        consumerBehavior: json["consumer_behavior"] as String,
        isActive: json["is_active"] as bool,
        remark: json["remark"] as String,
        userId: json["user_id"] as int,
        createdAt: DateTime.parse(json["created_at"]));
  }

  // Method to convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'consumerBehavior': consumerBehavior,
      'isActive': isActive,
      'remark': remark,
      'userId': userId,
      'created_at': createdAt
    };
  }

  @override
  String toString() {
    return 'FollowupModel{id: $id, name: $name, phone: $phone, isActive: $isActive, consumerBehavior: $consumerBehavior,  remark: $remark ,userId: $userId, createdAt: ${createdAt?.toIso8601String()}}';
  }
}
