import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_lab/model/activity_logs.dart';
import 'dart:async';
import 'package:supabase_lab/model/user_model.dart';
import 'dart:developer' as dev;

class SupabaseService {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  Future<String> fetchSampleData() async {
    var data = await supabaseClient.from('demo').select().eq('id', 1);
    return ('Data: $data');
  }

  Future<String> register(
      String email, String password, String username, String role) async {
    try {
      await supabaseClient.from('users').insert({
        'email': email,
        'password': password, // Consider hashing passwords
        'username': username,
        'role': role,
        'created_at': DateTime.now().toIso8601String(),
      });
      return 'SUCCESS';
    } catch (e) {
      return 'User already exist';
    }
  }

  Future<FusionUser> login(String username, String password) async {
    try {
      final res = await supabaseClient
          .from('users')
          .select() // Assuming you store email for Supabase authentication
          .eq('username', username)
          .eq('password', password)
          .single();
      FusionUser fusionUser = FusionUser.fromJson(res);
      return fusionUser;
    } catch (e) {
      return FusionUser();
    }
  }

  Future<FusionUser> checkUserExist(String value) async {
    try {
      final res = await supabaseClient
          .from('users')
          .select() // Assuming you store email for Supabase authentication
          .or('username.eq.$value,email.eq.$value')
          .single();
      FusionUser fusionUser = FusionUser.fromJson(res);
      return fusionUser;
    } catch (e) {
      return FusionUser();
    }
  }

  Future<FusionUser> updateUser(String username, String email, String password,
      String role, int id) async {
    try {
      final res = await supabaseClient
          .from('users')
          .update({
            'username': username,
            'email': email,
            'password': password,
            'role': role
          })
          .eq('id', 14)
          .select();
      FusionUser fusionUser = FusionUser.fromJson(res.single);
      return fusionUser;
    } catch (e) {
      dev.log(e.toString());
      return FusionUser();
    }
  }

  Future<String> deleteUser(int id) async {
    try {
      await supabaseClient.from('users').delete().eq('id', id);
      return 'SUCCESS';
    } catch (e) {
      return 'User Not Exist';
    }
  }

  Future<List<FusionUser>> findAllUser() async {
    List<FusionUser> users = List.empty();
    try {
      final res = await supabaseClient
          .from('users')
          .select()
          .neq('role', 'super_admin');

      users = res.map((e) => FusionUser.fromJson(e)).toList();

      return users;
    } catch (e) {
      return users;
    }
  }

  Future<List<ActivityLog>> getActivityLogs(
      String startDate, String endDate) async {
    List<ActivityLog> activityLogs = List.empty();
    try {
      final res = await supabaseClient
          .from('activity_logs')
          .select()
          .gte('created_at', (startDate)) //format 2024-08-01 00:00:00
          .lte('created_at', (endDate))
          .order('created_at', ascending: false); //format 22024-09-30 23:59:59
      activityLogs = res.map((e) => ActivityLog.fromJson(e)).toList();
      return activityLogs;
    } catch (e) {
      return activityLogs;
    }
  }

  Future<String> saveActivityLog(String businessName, String action,
      String username, int totalAmount) async {
    try {
      await supabaseClient.from('activity_logs').insert({
        'business_name': businessName,
        'created_at': DateTime.now().toIso8601String(),
        'action': action,
        'username': username,
        'total_amount': totalAmount
      });
      return 'SUCCESS';
    } catch (e) {
      return 'ERROR';
    }
    // Action Type
    // ACTIVATE_LICENSE,SWITCH_LICENSE,ACTIVATE_PC_CLIENT,ACTIVATE_MOBILE_CLIENT,ACTIVATE_STARMAN,EXTEND_TRIAL,EXTEND_LICENSE
  }

  void streamToRealtime() {
    supabaseClient.from('activity_logs').stream(primaryKey: ['id']);
  }

  void subscribeActivityLogs() {
    supabaseClient
        .channel('codelab:activity_logs')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
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

  Future<String> uploadFile(File file) async {
    try {
      // ignore: unused_local_variable
      final res = await supabaseClient.storage
          .from('lab_videos') // Replace with your storage bucket name
          .upload(
            'sample/${file.path.split('/').last}',
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      return 'SUCCESS';
    } catch (e) {
      return 'ERROR';
    }
  }

  Future<List<FileObject>> getFilesInBucket() async {
    try {
      // ignore: unused_local_variable
      final res = await supabaseClient.storage.from('lab_videos').list(
          path: 'sample',
          searchOptions: const SearchOptions(
              sortBy: SortBy(
                  column: 'created_at',
                  order: 'desc'))); // Replace with your storage bucket name

      return res;
    } catch (e) {
      return List.empty();
    }
  }

  Future<String?> getFilesURL(File file) async {
    try {
      // ignore: unused_local_variable
      final res = supabaseClient.storage.from('lab_videos').getPublicUrl(
          'sample/${file.path.split('/').last}'); // Replace with your storage bucket name
      dev.log(res);
      return res;
    } catch (e) {
      return null;
    }
  }
}
