import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_lab/model/activity_logs.dart';
import 'package:supabase_lab/model/lead_model.dart';
import 'package:supabase_lab/model/mesage.dart';
import 'dart:async';
import 'package:supabase_lab/model/user_model.dart';
//import 'dart:developer' as dev;

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

      // Local file cleanup
      if (file.existsSync()) file.deleteSync();
      return 'SUCCESS';
    } catch (e) {
      return 'ERROR';
    }
  }

  Future<String> deleteFile(String fileName) async {
    try {
      // ignore: unused_local_variable
      final res = await supabaseClient.storage
          .from('lab_videos') // Replace with your storage bucket name
          .remove(['sample/$fileName']);

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

      return res;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveMessage(
      String userFrom, String userTo, String content) async {
    try {
      final message =
          Message.create(content: content, userFrom: userFrom, userTo: userTo);

      await supabaseClient.from('message').insert(message.toMap());
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> markAsRead(String messageId) async {
    await supabaseClient
        .from('message')
        .update({'mark_as_read': true}).eq('id', messageId);
  }

  Stream<List<Message?>> getMessages(String currentUser, String userTo) {
    var msg = supabaseClient
        .from('message')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((maps) => maps
            .map((item) {
              if ((item['user_from'] == currentUser &&
                      item['user_to'] == userTo) ||
                  (item['user_from'] == userTo &&
                      item['user_to'] == currentUser)) {
                return Message.fromJson(item, currentUser);
              }
            })
            .where((item) => item != null)
            .toList());

    return msg;

//            .map((item) => Message.fromJson(item, user))
/*
  Stream<List<Message>> getMessages(String currentUser) {
    dev.log('in stream');
    return supabaseClient
        .from('message')
        
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((maps) => maps.map((item) {
              dev.log(item['content']);
              return Message.fromJson(item, currentUser);
            }).toList());
  }
  */
  }

  //leads module

  Future<LeadModel> saveLeadModel(LeadModel lead) async {
    try {
      final res = await supabaseClient.from('leads').insert({
        'created_at': DateTime.now().toIso8601String(),
        'name': lead.name,
        'phone': lead.phone,
        'source': lead.source,
        'app': lead.app,
        'action': lead.action,
        'remark': lead.remark,
        'user_id': lead.userId
      }).select();
      LeadModel leadModel = LeadModel.fromJson(res.single);

      return leadModel;
    } catch (e) {
      return LeadModel();
    }
    //app {FusionPOS_PC,FusionPOS_Mobile,RS,Future_App}
    //action{phone_call,viber_connect,trial,video_tutorials,online_training}
    //source{registration,ads,fb_group,google,on_ground,fb_page}
  }

  Future<LeadModel> updateLeadModel(LeadModel lead) async {
    try {
      final res = await supabaseClient
          .from('leads')
          .update({
            'name': lead.name,
            'phone': lead.phone,
            'source': lead.source,
            'app': lead.app,
            'action': lead.action,
            'remark': lead.remark,
            'user_id': lead.userId
          })
          .eq('id', lead.id as int)
          .select();
      LeadModel leadModel = LeadModel.fromJson(res.single);
      return leadModel;
    } catch (e) {
      return LeadModel();
    }
  }

  Future<List<LeadModel>> findAllLeads() async {
    List<LeadModel> leads = List.empty();
    try {
      final res = await supabaseClient
          .from('leads')
          .select()
          .order('created_at', ascending: false);
      ;

      leads = res.map((e) => LeadModel.fromJson(e)).toList();

      return leads;
    } catch (e) {
      return leads;
    }
  }

  Future<List<LeadModel>> leadsByKeyword(String keyword) async {
    List<LeadModel> leads = List.empty();
    try {
      final res = await supabaseClient
          .from('leads')
          .select()
          .ilike('name', '$keyword%')
          .order('created_at', ascending: false);
      
      leads = res.map((e) => LeadModel.fromJson(e)).toList();

      return leads;
    } catch (e) {
      return leads;
    }
  }

//
  /*
    CREATE OR REPLACE FUNCTION codelab.sql_query(sql TEXT) RETURNS TABLE(
    id bigint,
    created_at timestamp,
    name text,
    phone text,
    source text,
    app text,
    action text,
    remark text,
    user_id bigint) AS $$ 
    BEGIN 
    RETURN QUERY EXECUTE sql; 
    END; 
    $$ LANGUAGE plpgsql;
    */

  //select codelab.sql_query('select * from codelab.leads');

  Future<List<LeadModel>> leadsByFilter(
      String source, String app, String startDate, String endDate) async {

    List<LeadModel> leads = List.empty();
    var query =
        'SELECT * FROM leads WHERE created_at BETWEEN \'$startDate\' AND \'$endDate\' ';

    if (source.toUpperCase() != 'ALL') {
      query += 'AND source =\'$source\' ';
    }

    if (app.toUpperCase() != 'ALL') {
      query += 'AND app =\'$app\' ';
    }

    try {
      final res = await supabaseClient
          .schema('codelab')
          .rpc('sql_query', params: {'sql': query}).select().order('created_at', ascending: false);


      leads = res.map((e) => LeadModel.fromJson(e)).toList();
      for (LeadModel model in leads) {
        log(model.toString());
      }

      return leads;
    } catch (e) {
      return leads;
    }
  }
}
