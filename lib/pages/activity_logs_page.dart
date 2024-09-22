import 'package:flutter/material.dart';

class ActivityLogs extends StatefulWidget {
  const ActivityLogs({super.key});

  @override
  State<ActivityLogs> createState() => _ActivityLogsState();
}

class _ActivityLogsState extends State<ActivityLogs> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Activity Logs'),
    );
  }
}
