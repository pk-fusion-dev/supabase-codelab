import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_lab/template/home_template.dart';
import 'package:supabase_lab/template/login_template.dart';

import 'network/supabase_service.dart';
import 'dart:developer' as dev;

void main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    postgrestOptions: const PostgrestClientOptions(schema: 'codelab'),
  );

  //fetchData().then((value) => dev.log(value));
  //_findAllUser();
  //_checkUser('demo1');
  _updateUser("2", "2", "2222", "R2", 14);

  runApp(const MyApp());
}

// ignore: unused_element
Future<void> _findAllUser() async {
  final SupabaseService authService = SupabaseService();
  await authService.findAllUser().then((value) {
    if (value.isEmpty) {
      dev.log("empty user");
    } else {
      dev.log(value.toString());
    }
  });
}

Future<void> _updateUser(
    String username, String email, String password, String role, int id) async {
  final SupabaseService authService = SupabaseService();
  await authService
      .updateUser(username, email, password, role, id)
      .then((value) {
    if (value.email!.isNotEmpty) {
      dev.log(value.toString());
    } else {
      dev.log("Update Fail");
    }
  });
}

// ignore: unused_element
Future<void> _checkUser(String param) async {
  final SupabaseService authService = SupabaseService();
  await authService.checkUserExist(param).then((value) {
    if (value.email!.isNotEmpty) {
      dev.log("User Exist");
    } else {
      dev.log('No User');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: 'login_screen',
      //home: Home()
      routes: {
        'login_screen': (context) => const LoginTemplate(),
        'home_screen': (context) => const HomeTemplate()
      },
    );
  }
}
