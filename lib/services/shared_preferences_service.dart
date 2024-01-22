import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekly_planner/common/extensions.dart';

enum SharePrefsAttribute {
  itsFirstTime,
  weekTasks,
}

class SharedPreferencesService {
  /// singleton boilerplate
  static final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService._internal();

  factory SharedPreferencesService() {
    return _sharedPreferencesService;
  }

  SharedPreferencesService._internal();
  /// singleton boilerplate

  late SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;

  Future initialize() async => _prefs = await SharedPreferences.getInstance();

  /// CHECK IF IT'S FIRST TIME
  bool getItsFirstTime() => prefs.getBool(SharePrefsAttribute.itsFirstTime.name.toShortString()) ?? true;

  void setItsFirstTime(bool value) {
    prefs.setBool(SharePrefsAttribute.itsFirstTime.name.toShortString(), value);
  }

  String? getWeekTasks() {
    prefs.getString(SharePrefsAttribute.weekTasks.name.toShortString());
  }
  void setWeekTasks(String json) {
    prefs.setString(SharePrefsAttribute.weekTasks.name.toShortString(), json);
  }
}
