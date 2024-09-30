class Message {
  int? id;
  String content;
  bool markAsRead;
  String userFrom;
  String userTo;
  DateTime createAt;
  bool isMine;

  Message({
    required this.id,
    required this.content,
    required this.markAsRead,
    required this.userFrom,
    required this.userTo,
    required this.createAt,
    required this.isMine,
  });

  Message.create(
      {required this.content, required this.userFrom, required this.userTo})
      : markAsRead = false,
        isMine = true,
        createAt = DateTime.now();

  Message.fromJson(Map<String, dynamic> json, String userFrom)
      : id = json['id'] as int,
        content = json['content'],
        markAsRead = json['mark_as_read'],
        userFrom = json['user_from'],
        userTo = json['user_to'],
        createAt = DateTime.parse(json['created_at']),
        isMine = json['user_from'] == userFrom;

  Map toMap() {
    return {
      'content': content,
      'user_from': userFrom,
      'user_to': userTo,
      'mark_as_read': markAsRead,
    };
  }
}
