import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:weekly_planner/common/extensions.dart';
import 'package:weekly_planner/common/widgets/flex_loading_widget.dart';
import 'package:weekly_planner/models/task.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../view_model/task_details_view_model.dart';

class TaskDetailsPage extends StatelessWidget {
  static const String route = '/task_details';
  final TaskDetailsViewModel viewModel;

  const TaskDetailsPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: ChangeNotifierProvider.value(
        value: viewModel,
        child: Consumer<TaskDetailsViewModel>(
            builder: (context, viewModel, child) {
          if (viewModel.normal) {
            viewModel.scheduleLoadService(
                () => viewModel.loadData(context: context));
            return const FlexLoadingWidget();
          }
          return ReactiveForm(
            formGroup: viewModel.form,
            child: Column(
              children: [
                ReactiveTextField(
                  formControlName: 'title',
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0,
                      horizontal: 0.0,
                    ),
                    labelText: 'Title *',
                    suffixIcon: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => viewModel.clearField(fieldName: 'title'),
                      child: const Icon(Icons.clear),
                    ),
                  ),
                ),
                ReactiveTextField(
                  formControlName: 'description',
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0,
                      horizontal: 0.0,
                    ),
                    labelText: 'Description',
                    suffixIcon: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () =>
                          viewModel.clearField(fieldName: 'description'),
                      child: const Icon(Icons.clear),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: ReactiveValueListenableBuilder<DateTime?>(
                    formControlName: 'datetime',
                    builder: (context, value, child) {
                      return InkWell(
                        onTap: () async {
                          DateTime? dateTime = await showOmniDateTimePicker(context: context);
                          if(dateTime != null) {
                            viewModel.datetime = dateTime;
                          }
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.white, width: 1.0))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.date_range),
                                Expanded(child: Text(viewModel.datetime == null ? '' : DateFormat('d/M/y hh:mm a', 'es').format(viewModel.datetime!))),
                                IconButton(onPressed: () => viewModel.clearField(fieldName: 'datetime'), icon: const Icon(Icons.clear),),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ReactiveTextField(
                  formControlName: 'tags',
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0,
                      horizontal: 0.0,
                    ),
                    labelText: 'Tags',
                    suffixIcon: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => viewModel.clearField(fieldName: 'tags'),
                      child: const Icon(Icons.clear),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Done'),
                          ReactiveCheckbox(
                            formControlName: 'done',
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Canceled'),
                          ReactiveCheckbox(
                            formControlName: 'canceled',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ReactiveFormConsumer(
                  builder: (context, form, child) {
                    print(
                        'ReactiveFormConsumer() - form.valid: "${form.valid}"');
                    return ElevatedButton(
                      child: Container(
                          width: double.infinity,
                          child: Center(child: Text('Submit'))),
                      onPressed: form.valid ? viewModel.saveData : null,
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
