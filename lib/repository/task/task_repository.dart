import 'package:weekly_planner/models/task.dart';

import '../../common/enums.dart';
import '../flex_master/flex_master_repository.dart';
import 'data_sources/task_data_source_local.dart';
import 'data_sources/task_data_source_remote.dart';

class TaskRepository extends FlexMasterRepository {
  TaskRepository({required extendedPath})
      : super(
            local: TaskDataSourceLocal(),
            remote: TaskDataSourceRemote(),
            extendedPath: extendedPath);

  Future<List<Task>> getCurrentWeekTasks({SourceType? source}) async {
    Map<SourceType, Function> allSources = {
      SourceType.local: local.getCurrentWeekTasks,
      SourceType.remote: remote.getCurrentWeekTasks,
    };

    List result = await getAllItemsData(
      allSources: allSources,
      source: source,
    );
    return List<Task>.from(result);
  }
}
