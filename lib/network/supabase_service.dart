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
        'role': role
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
}
