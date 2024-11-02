// ignore_for_file: unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_lab/model/lead_model.dart';
import 'package:supabase_lab/network/supabase_service.dart';
import 'package:supabase_lab/template/home_template.dart';
import 'package:supabase_lab/template/login_template.dart';
import 'dart:developer' as dev;
import 'package:supabase_lab/theme/fusion_theme.dart';

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

  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();

  var service = SupabaseService();
  //service.streamToRealtime();
  //service.subscribeActivityLogs();
  LeadModel lead = LeadModel(
      name: 'SPA Store',
      phone: '096654332',
      source: 'ADS',
      app: 'FusionPOS_PC',
      action: 'Trial',
      remark: 'ph call',
      userId: 2);
  //service.saveLeadModel(lead);

  LeadModel leadModel = LeadModel(
      id: 2,
      name: 'MTK Store',
      phone: '095418000',
      source: 'reg',
      app: 'RS',
      action: 'viber_call',
      remark: 'trial',
      userId: 1);
      
  //service.updateLeadModel(leadModel);
  //service.leadsByKeyword('MTK');

  service.leadsByFilter('all', 'all', '2024-11-01 00:00:00', '2024-11-02 23:59:59');
  runApp(const MyApp());
}

// ignore: unused_element

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.fusionBlue,
      initialRoute: 'login_screen',

      //home: Home()
      routes: {
        'login_screen': (context) => const LoginTemplate(),
        'home_screen': (context) => const HomeTemplate(),
      },
    );
  }
}
