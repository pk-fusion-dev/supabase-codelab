import 'package:flutter/material.dart';
import 'package:supabase_lab/pages/activity_logs_page.dart';
import 'package:supabase_lab/pages/profile_page.dart';
import 'package:supabase_lab/pages/video_content_page.dart';

class HomeTemplate extends StatefulWidget {
  const HomeTemplate({super.key});

  @override
  State<HomeTemplate> createState() => _HomeTemplateState();
}

class _HomeTemplateState extends State<HomeTemplate> {
  int _selectedIndex = 0;
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
          }
          break;
        case 1:
          {
            _title = 'Videos';
          }
          break;
        case 2:
          {
            _title = 'Profile';
          }
          break;
      }
    });
  }

  final List<Widget> _pages = [
    const ActivityLogs(),
    const VideoContent(),
    const Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, //New
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
            icon: Icon(Icons.account_circle_sharp),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
