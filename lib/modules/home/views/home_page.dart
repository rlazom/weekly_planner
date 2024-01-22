import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weekly_planner/common/extensions.dart';

import '../../../common/constants.dart';
import '../../../common/widgets/flex_loading_widget.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/task.dart';
import '../view_model/home_view_model.dart';

class HomePage extends StatelessWidget {
  static const String route = '/home';
  final HomeViewModel viewModel;
  final GlobalKey<ScaffoldState> _homeScaffoldKey = GlobalKey<ScaffoldState>();

  HomePage({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.normal) {
            viewModel.scheduleLoadService(viewModel.loadData);
          }

          List<Widget> stackList = [];

          stackList.add(ValueListenableBuilder<List<Task>?>(
              valueListenable: viewModel.taskListNotifier,
              builder: (context, taskList, _) {
                List<Widget> dayListWdt = [];

                DateTime today = DateTime.now();
                DateTime startMonday = today.weekStartFromDate;
                for (int i = 0; i < 7; i++) {
                  final day = startMonday.add(Duration(days: i));

                  Widget dayTaskListWdt = const SizedBox.shrink();

                  DateTime initialDt = DateTime(day.year, day.month, day.day);
                  DateTime finalDt =
                      DateTime(day.year, day.month, day.day, 23, 59);
                  List<Task> dayTaskList = [];
                  if (viewModel.taskListNotifier.value?.isNotEmpty ?? false) {
                    dayTaskList = viewModel.taskListNotifier.value!
                        .where((e) =>
                            e.datetime != null &&
                            e.datetime!.isBefore(finalDt) &&
                            e.datetime!.isAfter(initialDt))
                        .toList();
                  }
                  if (dayTaskList.isNotEmpty) {
                    dayTaskListWdt = Column(
                      children: dayTaskList
                          .map((e) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () => viewModel.navigateToDetails(task: e),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 8.0),
                                                  child: Icon((!e.done && !e.canceled) ? Icons.circle_outlined : e.done ? Icons.check_circle : Icons.cancel),
                                                ),
                                                Expanded(child: Text('${e.title} ${e.title}')),
                                              ],
                                            ),
                                            Row(
                                              children: e.tags == null ? [] : e.tags!.map((t) => Padding(
                                                padding: const EdgeInsets.only(right: 4.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white70,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                    child: Text(t, style: const TextStyle(color: Colors.blue),),
                                                  ),
                                                ),
                                              )).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    );
                  }

                  dayListWdt.add(Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Container(
                      color: Colors.white10,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(DateFormat.yMMMMEEEEd('es').format(day), style: TextStyle(color: dayTaskList.isEmpty ? Colors.white24 : null)),
                          dayTaskListWdt,
                        ],
                      ),
                    ),
                  ));
                }

                return RefreshIndicator(
                  onRefresh: () => viewModel.loadData(forceReload: true),
                  child: ListView(
                    children: dayListWdt,
                  ),
                );
              }));

          if (viewModel.loading) {
            stackList.add(const FlexLoadingWidget());
          }

          return Scaffold(
            key: _homeScaffoldKey,
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text(R.appName),
            ),
            body: Stack(
              children: stackList,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: viewModel.navigateToDetails,
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
