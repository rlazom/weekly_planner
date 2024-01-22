import 'dart:async';
import 'dart:convert';

import '../../../models/task.dart';
import '../../../services/db_service.dart';
import '../../../services/shared_preferences_service.dart';

class TaskDataSourceRemote {
  final DbService dbService = DbService();
  final SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
  TaskDataSourceRemote() : super();


  Future<List<Task>> getCurrentWeekTasks() async {
    // print('TaskDataSourceRemote.getAllTags()...');

    List<Map<String, dynamic>>? data;
    try {
      data = await dbService.fetchCurrentWeek();
    } catch (error) {
      // print('WorkoutDataSourceRemote.getAllWorkoutsDataForCategory() ["${category.name}"]: "$error"');
      rethrow;
    }

    List<Task> taskList = [];
    if(data?.isNotEmpty ?? false) {
      List list = data as List;
      taskList = list.map((e) => Task.fromJson(e)).toList();
      sharedPreferencesService.setWeekTasks(json.encode(taskList));
    }
    return taskList;
  }
}
