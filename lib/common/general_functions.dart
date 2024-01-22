import 'dart:async';
import 'dart:convert';
import 'dart:io' show Directory;
import 'dart:math';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'enums.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

SnackBar _getSnackBar({required String msg,
  required Color? textColor,
  Color? backgroundColor,
  Duration? duration}) {
  return SnackBar(
    key: const Key('scaffoldKeySnackBar'),
    content: Text(
      msg,
      style: TextStyle(color: textColor),
    ),
    duration: duration ?? const Duration(milliseconds: 3000),
    backgroundColor: backgroundColor,
  );
}

Color? _getTextColor(BuildContext context) =>
    Theme
        .of(context)
        .textTheme
        .headlineMedium!
        .color;

Color _getBackgroundColor(BuildContext context) =>
    Theme
        .of(context)
        .primaryColor;

void showSnackBarMsgContext({required BuildContext context,
  required String msg,
  Color? textColor,
  Color? backgroundColor,
  Duration? duration}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  textColor = textColor ?? _getTextColor(context);
  backgroundColor =
  backgroundColor ?? _getBackgroundColor(context);
  ScaffoldMessenger.of(context).showSnackBar(_getSnackBar(
      msg: msg,
      textColor: textColor,
      backgroundColor: backgroundColor,
      duration: duration));
}

isVideoValid(video) {
  if (video != null) {
    final ext = path.extension(video);
    return ext != '' && ext.toLowerCase() == '.mp4';
  }
  return false;
}

String getBaseUrl(video) {
  final parse = Uri.parse(video);
  final uri = parse.query != '' ? parse.replace(query: '') : parse;
  String url = uri.toString();
  if (url.endsWith('?')) url = url.replaceAll('?', '');
  return url;
}

Future<String> getLocalCacheFilesRoute(String url,
    {String extendedPath = '',
      bool isAbsolute = false,
      DirectoryType directoryType = DirectoryType.cache}) async {
  Directory temporaryDirectory =
  await _getDirectoryType(directoryType: directoryType);
  String temporaryDirectoryPath =
  isAbsolute ? temporaryDirectory.absolute.path : temporaryDirectory.path;
  url = removeDiacritics(Uri.decodeFull(url)).replaceAll(' ', '_');
  var baseUrl = getBaseUrl(url);
  String fileBaseName = path.basename(baseUrl);
  return path.join(temporaryDirectoryPath, extendedPath, fileBaseName);
}

Future<String> getDirectoryType({DirectoryType? directoryType}) async =>
    (await _getDirectoryType(directoryType: directoryType)).path;

Future<Directory> _getDirectoryType({DirectoryType? directoryType}) {
  switch (directoryType) {
    case DirectoryType.appDocuments:
      {
        return getApplicationDocumentsDirectory();
      }

    case DirectoryType.cache:
      {
        return getTemporaryDirectory();
      }

    default:
      {
        return getTemporaryDirectory();
      }
  }
}

// Future<String> getThumbnailFile(String url) async {
//   String? thumbnailUrl;
//   String baseUrl = getBaseUrl(url);
//   String videoFileUrl;
//
//   String temporaryDirectoryPath = await getDirectoryType();
//   FileInfo? fileInfo = await DefaultCacheManager().getFileFromCache(baseUrl);
//
//   if (fileInfo == null) {
//     videoFileUrl = url;
//   } else {
//     videoFileUrl = fileInfo.file.path;
//     if (Platform.isIOS) {
//       String name = baseUrl
//           .split('/')
//           .last;
//       videoFileUrl = temporaryDirectoryPath + "/" + name;
//     }
//   }
//   thumbnailUrl = await VideoThumbnail.thumbnailFile(
//     video: videoFileUrl,
//     thumbnailPath: temporaryDirectoryPath,
//     imageFormat: ImageFormat.JPEG,
//     timeMs: 1000,
//     quality: 50,
//   );
//   return thumbnailUrl ?? '';
// }

Color getRandomColor() {
  return Colors.primaries[Random().nextInt(Colors.primaries.length)];
}

DateTime getDateFromUnixTimeStamp(int timeStamp) {
  return DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
}

String decodeBase64(String str) {
  String output = base64Url.normalize(str);
  return utf8.decode(base64Url.decode(output));
}

Map<String, dynamic> parseJwt(String token, {bool getHeader = false}) {
  final parts = token.split('.');

  final header = decodeBase64(parts.first);
  final headerMap = json.decode(header);
  if (getHeader) {
    return headerMap;
  }

  if (parts.length != 3) {
    throw Exception('Invalid Token');
  }

  final payload = decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
//  var b = base64UrlEncode(utf8.encode(jsonEncode(headerMap)))+'.'+base64UrlEncode(utf8.encode(jsonEncode(payloadMap)));

  DateTime issuedAt = getDateFromUnixTimeStamp(payloadMap['iat']);
  DateTime expiredAt = getDateFromUnixTimeStamp(payloadMap['exp']);
  payloadMap['iat_date'] = issuedAt;
  payloadMap['exp_date'] = expiredAt;

  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('Invalid Payload');
  }

  return payloadMap;
}