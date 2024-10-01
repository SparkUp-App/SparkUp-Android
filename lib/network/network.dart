import "dart:async";
import "dart:io";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "dart:convert";

import "package:spark_up/network/httpprotocol.dart";

class Network{
  static const baseUrl = "sparkup-9db24d093e0f.herokuapp.com";
  static Network manager = Network();

  Future<Map> sendRequest(
    {
      required RequestMethod method, 
      required HttpPath path,
      required Map<dynamic,dynamic>? data,
    }
  ) async {
    //Http requst base info
    final url = Uri.https(baseUrl, path.getPath);
    final headers = {"Content-Type" : "application/json"};
    final body = jsonEncode(data);

    dynamic response;
    

    //Get request
    try{
      switch (method){
        case RequestMethod.get:
          response = await http.get(url, headers: headers);
        case RequestMethod.post:
          response = await http.post(url, headers: headers, body: body);
      }
    } on TimeoutException catch(e){
      debugPrint("TimeoutException: $e");
    } on SocketException catch(e){
      debugPrint("SocketException: $e");
    } on Error catch(e){
      debugPrint("Error: $e");
    }

    if(response.statusCode == 201 || response.statusCode == 200){
      debugPrint("Response Status Code: ${response.statusCode}");
      return {"status" : "success", "data" : jsonDecode(response.body)};
    } else {
      debugPrint("Response Status Code: ${response.statusCode}");
      return {"status" : "faild", "data" : jsonDecode(response.body)};}
    
  }

}

enum RequestMethod{
  get,
  post;
}