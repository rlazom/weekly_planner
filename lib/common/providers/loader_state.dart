import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../services/navigation_service.dart';
import '../../services/shared_preferences_service.dart';
import '../general_functions.dart';

enum LoaderState {
  NORMAL,
  LOADING,
  FAILED,
  SUCCESS,
}

abstract class LoaderViewModel extends ChangeNotifier {
  final NavigationService navigatorService = NavigationService();
  final SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
  LoaderState _state = LoaderState.NORMAL;
  Exception? error;
  bool _disposed = false;

  bool get disposed => _disposed;

  bool get loading => _state == LoaderState.LOADING;

  bool get notLoading => !loading;

  bool get success => _state == LoaderState.SUCCESS;

  bool get failed => _state == LoaderState.FAILED;

  bool get normal => _state == LoaderState.NORMAL;

  LoaderState get state => _state;

  loadData({BuildContext? context, bool forceReload = false});

  @protected
  void updateState(LoaderState state, {bool emitEvent = true}) {
    if (_state == state) {
      return;
    }
    _state = state;
    if (!disposed && emitEvent) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> load(Future<void> Function() loader) async {
    try {
      markAsLoading();
      await loader();
      markAsSuccess();
    } on Exception catch (error) {
      markAsFailed(error: error);
      rethrow;
    }
  }

  void markAsLoading() {
    updateState(LoaderState.LOADING);
  }

  void markAsSuccess({dynamic arguments}) {
    error = null;
    updateState(LoaderState.SUCCESS);
  }

  void markAsFailed({Exception? error}) {
    this.error = error;
    updateState(LoaderState.FAILED);
  }

  void markAsNormal({bool emitEvent = true}) {
    error = null;
    updateState(LoaderState.NORMAL, emitEvent: emitEvent);
  }

  void scheduleLoadService(VoidCallback fn) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      fn();
    });
  }

  void showSnackBarMsg(
      {required BuildContext context, required String msg, Color? color}) {
    scheduleLoadService(() => showSnackBarMsgContext(
        context: context, msg: msg, backgroundColor: color));
  }
}
