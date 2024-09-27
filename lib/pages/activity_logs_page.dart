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
  bool isLoading = false;
  String today = DateUtil().today();
  String yesterday = DateUtil().yesterday();
  String selectedDate = 'This Month';
  DateTime now = DateTime.now();
  String startDate = '';
  String endDate = '';

  loadActivityLogs(String startDate, String endDate) async {
    isLoading = true;
    await authService.getActivityLogs(startDate, endDate).then((value) {
      setState(() {
        activityList = value;
        isLoading = false;
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
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${log.businessName}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '${log.action}',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${log.createdAt!.day}/${log.createdAt!.month}/${log.createdAt!.year}',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(
                  '${log.totalAmount} MMK',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(
                  '${log.username}',
                  style: Theme.of(context).textTheme.displaySmall,
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
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(selectedDate,
                    style: Theme.of(context).textTheme.displayMedium),
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
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold),
                    ))
            ],
          );
  }
}
