// ignore_for_file: unused_element

import 'package:supabase_lab/network/supabase_service.dart';
import 'dart:developer' as dev;

class SupabaseTester {

  Future<void> saveActivityLog() async {
    final SupabaseService authService = SupabaseService();
    await authService
        .saveActivityLog('KK beauty','ACTIVATE','Tun Tun',345000)
        .then((value) {
      dev.log(value.toString());
    });
  }

  Future<void> findAllLogs() async {
    final SupabaseService authService = SupabaseService();
    await authService
        .getActivityLogs('2024-08-01 00:00:00', '2024-09-30 23:59:59')
        .then((value) {
      dev.log(value.toString());
    });
  }

  Future<void> findAllUser() async {
    final SupabaseService authService = SupabaseService();
    await authService.findAllUser().then((value) {
      if (value.isEmpty) {
        dev.log("empty user");
      } else {
        dev.log(value.toString());
      }
    });
  }

  Future<void> updateUser(String username, String email, String password,
      String role, int id) async {
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

  Future<void> checkUser(String param) async {
    final SupabaseService authService = SupabaseService();
    await authService.checkUserExist(param).then((value) {
      if (value.email!.isNotEmpty) {
        dev.log("User Exist");
      } else {
        dev.log('No User');
      }
    });
  }
}
