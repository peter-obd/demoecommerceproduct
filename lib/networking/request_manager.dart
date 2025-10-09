import 'package:demoecommerceproduct/networking/print.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

typedef RequestSuccess = Function(String response);
typedef RequestFail = Function(RequestError error);

class RequestManager {
  static void get(
      String url,
      Map<String, String>? params,
      String? stringParam,
      Map<String, String>? headers,
      RequestSuccess success,
      RequestFail fail) async {
    try {
      if (stringParam != null) {
        url = url + stringParam;
      }
      var uri = Uri.parse(url);
      Print.white("GET Request: $url");

      if (params != null) {
        uri.queryParameters.addAll(params);
        Print.white("Params:\n${json.encode(params)}");
      }

      if (headers != null) {
        Print.white("Headers:\n${json.encode(headers)}");
      }

      var response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        Print.green("GET Request `$url` succeeded");
        Print.green("Response:\n${json.encode(response.body)}");
        success(response.body);
        return;
      }

      Print.red("Response:\n${json.encode(response.body)}");
      fail(RequestError(response.body, code: response.statusCode));
    } on FormatException catch (error) {
      fail(RequestError(error.message));
      Print.red("Request `$url` failed. Error: ${error.message}");
    } catch (e) {
      fail(RequestError(e.toString()));
      Print.red("Request `$url` failed. Error: ${e.toString()}");
    }
  }

  static void post(
      String url,
      Map<String, dynamic>? params,
      Map<String, String>? headers,
      bool raw,
      RequestSuccess success,
      RequestFail fail) async {
    try {
      var uri = Uri.parse(url);
      Print.white("POST Request: $url");
      Object? parameters = params;
      var finalHeaders = <String, String>{};
      if (headers != null) {
        finalHeaders.addAll(headers);
        Print.white("Headers:\n${json.encode(headers)}");
      }

      if (raw) {
        parameters = json.encode(params);
        finalHeaders["Content-Type"] = "application/json";
      }

      if (params != null) {
        Print.white("Params:\n${json.encode(params)}");
      }
      if (headers != null) {
        Print.white("Headers:\n${json.encode(headers)}");
      }

      var response =
          await http.post(uri, headers: finalHeaders, body: parameters);
      if (response.statusCode == 200 ||
          parseErrorMessage(json.decode(response.body)) == "Expired Token." ||
          parseErrorMessage(json.decode(response.body)) ==
              "Invalid Token format.") {
        success(response.body);
        Print.green("Response:\n${json.encode(response.body)}");
        return;
      }
      Print.red("Response:\n${json.encode(response.body)}");

      fail(RequestError(response.body, code: response.statusCode));
    } on FormatException catch (error) {
      Print.red("Request `$url` failed. Error: ${error.toString()}");
      fail(RequestError(error.message));
    } catch (e) {
      Print.red("Request `$url` failed. Error: ${e.toString()}");
      fail(RequestError(e.toString()));
    }
  }

  static void put(
      String url,
      Map<String, dynamic>? params,
      Map<String, String>? headers,
      bool raw,
      RequestSuccess success,
      RequestFail fail) async {
    try {
      var uri = Uri.parse(url);
      Print.white("PUT Request: $url");
      Object? parameters = params;
      var finalHeaders = <String, String>{};
      if (headers != null) {
        Print.white("Headers:\n${json.encode(headers)}");
        finalHeaders.addAll(headers);
      }

      if (raw) {
        parameters = json.encode(params);
        finalHeaders["Content-Type"] = "application/json";
      }

      var response =
          await http.put(uri, headers: finalHeaders, body: parameters);
      if (response.statusCode == 200) {
        success(response.body);
        Print.green("Response:\n${json.encode(response.body)}");
        return;
      }

      Print.red("Response:\n${json.encode(response.body)}");

      fail(RequestError(response.body, code: response.statusCode));
    } catch (error) {
      Print.red("Request `$url` failed. Error: ${error.toString()}");
      fail(RequestError(error.toString()));
    }
  }

  static void delete(
      String url,
      Map<String, String>? headers,
      RequestSuccess success,
      RequestFail fail) async {
    try {
      var uri = Uri.parse(url);
      Print.white("DELETE Request: $url");

      if (headers != null) {
        Print.white("Headers:\n${json.encode(headers)}");
      }

      var response = await http.delete(uri, headers: headers);
      if (response.statusCode == 200) {
        Print.green("DELETE Request `$url` succeeded");
        Print.green("Response:\n${json.encode(response.body)}");
        success(response.body);
        return;
      }

      Print.red("Response:\n${json.encode(response.body)}");
      fail(RequestError(response.body, code: response.statusCode));
    } on FormatException catch (error) {
      fail(RequestError(error.message));
      Print.red("Request `$url` failed. Error: ${error.message}");
    } catch (e) {
      fail(RequestError(e.toString()));
      Print.red("Request `$url` failed. Error: ${e.toString()}");
    }
  }

  static String parseErrorMessage(Map<String, dynamic> response) {
    String error = "";

    try {
      List? errors = response["errors"];
      if (errors != null) {
        for (var errorObject in errors) {
          String errorMessage = errorObject["userMessage"];
          if (errorMessage != "") {
            error = errorMessage;
            break;
          }
        }
      }
    } catch (exception) {
      debugPrint(exception.toString());
    }

    if (error == "") {
      String message = response["errorMessage"];
      if (message != "") {
        error = message;
      }
    }

    return error;
  }

  static void upload(
      String url,
      Map<String, String>? params,
      Map<String, String>? files,
      Map<String, String>? headers,
      RequestSuccess success,
      RequestFail fail) async {
    try {
      var uri = Uri.parse(url);
      var multipartRequest = http.MultipartRequest("POST", uri);

      if (params != null) {
        params.forEach((key, value) {
          multipartRequest.fields[key] = value;
        });
      }

      if (files != null) {
        files.forEach((key, value) async {
          var extension = path.extension(value);
          // MediaType
          multipartRequest.files.add(await http.MultipartFile.fromPath(
              key, value,
              contentType: MediaType('image', extension)));
        });
      }

      var finalHeaders = <String, String>{};
      if (headers != null) {
        finalHeaders.addAll(headers);
      }

      finalHeaders["Content-Type"] = "multipart/form-data";

      finalHeaders.forEach((key, value) {
        multipartRequest.headers[key] = value;
      });

      debugPrint(
          "URL:\n$url\nHeaders:\n${json.encode(headers)}\nParams:\n${json.encode(params)}");

      var response = await multipartRequest.send();

      var body = await response.stream.bytesToString();
      // await http.post(uri, headers: finalHeaders, body: params);
      if (response.statusCode == 200) {
        success(body);
        debugPrint("URL Success:\nResponse:\n${json.encode(body)}");
        return;
      }

      debugPrint("Url Fail: ${url}Response:\n${json.encode(body)}");

      fail(RequestError(body, code: response.statusCode));
    } on FormatException catch (error) {
      debugPrint("Url Fail: $url\nError:\n${error.message}");
      fail(RequestError(error.message));
    } catch (e) {
      debugPrint("Url Fail: $url\nError:\n${e.toString()}");
      fail(RequestError(e.toString()));
    }
  }
}

class RequestError {
  String message = "";
  int code = -1;

  RequestError(this.message, {this.code = -1});
}
