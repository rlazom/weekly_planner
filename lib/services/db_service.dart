import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:weekly_planner/common/extensions.dart';

import '../common/keys.dart';
import '../models/task.dart';

class DbService {
  /// singleton boilerplate
  static final DbService _dbService = DbService._internal();

  factory DbService() {
    return _dbService;
  }

  DbService._internal();

  /// singleton boilerplate

  late final SupabaseClient _supabase;

  // SupabaseClient get supabase => _supabase;

  Future initialize() async {
    await Supabase.initialize(
      url: supabaseProjectApiUrl,
      anonKey: supabaseProjectAnonKey,
    );
    _supabase = Supabase.instance.client;
  }

  Future<List<Map<String, dynamic>>?> fetchCurrentWeek() async {
    debugPrint('DbService - fetchCurrentWeek()...');

    List<dynamic> response;
    List<Map<String, dynamic>>? data;


    DateTime today = DateTime.now();
    DateTime startMonday = today.weekStartFromDate;
    DateTime endSunday = startMonday.add(const Duration(days: 6));

    debugPrint('DbService - fetchCurrentWeek() - today: "${today.toShortFormat}", startMonday: "${startMonday.toShortFormat}", endSunday: "${endSunday.toShortFormat}"');

    debugPrint('DbService - fetchCurrentWeek() - fetching data from m_task...');
    try {
      response = await _supabase
          .from('m_task')
          .select()
          .gte('datetime', startMonday)
          .lte('datetime', endSunday);
      debugPrint('DbService - fetchCurrentWeek() - fetching data from m_task...DONE - response: "$response"');
    } catch (e) {
      debugPrint('DbService - fetchCurrentWeek() - fetching data from m_task...ERROR - e: "$e"');
      return null;
    }

    // data = response;
    data = response.map((e) => e).cast<Map<String, dynamic>>().toList();

    return data;
  }

  Future<bool?> upsertTask({required Task task}) async {
    debugPrint('DbService - upsertTask()...');
    List? response;

    // String uuid = productUuid ?? const Uuid().v1();

    debugPrint('DbService - upsertTask() - upserting data to m_task...');
    try {
      response = await _supabase.from('m_task').upsert({
        'id': task.id,
        'title': task.title,
        'description': task.description,
        // 'datetime': task.datetime,
        'datetime': task.datetime == null ? null : DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(task.datetime!),
        'tags': task.tags.join(', '),
        'done': task.done,
        'canceled': task.canceled
      });
      debugPrint('DbService - upsertTask() - upserting data to m_task...DONE - response: "$response"');
    } catch (e) {
      debugPrint('DbService - upsertTask() - upserting data to m_task...ERROR - e: "$e"');
      return null;
    }

    return true;
  }
}
