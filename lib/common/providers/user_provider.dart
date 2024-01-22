import 'package:flutter/foundation.dart' show ChangeNotifier, debugPrint;
import 'package:package_info_plus/package_info_plus.dart';
import '../../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  PackageInfo? packageInfo;
  String? appVersion;

  UserProvider() {
    updateAppInfo();
  }

  Future _initializePackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  User? get user => _user;

  void setUser(User? user, {bool forceFetchData = false}) {
    _user = user;
    notifyListeners();
    // if(forceFetchData) {
    //   fetchRemoteData();
    // }
  }

  // void clearUser({bool forceFetch = true}) {
  //   _user = null;
  //   notifyListeners();
  //   if (forceFetch) {
  //     fetchRemoteData();
  //   }
  // }

  updateAppInfo() async {
    if (packageInfo == null) {
      await _initializePackageInfo();
    }
    appVersion = '${packageInfo?.version}.${packageInfo!.buildNumber}';
    debugPrint('UserProvider - appVersion: "$appVersion"');
  }
}
