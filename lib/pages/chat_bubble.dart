import 'package:flutter/material.dart';
import 'package:supabase_lab/model/mesage.dart';

import 'package:timeago/timeago.dart' as timeago;

class ChatBubble extends StatelessWidget {
  final Message message;
  const ChatBubble({super.key, required this.message});

/*
  @override
  Widget build(BuildContext context) {
    var chatContents = [
      const SizedBox(width: 12.0),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: message.isMine ? Colors.blueAccent : Colors.orange,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message.content,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Text(timeago.format(message.createAt),
          style: const TextStyle(color: Colors.grey, fontSize: 12.0)),
      //todo marked as read
      const SizedBox(width: 60),
    ];

    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!message.isMine)
        CircleAvatar(
          backgroundColor: Colors.orangeAccent,
          child: Text(message.userFrom.substring(0, 2)),
        ),
      const SizedBox(width: 12),
      Flexible(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: message.isMine ? Colors.blueAccent : Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message.content,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              width: 20,
              height: 5,
            ),
            Text(timeago.format(message.createAt)),
          ],
        ),
      ),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
