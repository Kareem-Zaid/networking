import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:networking/phone_model.dart';

class HttpApiClient {
  static const String baseUri = 'https://api.restful-api.dev/objects';

  static Future<Phone> getPhoneById(String objectId) async {
    String objectUri = '$baseUri/$objectId';
    final byIdPhone = await http.get(Uri.parse(objectUri));
    if (byIdPhone.statusCode == 200) {
      debugPrint('Gotten phone body: ${byIdPhone.body}');
      // debugPrint('Decoded phone body: ${json.decode(byIdPhone.body)}');
      return Phone.fromJson(json.decode(byIdPhone.body));
    } else {
      throw Exception('Get by id exception/status is: ${byIdPhone.statusCode}');
    }
  }

  static Future<List<Phone>> getAllPhones() async {
    // debugPrint('Method started');
    String objectUri = baseUri;
    final response = await http.get(Uri.parse(objectUri));
    // debugPrint('All gotten phones body: ${response.body}');
    if (response.statusCode == 200) {
      // debugPrint('If true started');
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      // debugPrint('Parsed: ${parsed[12]}');
      return parsed.map<Phone>((item) => Phone.fromJson(item)).toList();
    } else {
      throw Exception('Get all exception/status is: ${response.statusCode}');
    }
  }

  static Future<Phone> sendPhone(Phone userInput) async {
    String objectUri = baseUri;
    final response = await http.post(
      Uri.parse(objectUri),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userInput.toJsonMap()),
    );
    debugPrint('Sent phone toMap: ${userInput.toJsonMap()}');
    if (response.statusCode == 200) {
      debugPrint('Sent phone body: ${response.body}');
      // HttpListScreen.objectIds.add(Phone.fromJson(jsonDecode(response.body)).id);
      return Phone.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Post exception/status is: ${response.statusCode}');
    }
  }

  static Future<Phone> replacePhone(
      {required Phone userInput, required String objectId}) async {
    String objectUri = '$baseUri/$objectId';
    final response = await http.put(
      Uri.parse(objectUri),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userInput.toJsonMap()),
      // body: json.encode(phoneToPhone),
    );
    if (response.statusCode == 200) {
      debugPrint('Replaced phone body: ${response.body}');
      return Phone.fromJson(json.decode(response.body));
      // return response;
      // If you don't need to work with the updated entry data, returning the raw response might be sufficient.
      // https://chatgpt.com/c/1a609c7d-b45e-46eb-aa11-80da5ae32702
    } else {
      throw Exception('Put exception/status is: ${response.statusCode}');
    }
  }

  static Future<Phone> updatePhone(
      {required Phone userInput,
      // required String objectId, // Replaced with 'originalData['id']'
      required Map<String, dynamic> originalData}) async {
    // debugPrint('Original data ID: ${originalData['id']}');
    String objectUri = '$baseUri/${originalData['id']}';

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

    debugPrint('Updated data: $updatedData');

    final response = await http.patch(
      Uri.parse(objectUri),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userInput.toJsonMap()),
    );
    if (response.statusCode == 200) {
      debugPrint('Updated phone body: ${response.body}');
      return Phone.fromJson(json.decode(response.body));
    } else {
      throw Exception('Patch exception/status is: ${response.statusCode}');
    }
  }

  static Future<http.Response> deletePhone(String objectId) async {
    String objectUri = '$baseUri/$objectId';
    final response = await http.delete(Uri.parse(objectUri));
    if (response.statusCode == 200) {
      debugPrint('Deleted phone response body: ${response.body}');
      return response;
    } else {
      throw Exception('Get by id exception/status is: ${response.statusCode}');
    }
  }
}
