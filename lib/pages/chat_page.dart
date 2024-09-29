
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_lab/model/user_model.dart';
import 'package:supabase_lab/network/supabase_service.dart';

class ChatUserPage extends StatefulWidget {
  const ChatUserPage({super.key});

  @override
  State<ChatUserPage> createState() => _ChatUserPageState();
}

class _ChatUserPageState extends State<ChatUserPage> {
  final SupabaseService _authService = SupabaseService();
  List<FusionUser> userList = List.empty();
  bool isLoading = false;
  Widget currentPage = const SizedBox.shrink();
  late final SharedPreferences prefs;
  @override
  initState() {
    super.initState();

    loadUserList();
  }

  void loadUserList() async {
    isLoading = true;
    prefs = await SharedPreferences.getInstance();
    await _authService.findAllUser().then((value) => {
          setState(() {
            userList = value;
            isLoading = false;
            currentPage = userListPage();
          })
        });
  }

  void _changePage() {
    setState(() {
      currentPage = getChatPage();
    });
  }

  Widget getUserCard(FusionUser user) {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.person_pin,
        ),
        title: Text(' ${user.username}'),
        subtitle: Text('${user.role}'),
        trailing: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          radius: 12,
          child: InkWell(
            child: const Icon(
              Icons.chat,
              color: Colors.white,
              size: 15,
            ),
            onTap: () {
              prefs.setString('chat_with', user.username!);
              _changePage();
            },
          ),
        ),
      ),
    );
  }

  Widget userListPage() {
    return Expanded(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) => getUserCard(userList[index]),
            ),
    );
  }

  Widget getChatPage() {
    String? me = prefs.getString('username');
    String? chatWith = prefs.getString('chat_with');
    return Text('$me chat with $chatWith');
  }

  @override
  Widget build(BuildContext context) {
    return currentPage;
  }
}
