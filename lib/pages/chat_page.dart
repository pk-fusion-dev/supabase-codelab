import 'package:flutter/material.dart';

class SupaChat extends StatefulWidget {
  const SupaChat({super.key});

  @override
  State<SupaChat> createState() => _SupaChatState();
}

class _SupaChatState extends State<SupaChat> {
  @override
  Widget build(BuildContext context) {
    return  const Center(
      child: Text('This is chat content'),
    );
  }
}