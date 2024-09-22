class ActivityLog {
  int? id;
  String? username;
  String? businessName;
  String? action;
  DateTime? createdAt;
  int? totalAmount;
  ActivityLog(
      {this.id,
      this.username,
      this.businessName,
      this.action,
      this.createdAt,
      this.totalAmount});

  // Factory constructor for creating a Activity Log from JSON
  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json["id"] as int,
      username: json["username"] as String,
      businessName: json["business_name"] as String,
      action: json["action"] as String,
      createdAt: DateTime.parse(json["created_at"]),
      totalAmount: json["total_amount"] as int,
    );
  }

  // Method to convert Activity Log to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'business_name': businessName,
      'action': action,
      'created_at': createdAt,
      'total_amount': totalAmount
    };
  }

  @override
  String toString() {
    return 'ActivityLog{id: $id, username: $username, business_name: $businessName, action: $action, createdAt: ${createdAt?.toIso8601String()},total_amount: $totalAmount}';
  }
}
