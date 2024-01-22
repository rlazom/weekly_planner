import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/extensions.dart';
import '../../../common/widgets/flex_loading_widget.dart';
import '../view_model/main_view_model.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider<MainViewModel>(
        create: (context) => MainViewModel(),
        child: Consumer<MainViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.normal) {
              viewModel.scheduleLoadService(viewModel.loadData);
              return const FlexLoadingWidget();
            }
            return const FlexLoadingWidget();
          },
        ),
      ),
    );
  }
}
