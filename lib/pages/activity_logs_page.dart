import 'package:flutter/material.dart';
import 'package:supabase_lab/model/activity_logs.dart';
import 'package:supabase_lab/network/supabase_service.dart';
import 'package:supabase_lab/util/date_util.dart';

class ActivityLogs extends StatefulWidget {
  const ActivityLogs({super.key});

  @override
  State<ActivityLogs> createState() => _ActivityLogsState();
}

class _ActivityLogsState extends State<ActivityLogs> {
  final SupabaseService authService = SupabaseService();
  List<ActivityLog> activityList = List.empty();

  String today = DateUtil().today();
  String yesterday = DateUtil().yesterday();
  String selectedDate = 'Today';
  DateTime now = DateTime.now();
  String startDate = '';
  String endDate = '';

  loadActivityLogs(String startDate, String endDate) async {
    await authService.getActivityLogs(startDate, endDate).then((value) {
      setState(() {
        activityList = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startDate = DateUtil().getFirstDayOfMonth(now.year, now.month);
    endDate = DateUtil().getLastDayOfMonth(now.year, now.month);
    loadActivityLogs(startDate, endDate);
  }

  void _onDateSelect(String value) {
    setState(() {
      selectedDate = value;
    });
    if (value == 'Today') {
      loadActivityLogs('$today 00:00:00', '$today 23:59:59');
    } else if (value == 'Yesterday') {
      loadActivityLogs('$yesterday 00:00:00', '$yesterday 23:59:59');
    } else if (value == 'This Month') {
      startDate = DateUtil().getFirstDayOfMonth(now.year, now.month);
      endDate = DateUtil().getLastDayOfMonth(now.year, now.month);
      loadActivityLogs(startDate, endDate);
    } else {
      startDate = DateUtil().getFirstDayOfMonth(now.year, now.month - 1);
      endDate = DateUtil().getLastDayOfMonth(now.year, now.month - 1);
      loadActivityLogs(startDate, endDate);
    }
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
                  '${log.createdAt!.day}/${log.createdAt!.month}/${log.createdAt!.year}',
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
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(
            selectedDate,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.menu_outlined),
            onSelected: (value) {
              _onDateSelect(value);
            },
            itemBuilder: (BuildContext bc) {
              return const [
                PopupMenuItem(
                  value: 'Today',
                  child: Text("Today"),
                ),
                PopupMenuItem(
                  value: 'Yesterday',
                  child: Text("Yesterday"),
                ),
                PopupMenuItem(
                  value: 'This Month',
                  child: Text("This Month"),
                ),
                PopupMenuItem(
                  value: 'Last Month',
                  child: Text("Last Month"),
                )
              ];
            },
          ),
        ]),
        const SizedBox(
          height: 5,
        ),
        activityList.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                    //scrollDirection: Axis.vertical,
                    itemCount: activityList.length,
                    itemBuilder: (context, index) =>
                        loadActivityCard(activityList[index])),
              )
            : const Center(
                child: Text(
                'NO RECORD.',
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.bold),
              ))
      ],
    );
  }
}
