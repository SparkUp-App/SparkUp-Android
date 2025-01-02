import "dart:async";
import "dart:io";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "dart:convert";

import "package:spark_up/network/httpprotocol.dart";

class Network {
  static const baseUrl = "sparkup-9db24d093e0f.herokuapp.com";
  static Network manager = Network();
  int? userId;

  Future<Map> sendRequest({
    required RequestMethod method,
    required HttpPath path,
    Map<dynamic, dynamic>? data,
    List<String> pathMid = const [],
  }) async {
    //Http requst base info
    var finalPath = path.getPath;
    for (int i = 0; i < pathMid.length; i++) {
      finalPath = finalPath.replaceFirst("%$i", pathMid[i]);
    }

    final url = Uri.https(baseUrl, finalPath);
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode(data);

    dynamic response;

    //Get request
    try {
      switch (method) {
        case RequestMethod.get:
          response = await http.get(url, headers: headers);
        case RequestMethod.post:
          response = await http.post(url, headers: headers, body: body);
        case RequestMethod.delete:
          response = await http.delete(url, headers: headers, body: body);
      }
    } on TimeoutException catch (e) {
      debugPrint("TimeoutException: $e");
      return {
        "status": "error",
        "data": {"message": "Timeout Error"}
      };
    } on SocketException catch (e) {
      debugPrint("SocketException: $e");
      return {
        "status": "error",
        "data": {"message": "Connection Error"}
      };
    } on HandshakeException catch (e) {
      debugPrint("HandshakeException: $e");
      return {
        "status": "error",
        "data": {"message": "Connection Error"}
      };
    } on Error catch (e) {
      debugPrint("Error: $e");
      return {
        "status": "error",
        "data": {"message": "Error"}
      };
    } catch (e){
      debugPrint("Error: $e");
      return {
        "status": "error",
        "data": {"message": "Error"}
      };
    }

    if (response.statusCode == 201 || response.statusCode == 200) {
      debugPrint("Response Status Code: ${response.statusCode}");
      return {
        "status": "success",
        "status_code": response.statusCode,
        "data": jsonDecode(utf8.decode(response.bodyBytes))
      };
    } else {
      debugPrint("Response Status Code: ${response.statusCode}");
      return {
        "status": "faild",
        "status_code": response.statusCode,
        "data": jsonDecode(utf8.decode(response.bodyBytes))
      };
    }
  }

  void saveUserId(int id) => userId = id;
  void removeUserId() => userId = null;
}

enum RequestMethod {
  get,
  post,
  delete;
}
