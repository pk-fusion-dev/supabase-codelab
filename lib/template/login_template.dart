import 'package:flutter/material.dart';
import 'package:supabase_lab/pages/login.dart';
import 'package:supabase_lab/pages/register.dart';

class LoginTemplate extends StatelessWidget {
  const LoginTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Supabase User Management'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Login'),
              Tab(text: 'Register'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Login(),
            Register(),
          ],
        ),
      ),
    );
  }
}
