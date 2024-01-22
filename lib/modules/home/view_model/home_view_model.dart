import 'package:flutter/material.dart';
import 'package:weekly_planner/common/enums.dart';
import 'package:weekly_planner/models/task.dart';

import '../../../common/providers/loader_state.dart';
import '../../../common/routes.dart';
import '../../../repository/task/task_repository.dart';
import '../../../services/db_service.dart';
// import '../component/task/view/task_details.dart';

class HomeViewModel extends LoaderViewModel {
  final DbService dbService = DbService();
  final TaskRepository taskRepository = TaskRepository(extendedPath: 'task');
  // final ValueNotifier<List<Map>?> taskListNotifier = ValueNotifier<List<Map>?>(null);
  final ValueNotifier<List<Task>?> taskListNotifier = ValueNotifier<List<Task>?>(null);

  HomeViewModel();

  @override
  loadData({BuildContext? context, bool forceReload = false}) async {
    debugPrint('HomeViewModel - loadData()');

    List<Future> list = [
      _getCurrentWeek(forceReload: forceReload),
    ];

    await Future.wait(list);
    markAsSuccess();
  }

  _getCurrentWeek({bool forceReload = false}) async {
    taskListNotifier.value = await taskRepository.getCurrentWeekTasks(source: forceReload ? SourceType.remote : null);
  }

  navigateToDetails({Task? task}) {
    debugPrint('HomeViewModel - navigateToDetails(task: "${task?.title}")');
    navigatorService.toRoute(TaskDetailsPage.route, arguments: task);
  }
}
