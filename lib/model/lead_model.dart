class LeadModel {
  int? id;
  String? name;
  String? phone;
  String? source;
  String? app;
  String? action;
  String? remark;
  int? userId;
  DateTime? createdAt;
  LeadModel(
      {this.id,
      this.name,
      this.phone,
      this.source,
      this.app,
      this.action,
      this.remark,
      this.userId,
      this.createdAt});

  // Factory constructor for creating a User from JSON
  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
        id: json["id"] as int,
        name: json["name"] as String,
        phone: json["phone"] as String,
        source: json["source"] as String,
        app: json["app"] as String,
        action: json["action"] as String,
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
      'source': source,
      'app': app,
      'action': source,
      'remark': remark,
      'userId': userId,
      'created_at': createdAt
    };
  }

  @override
  String toString() {
    return 'LeadModel{id: $id, name: $name, phone: $phone, source: $source, app: $app, action: $action, remark: $remark ,userId: $userId, createdAt: ${createdAt?.toIso8601String()}}';
  }
}
