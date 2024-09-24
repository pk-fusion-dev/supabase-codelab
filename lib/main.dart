import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: unused_import
import 'package:supabase_lab/demo/supabase_tester.dart';
import 'package:supabase_lab/template/home_template.dart';
import 'package:supabase_lab/template/login_template.dart';
// ignore: unused_import
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

  //SupabaseTester().saveActivityLog();
  initBackgroundFetch();
  runApp(const MyApp());
}

// ignore: unused_element
void _subscribeToRealtime() {
  final SupabaseClient supabase = Supabase.instance.client;
  supabase.from('demo').stream(primaryKey: ['id']);
  supabase
      .channel('codelab:activity_logs')
      .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'codelab',
          table: 'activity_logs',
          callback: (payload) {
            Fluttertoast.showToast(
                msg: " New Activity Log!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0);
          })
      .subscribe();
}
void initBackgroundFetch() {
  BackgroundFetch.configure(BackgroundFetchConfig(
    minimumFetchInterval: 15, // Minimum interval for background fetch
    stopOnTerminate: false,
    startOnBoot: true,
  ), (String taskId) async {
   final SupabaseClient supabase = Supabase.instance.client;
  supabase.from('demo').stream(primaryKey: ['id']);
  supabase
      .channel('codelab:activity_logs')
      .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'codelab',
          table: 'activity_logs',
          callback: (payload) {
            Fluttertoast.showToast(
                msg: " New Activity Log!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0);
          })
      .subscribe();
    BackgroundFetch.finish(taskId);
  });
}


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
