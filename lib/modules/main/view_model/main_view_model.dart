import 'package:flutter/material.dart';

import '../../../common/providers/loader_state.dart';
import '../../../common/routes.dart';
import '../../../services/db_service.dart';

class MainViewModel extends LoaderViewModel {
  final DbService dbService = DbService();
  MainViewModel();

  @override
  loadData({BuildContext? context, bool forceReload = false}) async {
    markAsLoading();
    List<Future> list = [
      sharedPreferencesService.initialize(),
      dbService.initialize(),
    ];
    await Future.wait(list);

    navigatorService.toRoute(HomePage.route, pushAndReplace: true);
    debugPrint('MainViewModel loadData() - RETURN');
  }
}
