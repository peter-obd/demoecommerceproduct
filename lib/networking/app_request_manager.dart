import 'package:demoecommerceproduct/models/product_model.dart';
import 'package:demoecommerceproduct/screens/login_screen.dart';
import 'package:demoecommerceproduct/services/isar_service.dart';
import 'package:demoecommerceproduct/services/token_service.dart';
import 'package:demoecommerceproduct/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'request_manager.dart';

import 'dart:convert';

class AppRequestManager {
  static void getWithToken(
      String url,
      Map<String, String>? params,
      Map<String, String>? extraHeaders,
      bool withAuth,
      RequestSuccess success,
      RequestFail fail) async {
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (withAuth) {
      final user = await IsarService.instance.getCurrentUser();
      final token = user?.token ?? null; // getToken
      if (token != null) {
        bool isTokenExpired = JwtDecoder.isExpired(token);
        if (isTokenExpired) {
          print("Token expired, refreshing it");
          TokenService.refreshToken(token, (res) async {
            await IsarService.instance.updateUserToken(res);
            headers['Authorization'] = 'Bearer $res';
            if (extraHeaders != null) {
              headers.addAll(extraHeaders);
            }
            // if (await Utils.checkConnection()) {
            RequestManager.get(url, params, null, headers, (response) async {
              try {
                Map<String, dynamic> responseObj = json.decode(response);

                if (isSuccessful(responseObj)) {
                  success(response);
                } else {
                  fail(RequestError(parseErrorMessage(responseObj),
                      code: parseErrorCode(responseObj)));
                }
              } catch (exception) {
                fail(RequestError(exception.toString()));
              }
            }, (error) {
              try {
                var decodedJSON =
                    json.decode(error.message) as Map<String, dynamic>;
                var onedollarappError = parseErrorMessage(decodedJSON);
                if (onedollarappError.isNotEmpty) {
                  fail(RequestError(onedollarappError,
                      code: parseErrorCode(decodedJSON)));
                  return;
                }
              } on FormatException catch (e) {
                debugPrint(
                    '$url failed. Not a onedollarapp error: ${e.message}');
              }
              fail(error);
            });
          }, (fail) async {
            await IsarService.instance.clearUser();
            Get.offAll(const LoginScreen());
          });
        } else {
          print("Token is still valid, proceeding with API call.");
          headers['Authorization'] = 'Bearer $token';
          if (extraHeaders != null) {
            headers.addAll(extraHeaders);
          }
          // if (await Utils.checkConnection()) {
          RequestManager.get(url, params, null, headers, (response) async {
            try {
              Map<String, dynamic> responseObj = json.decode(response);

              if (isSuccessful(responseObj)) {
                success(response);
              } else {
                fail(RequestError(parseErrorMessage(responseObj),
                    code: parseErrorCode(responseObj)));
              }
            } catch (exception) {
              fail(RequestError(exception.toString()));
            }
          }, (error) {
            try {
              var decodedJSON =
                  json.decode(error.message) as Map<String, dynamic>;
              var onedollarappError = parseErrorMessage(decodedJSON);
              if (onedollarappError.isNotEmpty) {
                fail(RequestError(onedollarappError,
                    code: parseErrorCode(decodedJSON)));
                return;
              }
            } on FormatException catch (e) {
              debugPrint('$url failed. Not a onedollarapp error: ${e.message}');
            }
            fail(error);
          });
        }
      }
    } else {
      if (extraHeaders != null) {
        headers.addAll(extraHeaders);
      }
      // if (await Utils.checkConnection()) {
      RequestManager.get(url, params, null, headers, (response) async {
        try {
          Map<String, dynamic> responseObj = json.decode(response);

          if (isSuccessful(responseObj)) {
            success(response);
          } else {
            fail(RequestError(parseErrorMessage(responseObj),
                code: parseErrorCode(responseObj)));
          }
        } catch (exception) {
          fail(RequestError(exception.toString()));
        }
      }, (error) {
        try {
          var decodedJSON = json.decode(error.message) as Map<String, dynamic>;
          var onedollarappError = parseErrorMessage(decodedJSON);
          if (onedollarappError.isNotEmpty) {
            fail(RequestError(onedollarappError,
                code: parseErrorCode(decodedJSON)));
            return;
          }
        } on FormatException catch (e) {
          debugPrint('$url failed. Not a onedollarapp error: ${e.message}');
        }
        fail(error);
      });
    }

    // } else {
    //   fail(RequestError("No Internet Connection", code: -1));
    // }
  }

  static void postWithToken(
      String url,
      dynamic params,
      Map<String, String>? extraHeaders,
      bool raw,
      bool withAuth,
      RequestSuccess success,
      RequestFail fail) async {
    final finalHeaders = <String, String>{'Content-Type': 'application/json'};

    if (withAuth) {
      final user = await IsarService.instance.getCurrentUser();
      final token = user?.token ?? null; // getToken
      if (token != null) {
        bool isTokenExpired = JwtDecoder.isExpired(token);
        if (isTokenExpired) {
          print("Token expired, refreshing it");
          TokenService.refreshToken(token, (res) async {
            await IsarService.instance.updateUserToken(res);
            finalHeaders['Authorization'] = 'Bearer $res';
            if (extraHeaders != null) {
              finalHeaders.addAll(extraHeaders);
            }

            // if (await Utils.checkConnection()) {
            RequestManager.post(url, params, finalHeaders, raw,
                (response) async {
              try {
                Map<String, dynamic> responseObj = json.decode(response);

                if (isSuccessful(responseObj)) {
                  success(response);
                } else {
                  fail(RequestError(parseErrorMessage(responseObj),
                      code: parseErrorCode(responseObj)));
                }
              } catch (exception) {
                fail(RequestError(exception.toString()));
              }
            }, (error) {
              // Check if onedollarapp request
              try {
                var decodedJSON =
                    json.decode(error.message) as Map<String, dynamic>;
                var onedollarappError = parseErrorMessage(decodedJSON);
                if (onedollarappError.isNotEmpty) {
                  fail(RequestError(onedollarappError,
                      code: parseErrorCode(decodedJSON)));
                  return;
                }
              } on FormatException catch (e) {
                debugPrint(
                    '$url failed. Not a onedollarapp error: ${e.message}');
              }
              fail(error);
            });
          }, (fail) async {
            await IsarService.instance.clearUser();
            Get.offAll(const LoginScreen());
          });
        } else {
          print("Token is still valid, proceeding with API call.");
          finalHeaders['Authorization'] = 'Bearer $token';
          if (extraHeaders != null) {
            finalHeaders.addAll(extraHeaders);
          }

          // if (await Utils.checkConnection()) {
          RequestManager.post(url, params, finalHeaders, raw, (response) async {
            try {
              Map<String, dynamic> responseObj = json.decode(response);

              if (isSuccessful(responseObj)) {
                success(response);
              } else {
                fail(RequestError(parseErrorMessage(responseObj),
                    code: parseErrorCode(responseObj)));
              }
            } catch (exception) {
              fail(RequestError(exception.toString()));
            }
          }, (error) {
            // Check if onedollarapp request
            try {
              var decodedJSON =
                  json.decode(error.message) as Map<String, dynamic>;
              var onedollarappError = parseErrorMessage(decodedJSON);
              if (onedollarappError.isNotEmpty) {
                fail(RequestError(onedollarappError,
                    code: parseErrorCode(decodedJSON)));
                return;
              }
            } on FormatException catch (e) {
              debugPrint('$url failed. Not a onedollarapp error: ${e.message}');
            }
            fail(error);
          });
        }
      }
    } else {
      if (extraHeaders != null) {
        finalHeaders.addAll(extraHeaders);
      }

      // if (await Utils.checkConnection()) {
      RequestManager.post(url, params, finalHeaders, raw, (response) async {
        try {
          Map<String, dynamic> responseObj = json.decode(response);

          if (isSuccessful(responseObj)) {
            success(response);
          } else {
            fail(RequestError(parseErrorMessage(responseObj),
                code: parseErrorCode(responseObj)));
          }
        } catch (exception) {
          fail(RequestError(exception.toString()));
        }
      }, (error) {
        // Check if onedollarapp request
        try {
          var decodedJSON = json.decode(error.message) as Map<String, dynamic>;
          var onedollarappError = parseErrorMessage(decodedJSON);
          if (onedollarappError.isNotEmpty) {
            fail(RequestError(onedollarappError,
                code: parseErrorCode(decodedJSON)));
            return;
          }
        } on FormatException catch (e) {
          debugPrint('$url failed. Not a onedollarapp error: ${e.message}');
        }
        fail(error);
      });
    }

    // } else {
    //   fail(RequestError("No Internet Connection", code: -1));
    // }
  }

  static void putWithToken(
      String url,
      dynamic params,
      Map<String, String>? extraHeaders,
      bool raw,
      bool withAuth,
      RequestSuccess success,
      RequestFail fail) async {
    final finalHeaders = <String, String>{'Content-Type': 'application/json'};

    if (withAuth) {
      final user = await IsarService.instance.getCurrentUser();
      final token = user?.token ?? null; // getToken
      if (token != null) {
        bool isTokenExpired = JwtDecoder.isExpired(token);
        if (isTokenExpired) {
          print("Token expired, refreshing it");
          TokenService.refreshToken(token, (res) async {
            await IsarService.instance.updateUserToken(res);
            finalHeaders['Authorization'] = 'Bearer $res';
            if (extraHeaders != null) {
              finalHeaders.addAll(extraHeaders);
            }

            RequestManager.put(url, params, finalHeaders, raw,
                (response) async {
              try {
                Map<String, dynamic> responseObj = json.decode(response);

                if (isSuccessful(responseObj)) {
                  success(response);
                } else {
                  fail(RequestError(parseErrorMessage(responseObj),
                      code: parseErrorCode(responseObj)));
                }
              } catch (exception) {
                fail(RequestError(exception.toString()));
              }
            }, (error) {
              fail(error);
            });
          }, (fail) async {
            await IsarService.instance.clearUser();
            Get.offAll(const LoginScreen());
          });
        } else {
          print("Token is still valid, proceeding with API call.");
          finalHeaders['Authorization'] = 'Bearer $token';
          if (extraHeaders != null) {
            finalHeaders.addAll(extraHeaders);
          }

          RequestManager.put(url, params, finalHeaders, raw, (response) async {
            try {
              Map<String, dynamic> responseObj = json.decode(response);

              if (isSuccessful(responseObj)) {
                success(response);
              } else {
                fail(RequestError(parseErrorMessage(responseObj),
                    code: parseErrorCode(responseObj)));
              }
            } catch (exception) {
              fail(RequestError(exception.toString()));
            }
          }, (error) {
            fail(error);
          });
        }
      }
    } else {
      if (extraHeaders != null) {
        finalHeaders.addAll(extraHeaders);
      }

      RequestManager.put(url, params, finalHeaders, raw, (response) async {
        try {
          Map<String, dynamic> responseObj = json.decode(response);

          if (isSuccessful(responseObj)) {
            success(response);
          } else {
            fail(RequestError(parseErrorMessage(responseObj),
                code: parseErrorCode(responseObj)));
          }
        } catch (exception) {
          fail(RequestError(exception.toString()));
        }
      }, (error) {
        fail(error);
      });
    }
  }

  static void uploadWithToken(
      String url,
      Map<String, String>? params,
      Map<String, String>? files,
      Map<String, String>? extraHeaders,
      bool withAuth,
      RequestSuccess success,
      RequestFail fail) async {
    final finalHeaders = <String, String>{'Content-Type': 'application/json'};

    if (withAuth) {
      final user = await IsarService.instance.getCurrentUser();
      final token = user?.token ?? null; // getToken
      if (token != null) {
        bool isTokenExpired = JwtDecoder.isExpired(token);
        if (isTokenExpired) {
          print("Token expired, refreshing it");
          TokenService.refreshToken(token, (res) async {
            await IsarService.instance.updateUserToken(res);
            finalHeaders['Authorization'] = 'Bearer $res';

            if (extraHeaders != null) {
              finalHeaders.addAll(extraHeaders);
            }

            // if (await Utils.checkConnection()) {
            RequestManager.upload(url, params, files, finalHeaders,
                (response) async {
              try {
                Map<String, dynamic> responseObj = json.decode(response);

                if (isSuccessful(responseObj)) {
                  success(response);
                } else {
                  fail(RequestError(parseErrorMessage(responseObj),
                      code: parseErrorCode(responseObj)));
                }
              } catch (exception) {
                fail(RequestError(exception.toString()));
              }
            }, (error) {
              // Check if onedollarapp request
              try {
                var decodedJSON =
                    json.decode(error.message) as Map<String, dynamic>;
                var onedollarappError = parseErrorMessage(decodedJSON);
                if (onedollarappError.isNotEmpty) {
                  fail(RequestError(onedollarappError,
                      code: parseErrorCode(decodedJSON)));
                  return;
                }
              } on FormatException catch (e) {
                debugPrint(
                    '$url failed. Not a onedollarapp error: ${e.message}');
              }
              fail(error);
            });
          }, (fail) async {
            await IsarService.instance.clearUser();
            Get.offAll(const LoginScreen());
          });
        } else {
          print("Token is still valid, proceeding with API call.");
          finalHeaders['Authorization'] = 'Bearer $token';

          if (extraHeaders != null) {
            finalHeaders.addAll(extraHeaders);
          }

          // if (await Utils.checkConnection()) {
          RequestManager.upload(url, params, files, finalHeaders,
              (response) async {
            try {
              Map<String, dynamic> responseObj = json.decode(response);

              if (isSuccessful(responseObj)) {
                success(response);
              } else {
                fail(RequestError(parseErrorMessage(responseObj),
                    code: parseErrorCode(responseObj)));
              }
            } catch (exception) {
              fail(RequestError(exception.toString()));
            }
          }, (error) {
            // Check if onedollarapp request
            try {
              var decodedJSON =
                  json.decode(error.message) as Map<String, dynamic>;
              var onedollarappError = parseErrorMessage(decodedJSON);
              if (onedollarappError.isNotEmpty) {
                fail(RequestError(onedollarappError,
                    code: parseErrorCode(decodedJSON)));
                return;
              }
            } on FormatException catch (e) {
              debugPrint('$url failed. Not a onedollarapp error: ${e.message}');
            }
            fail(error);
          });
        }
      }
    } else {
      if (extraHeaders != null) {
        finalHeaders.addAll(extraHeaders);
      }

      // if (await Utils.checkConnection()) {
      RequestManager.upload(url, params, files, finalHeaders, (response) async {
        try {
          Map<String, dynamic> responseObj = json.decode(response);

          if (isSuccessful(responseObj)) {
            success(response);
          } else {
            fail(RequestError(parseErrorMessage(responseObj),
                code: parseErrorCode(responseObj)));
          }
        } catch (exception) {
          fail(RequestError(exception.toString()));
        }
      }, (error) {
        // Check if onedollarapp request
        try {
          var decodedJSON = json.decode(error.message) as Map<String, dynamic>;
          var onedollarappError = parseErrorMessage(decodedJSON);
          if (onedollarappError.isNotEmpty) {
            fail(RequestError(onedollarappError,
                code: parseErrorCode(decodedJSON)));
            return;
          }
        } on FormatException catch (e) {
          debugPrint('$url failed. Not a onedollarapp error: ${e.message}');
        }
        fail(error);
      });
    }

    // } else {
    //   fail(RequestError("No Internet Connection"));
    // }
  }

  static void deleteWithToken(String url, Map<String, String>? extraHeaders,
      bool withAuth, RequestSuccess success, RequestFail fail) async {
    final finalHeaders = <String, String>{'Content-Type': 'application/json'};

    if (withAuth) {
      final user = await IsarService.instance.getCurrentUser();
      final token = user?.token ?? null; // getToken
      if (token != null) {
        bool isTokenExpired = JwtDecoder.isExpired(token);
        if (isTokenExpired) {
          print("Token expired, refreshing it");
          TokenService.refreshToken(token, (res) async {
            await IsarService.instance.updateUserToken(res);
            finalHeaders['Authorization'] = 'Bearer $res';
            if (extraHeaders != null) {
              finalHeaders.addAll(extraHeaders);
            }

            RequestManager.delete(url, finalHeaders, (response) async {
              try {
                Map<String, dynamic> responseObj = json.decode(response);

                if (isSuccessful(responseObj)) {
                  success(response);
                } else {
                  fail(RequestError(parseErrorMessage(responseObj),
                      code: parseErrorCode(responseObj)));
                }
              } catch (exception) {
                fail(RequestError(exception.toString()));
              }
            }, (error) {
              // Check if onedollarapp request
              try {
                var decodedJSON =
                    json.decode(error.message) as Map<String, dynamic>;
                var onedollarappError = parseErrorMessage(decodedJSON);
                if (onedollarappError.isNotEmpty) {
                  fail(RequestError(onedollarappError,
                      code: parseErrorCode(decodedJSON)));
                  return;
                }
              } on FormatException catch (e) {
                debugPrint(
                    '$url failed. Not a onedollarapp error: ${e.message}');
              }
              fail(error);
            });
          }, (fail) async {
            await IsarService.instance.clearUser();
            Get.offAll(const LoginScreen());
          });
        } else {
          print("Token is still valid, proceeding with API call.");
          finalHeaders['Authorization'] = 'Bearer $token';
          if (extraHeaders != null) {
            finalHeaders.addAll(extraHeaders);
          }

          RequestManager.delete(url, finalHeaders, (response) async {
            try {
              Map<String, dynamic> responseObj = json.decode(response);

              if (isSuccessful(responseObj)) {
                success(response);
              } else {
                fail(RequestError(parseErrorMessage(responseObj),
                    code: parseErrorCode(responseObj)));
              }
            } catch (exception) {
              fail(RequestError(exception.toString()));
            }
          }, (error) {
            // Check if onedollarapp request
            try {
              var decodedJSON =
                  json.decode(error.message) as Map<String, dynamic>;
              var onedollarappError = parseErrorMessage(decodedJSON);
              if (onedollarappError.isNotEmpty) {
                fail(RequestError(onedollarappError,
                    code: parseErrorCode(decodedJSON)));
                return;
              }
            } on FormatException catch (e) {
              debugPrint('$url failed. Not a onedollarapp error: ${e.message}');
            }
            fail(error);
          });
        }
      }
    } else {
      if (extraHeaders != null) {
        finalHeaders.addAll(extraHeaders);
      }

      RequestManager.delete(url, finalHeaders, (response) async {
        try {
          Map<String, dynamic> responseObj = json.decode(response);

          if (isSuccessful(responseObj)) {
            success(response);
          } else {
            fail(RequestError(parseErrorMessage(responseObj),
                code: parseErrorCode(responseObj)));
          }
        } catch (exception) {
          fail(RequestError(exception.toString()));
        }
      }, (error) {
        // Check if onedollarapp request
        try {
          var decodedJSON = json.decode(error.message) as Map<String, dynamic>;
          var onedollarappError = parseErrorMessage(decodedJSON);
          if (onedollarappError.isNotEmpty) {
            fail(RequestError(onedollarappError,
                code: parseErrorCode(decodedJSON)));
            return;
          }
        } on FormatException catch (e) {
          debugPrint('$url failed. Not a onedollarapp error: ${e.message}');
        }
        fail(error);
      });
    }
  }

  static bool isSuccessful(Map<String, dynamic> response) {
    bool success = response["success"];
    return success;
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
      if (error == "") {
        String message = response["errorMessage"];
        if (message != "") {
          error = message;
        }
      }
    }

    if (error == "") {
      String message = response["errorMessage"];
      if (message != "") {
        error = message;
      }
    }

    return error;
  }

  static int parseErrorCode(Map<String, dynamic> response) {
    int errorCode = -1;

    try {
      List? errors = response["errors"];

      if (errors != null) {
        // if (errors is List<Map>) {
        for (var errorObject in errors) {
          int code = errorObject["errorCode"];
          if (code != 0) {
            errorCode = code;
            break;
          }
        }
        // }
      }
    } catch (exception) {
      debugPrint(exception.toString());
    }

    // if (errorCode == -1) {
    //   errorCode = response["statusCode"];
    // }

    return errorCode;
  }
}
