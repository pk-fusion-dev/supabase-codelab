import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_lab/model/mesage.dart';
import 'package:supabase_lab/model/user_model.dart';
import 'package:supabase_lab/network/supabase_service.dart';
import 'package:supabase_lab/pages/chat_bubble.dart';

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
  String? userFrom;
  String? userTo;
  @override
  initState() {
    super.initState();

    loadUserList();
  }

  final _formKey = GlobalKey<FormState>();
  final _msgController = TextEditingController();

  Future<void> _submit() async {
    final text = _msgController.text;

    if (text.isEmpty) {
      return;
    }

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await _authService.saveMessage(userFrom!, userTo!, text).whenComplete(() {
        _msgController.clear();
      });
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
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
      child: InkWell(
        child: ListTile(
          leading: const Icon(
            Icons.person_pin,
          ),
          title: Text(' ${user.username}'),
          subtitle: Text('${user.role}'),
          trailing: const CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 12,
            child: Icon(
              Icons.chat,
              color: Colors.white,
              size: 15,
            ),
          ),
        ),
        onTap: () {
          prefs.setString('chat_with', user.username!);
          _changePage();
        },
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
    userFrom = prefs.getString('username');
    userTo = prefs.getString('chat_with');

    return StreamBuilder<List<Message?>>(
      stream: _authService.getMessages(userFrom!, userTo!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          final messages = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];

                      return ChatBubble(message: message!);
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _msgController,
                        decoration: InputDecoration(
                            labelText: 'Message',
                            suffixIcon: IconButton(
                              onPressed: _submit,
                              icon: const Icon(
                                Icons.send_rounded,
                                color: Colors.blueAccent,
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0)
              ],
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return currentPage;
  }
}
