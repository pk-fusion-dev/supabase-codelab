// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_lab/network/supabase_service.dart';
import 'package:supabase_lab/template/home_template.dart';
import 'package:supabase_lab/template/login_template.dart';
import 'dart:developer' as dev;

void main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    postgrestOptions: const PostgrestClientOptions(schema: 'codelab'),
    realtimeClientOptions: const RealtimeClientOptions(
      eventsPerSecond: 2,
    ),
  );
  //var service = SupabaseService();
  //service.streamToRealtime();
  //service.subscribeActivityLogs();
  runApp(const MyApp());
}

// ignore: unused_element

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorSchemeSeed: const Color.fromARGB(255, 53, 55, 66),
          useMaterial3: true),
      initialRoute: 'login_screen',
      //home: Home()
      routes: {
        'login_screen': (context) => const LoginTemplate(),
        'home_screen': (context) => const HomeTemplate()
      },
    );
  }
}
