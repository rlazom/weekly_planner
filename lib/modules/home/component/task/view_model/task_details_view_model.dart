import 'package:flutter/material.dart';
import 'package:weekly_planner/models/task.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../common/providers/loader_state.dart';
import '../../../../../repository/task/task_repository.dart';
import '../../../../../services/db_service.dart';

class TaskDetailsViewModel extends LoaderViewModel {
  final DbService dbService = DbService();
  Task? task;
  final TaskRepository taskRepository = TaskRepository(extendedPath: 'task');

  // final ValueNotifier<List<Map>?> taskListNotifier = ValueNotifier<List<Map>?>(null);
  final ValueNotifier<List<Task>?> taskListNotifier =
      ValueNotifier<List<Task>?>(null);

  final form = FormGroup({
    'title': FormControl<String?>(value: '', validators: [Validators.required]),
    'description': FormControl<String?>(value: ''),
    'datetime': FormControl<DateTime?>(value: null),
    'tags': FormControl<String>(value: ''),
    'done': FormControl<bool>(value: false, validators: [Validators.required]),
    'canceled': FormControl<bool>(value: false, validators: [Validators.required]),
  });

  AbstractControl get titleCtr => form.control('title');

  AbstractControl get descriptionCtr => form.control('description');

  AbstractControl get datetimeCtr => form.control('datetime');

  AbstractControl get tagsCtr => form.control('tags');

  AbstractControl get doneCtr => form.control('done');

  AbstractControl get canceledCtr => form.control('canceled');

  String? get title => titleCtr.value;

  set title(value) => titleCtr.value = value;

  String? get description => descriptionCtr.value;

  set description(value) => descriptionCtr.value = value;

  DateTime? get datetime => datetimeCtr.value;

  set datetime(value) => datetimeCtr.value = value;

  String? get tags => tagsCtr.value;

  set tags(value) => tagsCtr.value = value;

  bool get done => doneCtr.value;

  set done(value) => doneCtr.value = value;

  bool get canceled => canceledCtr.value;

  set canceled(value) => canceledCtr.value = value;

  TaskDetailsViewModel();

  @override
  loadData({BuildContext? context, bool forceReload = false}) async {
    debugPrint('TaskDetailsViewModel - loadData()...');

    // debugPrint('TaskDetailsViewModel - loadData() - context != null: "${context != null}", forceReload: "$forceReload"');
    if (context != null && task == null) {
      var routeArguments = ModalRoute.of(context)!.settings.arguments;
      if (routeArguments != null) {
        task = routeArguments as Task;

        title = task!.title;
        description = task!.description;
        datetime = task!.datetime;
        tags = task!.tags.join(', ');
        done = task!.done;
        canceled = task!.canceled;
      }
    }
    debugPrint(
        'TaskDetailsViewModel - loadData()...DONE - task.title: "${task?.title}"');

    markAsSuccess();
  }

  clearField({required String fieldName}) {
    var formCtrl = form.control(fieldName);
    formCtrl.markAsTouched();
    formCtrl.value = null;
  }

  saveData() async {
    debugPrint('TaskDetailsViewModel - saveData()...');
    markAsLoading();

    Task tTask = Task(
      title: title!,
      description: description,
      datetime: datetime,
      tags: tags?.split(', ') ?? [],
      done: done,
      canceled: canceled,
    );
    if (task != null) {
      tTask.id = task!.id;
    }
    await dbService.upsertTask(task: tTask);
    markAsSuccess();
    navigatorService.pop();
  }
}
