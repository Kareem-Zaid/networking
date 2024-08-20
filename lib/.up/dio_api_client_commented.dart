import 'package:flutter/material.dart';
import 'package:networking/phone_model.dart';
import 'package:dio/dio.dart';

class DioApiClient {
  // final _dio = Dio(); // As ez as u c ;)

  static Dio dio = Dio(BaseOptions(
    baseUrl: DioApiClient.baseUrl,
    contentType: "application/json",
    // headers: {"Accept": "application/json", "Content-Type": "application/json"},
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    sendTimeout: const Duration(seconds: 10), // 10 seconds // ChatGPT
  ));

  static const String baseUrl = 'https://api.restful-api.dev/objects';

  // static Phone getPhone(String objectId) {
  //   String objectUri = '${dio.options.baseUrl}/$objectId';
  //   final response = dio.get(objectUri);
  //   return Phone.fromJson(jsonDecode(response.toString()));
  // }

  // Method above is not async/Future.. Method below is async/Future. Difference lies in return type.
  // Either return "Present" Phone without 'async' or "Future<Phone>" with 'async'.

  static Future<Phone> getPhone(String objectId) async {
    // dio.options.baseUrl=DioApiClient.baseUri; // Can be set/updated separately / in runtime
    // String objectUrl = '${dio.options.baseUrl}/$objectId';
    // debugPrint(objectUri);
    try {
      // final response = await dio.get('https://api.restful-api.dev/objects//$objectId');
      // Dio parses urls smart enough to handle flaws like writing the baseUrl twice - in BaseOptions & in get request - or add two forward slashes.

      final response = await dio.get('/$objectId');
      // dio.getUri(uri);
      // print('GET Response: ${response.data}')
      return Phone.fromJson(response.data);
    } on DioException catch (e) {
      // The request was made and the server responded with a status code that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        debugPrint('GET response data on error: ${e.response!.data}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        // Handle non-response errors, like network issues
        debugPrint('GET request options on error: ${e.requestOptions}');
      }
      debugPrint('GET Error message: ${e.message}\nError type: ${e.type}');
      rethrow;
      // Either return a valid value or throw an error.
    }
  }

  static Future<Phone> getAllPhones(String objectId) async {
    // String objectUrl = '${dio.options.baseUrl}/$objectId';
    try {
      final response = await dio.get(baseUrl);
      return Phone.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint('GET (All) response data on error: ${e.response!.data}');
      } else {
        debugPrint('GET (All) request options on error: ${e.requestOptions}');
      }
      debugPrint(
          'GET (All) Error message: ${e.message}\nError type: ${e.type}');
      rethrow;
    }
  }
}
