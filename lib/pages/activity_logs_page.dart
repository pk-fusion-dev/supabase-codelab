import 'package:flutter/material.dart';
import 'package:supabase_lab/model/activity_logs.dart';
import 'package:supabase_lab/network/supabase_service.dart';

class ActivityLogs extends StatefulWidget {
  const ActivityLogs({super.key});

  @override
  State<ActivityLogs> createState() => _ActivityLogsState();
}

class _ActivityLogsState extends State<ActivityLogs> {
  final SupabaseService authService = SupabaseService();
  List<ActivityLog> activityList = List.empty();
  loadActivityLogs() async {
    await authService
        .getActivityLogs('2024-08-01 00:00:00', '2024-09-30 23:59:59')
        .then((value) {
      setState(() {
        activityList = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadActivityLogs();
  }

  Widget loadActivityCard(ActivityLog log) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: Colors.grey, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${log.businessName}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${log.action}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${log.createdAt}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  '${log.totalAmount} MMK',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  '${log.username}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: activityList.length,
        //itemBuilder: (context, index) => getNames(names[index])),
        itemBuilder: (context, index) => loadActivityCard(activityList[index]));
  }
}
