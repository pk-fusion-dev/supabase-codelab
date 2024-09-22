import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_lab/pages/activity_logs_page.dart';
import 'package:supabase_lab/pages/new_activity_log.dart';
import 'package:supabase_lab/pages/video_content_page.dart';

class HomeTemplate extends StatefulWidget {
  const HomeTemplate({super.key});

  @override
  State<HomeTemplate> createState() => _HomeTemplateState();
}

class _HomeTemplateState extends State<HomeTemplate> {
  int _selectedIndex = 0;
  int _naviBarIndex = 0;
  var _title = 'Activity Logs';

  @override
  initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          {
            _title = 'Activity Logs';
            _naviBarIndex = 0;
          }
          break;
        case 1:
          {
            _title = 'Videos';
            _naviBarIndex = 1;
          }
          break;
        case 2:
          {
            _naviBarIndex = 2;
            _logout();
          }
          break;
        case 3:
          {
            _title = 'New Activity Log';
          }
          break;
      }
    });
  }

  void _logout() {
    removeSession();
    //Navigator.pushReplacementNamed(context, 'login_screen');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to Logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // Perform an action
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('login_screen');
              },
            ),
          ],
        );
      },
    );
  }

  Widget getLogFAB() {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurple,
      mini: false,
      onPressed: () {
        _onItemTapped(3);
      },
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  Future<void> removeSession() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const ActivityLogs(),
      const VideoContent(),
      const Text(''), //dummy
      const NewActivityLog()
    ];

    var fabs = [getLogFAB(), null, null, null];

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: pages[_selectedIndex],
      floatingActionButton: fabs[_selectedIndex],
      //bottomNavigationBar : _naviBarIndex[index];
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _naviBarIndex, //New
        onTap: _onItemTapped, //New
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.api_sharp),
            label: 'Logs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ondemand_video_sharp),
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}
