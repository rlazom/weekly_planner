import 'dart:async';
import 'dart:convert';

import '../../../models/task.dart';
import '../../../services/shared_preferences_service.dart';

class TaskDataSourceLocal {
  final SharedPreferencesService sharedPreferencesService = SharedPreferencesService();

  TaskDataSourceLocal() : super();

  Future<List<Task>?> getCurrentWeekTasks() async {
    List<Task>? result;
    var response = sharedPreferencesService.getWeekTasks();

    if (response != null) {
      List list = json.decode(response) as List;
      if(list.isNotEmpty) {
        result = list.map((e) => Task.fromJson(e)).toList();
      }
    }
    return result;
  }
}
