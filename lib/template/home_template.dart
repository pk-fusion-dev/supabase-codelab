import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_lab/pages/activity_logs_page.dart';
import 'package:supabase_lab/pages/chat_page.dart';
import 'package:supabase_lab/pages/add_activity_log.dart';
import 'package:supabase_lab/pages/upload_video.dart';
import 'package:supabase_lab/pages/video_content_page.dart';
// ignore: unused_import
import 'dart:developer' as dev;

class HomeTemplate extends StatefulWidget {
  const HomeTemplate({super.key});

  @override
  State<HomeTemplate> createState() => _HomeTemplateState();
}

class _HomeTemplateState extends State<HomeTemplate> {
  int _fabIndex = 0;
  int _naviBarIndex = 0;
  int _pageIndex = 0;
  var _title = 'Activity Logs';
  final SupabaseClient supabase = Supabase.instance.client;

  final List<Widget> pages = [
    const ActivityLogs(),
    const VideoContent(),
    const ChatUserPage(),
    const NewActivityLog(),
    const UploadVideo(),
  ];

  @override
  initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          {
            _title = 'Activity Logs';
            _pageIndex = 0;
            _naviBarIndex = 0;
            _fabIndex = 0;
          }
          break;
        case 1:
          {
            _title = 'Uploaded Videos';
            _pageIndex = 1;
            _naviBarIndex = 1;
            _fabIndex = 1; //-1 is not show
          }
          break;
        case 2:
          {
            _title = 'Chat';
            _pageIndex = 2;
            _naviBarIndex = 2;
            _fabIndex = -1;
          }
          break;
        case 3:
          {
            _title = 'Logout';
            _naviBarIndex = 3;
            _fabIndex = -1; //not show
            _logout();
          }
          break;
      }
    });
  }

  void _onFabTap(int index) {
    setState(() {
      switch (index) {
        case 200:
          {
            _title = 'New Activity Log';
            _pageIndex = 3;
            _naviBarIndex = 0;
            _fabIndex = -1;
          }
          break;
        case 201:
          {
            _title = 'Upload Video';
            _pageIndex = 4;
            _naviBarIndex = 1;
            _fabIndex = -1;
          }
          break;
        case 202:
          {
            _title = 'Chat';
            _pageIndex = 5;
            _naviBarIndex = 2;
            _fabIndex = -1;
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

  FloatingActionButton? _getFAB() {
    if (_fabIndex == 0) {
      return FloatingActionButton(
        //backgroundColor: Colors.deepPurple,
        mini: false,
        onPressed: () {
          _onFabTap(200);
        },
        child: const Icon(Icons.add, color: Colors.white),
      );
    } else if (_fabIndex == 1) {
      return FloatingActionButton(
        //backgroundColor: Colors.deepPurple,
        mini: false,
        onPressed: () {
          _onFabTap(201);
        },
        child: const Icon(Icons.video_collection, color: Colors.white),
      );
    }
    return null;
  }

  Future<void> removeSession() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
        ),
      ),
      body: pages[_pageIndex],
      floatingActionButton: _getFAB(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _naviBarIndex, //New
        onTap: _onItemTapped, //New
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
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
            icon: Icon(Icons.chat),
            label: 'Chat',
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
