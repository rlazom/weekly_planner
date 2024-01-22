import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:path/path.dart' as path;

import '../l10n/app_localizations.dart';

extension StringX on String {
  Color get hexToColor =>
      Color(int.parse(substring(1, 7), radix: 16) + 0xFF000000);

  int toInt() => int.parse(this);

  Uri toUri() => Uri.parse(this);

  String toShortString() {
    return split('.').last.toLowerCase();
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  DateTime get fromTimeStamp {
    return DateTime.fromMillisecondsSinceEpoch(toInt() * 1000);
  }

  DateTime fromIso8601() {
    return DateTime.parse(this);
  }

  String get normalize {
    String decodedUrl = Uri.decodeFull(this);
    return path.normalize(decodedUrl);
    // return path.normalize(this);
  }
}

extension ColorX on Color {
  String get colorToHex {
    return '#${value.toRadixString(16).padLeft(8, '0')}';
  }
}

extension StringNullX on String? {
  String? get urlFileName {
    return this?.split('?').first.split('/').last.trim();
  }
}

extension IntX on num {
  String toStringAndFill({int length = 2, String value = '0'}) => toString().padLeft(length, value);
}

extension DoubleX on double {
  double truncateToDecimals(int decimals) =>
      double.parse(toStringAsFixed(decimals));
}

extension DurationX on Duration {
  String toTimeFormattedString() {
    String twoDigitSeconds = inSeconds.remainder(60).toStringAndFill();
    String twoDigitMinutes = '${inMinutes.remainder(60).toStringAndFill()}:';
    String twoDigitHours = inHours == 0 ? '' : '${inHours.toStringAndFill()}:';

    String finalStr = '$twoDigitHours$twoDigitMinutes$twoDigitSeconds';
    return finalStr;
  }
}

extension DateTimeX on DateTime {
  int get toTimeStamp => millisecondsSinceEpoch ~/ 1000;
  // String get toIso8601 => this.toUtc().toIso8601String().replaceAll('-', '');
  String get toIso8601 => DateFormat("yyyyMMdd'T'HHmmss'Z'").format(toUtc());
  String get toShortFormat => DateFormat.yMd().format(toUtc());
  DateTime get weekStartFromDate {
    DateTime today = this;
    int currentWeekday = today.weekday;
    int daysToSubtract = currentWeekday - DateTime.monday;
    DateTime startMonday = today.subtract(Duration(days: daysToSubtract));
    return startMonday;
  }
}


extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  Size get sizeOf {
    return MediaQuery.sizeOf(this);
  }

  Orientation get orientationOf {
    return MediaQuery.orientationOf(this);
  }

  bool get isLandscape {
    return MediaQuery.orientationOf(this) == Orientation.landscape;
  }

  bool get isMobile {
    final screenWidth = MediaQuery.sizeOf(this).width;
    return screenWidth < 600;
  }
  bool get isTablet {
    final screenWidth = MediaQuery.sizeOf(this).width;
    return screenWidth >= 600;
  }

  String translate(String key, {String param = ''}) {
    return AppLocalizations.of(this)!.translate(key, param: param);
  }
}

extension ListX on List {
  bool compareLists(List list) {
    if (length != list.length) {
      return false;
    }

    for (var item in this) {
      if (!list.contains(item)) {
        return false;
      }
    }

    return true;
  }
}