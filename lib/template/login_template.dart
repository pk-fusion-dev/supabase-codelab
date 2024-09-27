import 'package:flutter/material.dart';
import 'package:supabase_lab/pages/login_page.dart';
import 'package:supabase_lab/pages/register_page.dart';

class LoginTemplate extends StatelessWidget {
  const LoginTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Supabase Lab',
          ),
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
