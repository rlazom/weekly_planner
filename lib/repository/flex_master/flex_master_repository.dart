import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:weekly_planner/common/extensions.dart';

import '../../common/enums.dart';
import '../../common/general_functions.dart';

class FlexMasterRepository {
  final remote;
  final local;
  final String extendedPath;

  const FlexMasterRepository({required this.remote, required this.local, required this.extendedPath});

  Future getAllItemsData({required Map<SourceType, Function> allSources, SourceType? source, bool singleResult = false, bool allowNull = false, param}) async {
    List result = [];

    Map<SourceType, Function> sources = {};
    if (source != null) {
      sources = {source: allSources[source]!};
    } else {
      sources = allSources;
    }

    dynamic response;
    for (var entry in sources.entries) {
      SourceType sourceType = entry.key;
      Function fn = entry.value;
      try {
        response = await (param == null ? fn() : fn(param));
      } catch (e) {
        debugPrint('FlexMasterRepository - getAllItemsData() - CATCH');
        debugPrint('..sourceType: "${sourceType.toString().toShortString()}"');
        debugPrint('..fn: "${fn.toString()}", "${e.toString()}"');
        response = null;
        rethrow;
      }

      if (response != null) {
        if(singleResult) {
          return response;
        }
        result.addAll(response);
        break;
      }
    }

    return (allowNull && result.isEmpty) ? null : result;
  }

  Future<File?> getItemFile({required String fileUrl, required Map<SourceType, Function> allSources, bool matchSizeWithOrigin = true}) async {
    String fileLocalRouteStr =
    await getLocalCacheFilesRoute(fileUrl, extendedPath: extendedPath);

    Map<SourceType, Function> sources = allSources;

    File? response;
    for (Function fn in sources.values) {
      try {
        response =
        await fn(fileUrl: fileUrl, fileLocalRouteStr: fileLocalRouteStr, matchSizeWithOrigin: matchSizeWithOrigin);
      } catch (e) {
        rethrow;
      }

      if (response != null) {
        break;
      }
    }

    return response;
  }
}