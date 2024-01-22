import 'dart:async';
import 'dart:convert';
import 'dart:io' as Io;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weekly_planner/common/extensions.dart';

import 'navigation_service.dart';

class FlexHttpService {
  final http.Client client = http.Client();
  Map<String, String> headers = {};
  final NavigationService navigator = NavigationService();
  // final FlexAuthenticationService authenticationService =
  //     FlexAuthenticationService();
  var token;

  FlexHttpService() {
    _updateHeaders();
  }

  Future postData(
      {required String url, Map<String, dynamic>? extendQuery, Map<String, dynamic>? extendHeaders, Map<String, dynamic>? body,
        Duration timeout = const Duration(seconds: 15)}) async {
    // debugPrint('FlexHttpService - postData()');
    http.Response response;
    try {
      // Map<String, dynamic> extendHeaders = {'Content-Type':'application/json'};
      await _updateHeaders(extendHeaders: extendHeaders);
      url = _updateUrl(url: url, extendQuery: extendQuery);
      // headers.putIfAbsent('Content-Type', () => 'application/json');
      // debugPrint('FlexHttpService - postData() - url: "$url"');
      // debugPrint('FlexHttpService - postData() - headers: "$headers"');
      // debugPrint('FlexHttpService - postData() - body: "$body"');
      response =
      await client.post(url.toUri(), headers: headers, body: body).timeout(timeout);
    } on Io.SocketException catch (_) {
      // debugPrint('FlexHttpService - postData() - ERROR 1 - SocketException');
      throw Exception('Not connected. Socket Exception');
    } on TimeoutException catch (_) {
      // debugPrint('FlexHttpService - postData() - ERROR 2 - TimeoutException');
      throw Exception('Timeout Exception');
    } catch (error) {
      // debugPrint('FlexHttpService - postData() - ERROR 3 - Exception');
      // debugPrint('$error');
      rethrow;
    }

    var data;
    try {
      data = _decodeData(response, forceDecode: true);
    } catch (e) {
      // debugPrint('FlexHttpService - fetchData() - ERROR 4 - decodeData');
      // debugPrint('FlexHttpService - fetchData() - response.statusCode: "${response.statusCode}"');
      if (e is FormatException) {
        // debugPrint('FlexHttpService - fetchData() - ERROR 4 - FormatException');
        throw Exception('${e.message}');
      }
      // debugPrint('FlexHttpService - fetchData() - ERROR 4 - Exception');
      rethrow;
    }

    if ((response.statusCode / 100).toStringAsFixed(0) != '2') {
      var error = _handleErrorMsg(data);
      throw Exception('$error');
    }
    return data;
  }

  Future deleteData(
      {required String url, Map<String, dynamic>? extendHeaders, Map<String, dynamic>? body,
      Duration timeout = const Duration(seconds: 15)}) async {
    debugPrint('FlexHttpService - deleteData()');
    http.Response response;
    try {
      await _updateHeaders(extendHeaders: extendHeaders);
      // debugPrint('FlexHttpService - deleteData() - headers: "$headers"');
      // debugPrint('FlexHttpService - deleteData() - body: "$body"');
      response =
          await client.delete(url.toUri(), headers: headers, body: body).timeout(timeout);
    } on Io.SocketException catch (_) {
      // debugPrint('FlexHttpService - deleteData() - ERROR 1 - SocketException');
      throw Exception('Not connected. Socket Exception');
    } on TimeoutException catch (_) {
      // debugPrint('FlexHttpService - deleteData() - ERROR 2 - TimeoutException');
      throw Exception('Timeout Exception');
    } catch (error) {
      // debugPrint('FlexHttpService - deleteData() - ERROR 3 - Exception');
      // debugPrint('$error');
      rethrow;
    }
    // debugPrint('FlexHttpService - deleteData() - response.statusCode: "${response.statusCode}"');

    var data;
    // debugPrint('FlexHttpService - deleteData() - data: "$data"');
    if(data.toString().trim() == "null" || data.toString().trim().isEmpty) {
      if((response.statusCode / 100).toStringAsFixed(0) != '2') {
        debugPrint('FlexHttpService - deleteData() - data: [null or empty]');
        throw Exception('NO DATA - ERROR CODE: ${response.statusCode}');
      } else {
        return;
      }
    }

    try {
      // debugPrint('FlexHttpService - TRY _decodeData()...');
      data = _decodeData(response, forceDecode: true);
      // debugPrint('FlexHttpService - TRY _decodeData()...DONE');
    } catch (e) {
      debugPrint('FlexHttpService - deleteData() - ERROR 4 - decodeData');
      if (e is FormatException) {
        debugPrint('FlexHttpService - deleteData() - ERROR 4.1 - FormatException e: "$e"');
        throw Exception('${e.message}');
      }
      debugPrint('FlexHttpService - deleteData() - ERROR 4 - Exception');
      rethrow;
    }
    // debugPrint('FlexHttpService - _decodeData()...DONE');

    if ((response.statusCode / 100).toStringAsFixed(0) != '2') {
      var error = _handleErrorMsg(data);
      throw Exception('$error');
    }
    return data;
  }

  Future fetchData(
      {required String url, Map<String, dynamic>? extendHeaders, List<String>? removeHeaders,
      Duration timeout = const Duration(seconds: 15)}) async {
    // debugPrint('FlexHttpService - fetchData() - url: "$url"');
    http.Response response;
    try {
      await _updateHeaders(extendHeaders: extendHeaders, removeHeaders: removeHeaders);
      debugPrint('FlexHttpService - fetchData() - url: "$url", headers: "$headers"');
      response = await client.get(url.toUri(), headers: headers).timeout(timeout);
      // response = await client.get(url.toUri(), headers: null).timeout(timeout);
    } on Io.SocketException catch (_) {
      // debugPrint('FlexHttpService - fetchData() - ERROR [1] - SocketException');
      throw Exception('Not connected. Socket Exception');
    } on TimeoutException catch (_) {
      // debugPrint('FlexHttpService - fetchData() - ERROR [2] - TimeoutException');
      throw Exception('Timeout Exception');
    } catch (error) {
      // debugPrint('FlexHttpService - fetchData() - ERROR [3] - Exception');
      // debugPrint('$error');
      rethrow;
    }

    // debugPrint('FlexHttpService - fetchData() - response: "${response.body}"');
    // debugPrint('FlexHttpService - fetchData() - response.statusCode: "${response.statusCode}"');
    // debugPrint('FlexHttpService - fetchData() - response: "${response.body.toString()}"');

    if (response.statusCode == 204) {
      // debugPrint('FlexHttpService - fetchData() - response.statusCode: "${response.statusCode}"');
      // debugPrint('FlexHttpService - fetchData() - data [${data.toString()}]');
      return null;
    }

    var data;
    try {
      data = _decodeData(response, forceDecode: true);
    } catch (e) {
      debugPrint('FlexHttpService - fetchData() - ERROR - decodeData');
      if (e is FormatException) {
        debugPrint('FlexHttpService - fetchData() - ERROR - FormatException');
        throw Exception('${e.message}');
      }
      debugPrint('FlexHttpService - fetchData() - ERROR - Exception');
      rethrow;
    }

    // debugPrint('FlexHttpService - fetchData() - data: "$data"');
    if (response.statusCode != 200) {
      debugPrint('FlexHttpService - fetchData() - statusCode != 200 - response.statusCode: "${response.statusCode}"');
      // debugPrint('FlexHttpService - fetchData() - statusCode != 200 - data [${data.toString()}]');
      var error = _handleErrorMsg(data);
      throw Exception('$error');
    }
    return data;
  }

  _handleErrorMsg(data) {
    var errorMsg = data['detail'];
    errorMsg ??= data['message'];
    errorMsg ??= data['error']['message'];
    return errorMsg;
  }

  _updateHeaders({Map<String, dynamic>? extendHeaders, List<String>? removeHeaders}) async {
    // debugPrint('FlexHttpService - _updateHeaders()...');

    headers.clear();
    // token = await authenticationService.getToken();
    if (token != null && token != '') {
      headers.putIfAbsent('Authorization', () => 'Bearer $token');

      // GET TOKEN ON CONSOLE
      // List<String> tokenArr = token.split('.');
      // for (int i = 0; i < tokenArr.length; i++) {
      //   debugPrint('FlexAuthenticationService - token_$i: -|${tokenArr[i]}|-');
      // }
    }

    headers.putIfAbsent('Accept-Language',
        () => Localizations.localeOf(navigator.context).toString());

    if(extendHeaders != null && extendHeaders.isNotEmpty) {
      for(MapEntry item in extendHeaders.entries) {
        headers.update(item.key, (_) => item.value.toString(), ifAbsent: () => item.value.toString(),);
      }
    }

    if(removeHeaders != null && removeHeaders.isNotEmpty) {
      for(String key in removeHeaders) {
        headers.remove(key);
      }
    }
  }

  String _updateUrl({required String url, Map<String, dynamic>? extendQuery}) {
    String urlParams = '';
    if(extendQuery != null && extendQuery.toString().trim().isNotEmpty) {
      urlParams = extendQuery.entries.map((e) => '${e.key}=${e.value}').toList().join('&');
    }
    if(urlParams.isNotEmpty) {
      String joinChar = '?';
      if(url.contains(joinChar)) {
        joinChar = '&';
      }
      url += '$joinChar$urlParams';
    }
    return url;
  }

  _decodeData(http.Response response, {bool forceDecode = false}) {
    var data;
    if (response.statusCode == 200 || forceDecode) {
      data = json.decode(utf8.decode(response.bodyBytes));
    } else {
      data = [];
    }
    return data;
  }
}
