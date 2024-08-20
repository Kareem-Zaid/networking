import 'package:flutter/material.dart';
import 'package:networking/phone_model.dart';
import 'package:dio/dio.dart';

class DioApiClient {
  static Dio dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    contentType: "application/json",
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    sendTimeout: const Duration(seconds: 10), // ChatGPT
  ));

  static const String baseUrl = 'https://api.restful-api.dev/objects';

  static void errorHandler(DioException e, String reqName) {
    // Request was made & server responded with a status code that's out of 2xx range & also not 304.
    debugPrint('$reqName Error message: ${e.message}\nError type: ${e.type}');
    if (e.response != null) {
      debugPrint('$reqName response data on error: ${e.response!.data}');
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      debugPrint('$reqName request options on error: ${e.requestOptions}');
    }
  }

  static Future<Phone> getPhone(String objectId) async {
    try {
      final response = await dio.get('/$objectId');
      return Phone.fromJson(response.data);
    } on DioException catch (e) {
      errorHandler(e, 'GET');
      rethrow;
    }
  }

  static Future<List<Phone>> getAllPhones() async {
    try {
      final response = await dio.get('');

      // https://chatgpt.com/c/bdfc2535-0230-4425-89ba-a28273f5308e
      return (response.data as List).map<Phone>((json) {
        return Phone.fromJson(json);
      }).toList();
    } on DioException catch (e) {
      errorHandler(e, 'GET (All)');
      rethrow;
    }
  }

  static Future<Phone> sendPhone(Phone userInput) async {
    try {
      final response = await dio.post('', data: userInput.toJsonMap());
      return Phone.fromJson(response.data);
    } on DioException catch (e) {
      errorHandler(e, 'POST');
      rethrow;
    }
  }

  static Future<Phone> replacePhone(Phone userInput, String objectId) async {
    try {
      final response = await dio.put('/$objectId', data: userInput.toJsonMap());
      return Phone.fromJson(response.data);
    } on DioException catch (e) {
      errorHandler(e, 'PUT');
      rethrow;
    }
  }

  static Future<Phone> updatePhone(
      Phone userInput, Map<String, dynamic> originalData) async {
    try {
      Map<String, dynamic> updatedData = {};

      userInput.toJsonMap().forEach((key, value) {
        if (value is Map) {
          // Handle nested maps like 'data'
          value.forEach((nestedKey, nestedValue) {
            if (originalData[key] is Map &&
                originalData[key][nestedKey] != nestedValue &&
                nestedValue != null) {
              debugPrint('New nested value: $nestedValue');
              // Ensure nested values go under the correct parent key in updatedData
              updatedData[key] = updatedData[key] ?? {};
              updatedData[key][nestedKey] = nestedValue;
            }
          });
        } else {
          // Handle top-level fields directly
          if (value != originalData[key] && value != null && value != '') {
            debugPrint('New value: $value');
            updatedData[key] = value;
          }
        }
      });

      final response =
          await dio.patch('/${originalData['id']}', data: updatedData);
      return Phone.fromJson(response.data);
    } on DioException catch (e) {
      errorHandler(e, 'PATCH');
      rethrow;
    }
  }

  static Future<Response> deletePhone(String objectId) async {
    try {
      final response = await dio.delete('/$objectId');
      return response;
    } on DioException catch (e) {
      errorHandler(e, 'DELETE');
      rethrow;
    }
  }
}
