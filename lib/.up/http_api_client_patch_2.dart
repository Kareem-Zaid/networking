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

    void updateData(Map<String, dynamic> originalData,
        Map<String, dynamic> userInput, Map<String, dynamic> updatedData) {
      // Initialize updatedData to ensure it starts fresh
      updatedData.clear();

      userInput.forEach((key, value) {
        if (value is Map) {
          // Handle nested maps like 'data'
          if (originalData[key] is Map) {
            updatedData[key] = {}; // Initialize if not present

            value.forEach((nestedKey, nestedValue) {
              if (originalData[key][nestedKey] != nestedValue) {
                // Only add or update if value is non-null and non-empty
                if (nestedValue != null && nestedValue.toString().isNotEmpty) {
                  debugPrint('New nested value: $nestedValue');
                  updatedData[key][nestedKey] = nestedValue;
                }
              }
            });

            // Remove any keys that are null in the userInput but were present in the originalData
            (originalData[key] as Map).forEach((nestedKey, _) {
              if (value[nestedKey] == null) {
                updatedData[key]?.remove(nestedKey);
              }
            });

            // Only add the nested map to updatedData if it's not empty
            if (updatedData[key]?.isEmpty ?? true) {
              updatedData.remove(key);
            }
          }
        } else {
          // Handle top-level fields directly
          if (value != originalData[key] &&
              value != null &&
              value.toString().isNotEmpty) {
            debugPrint('New value: $value');
            updatedData[key] = value;
          } else if (originalData[key] != null && value == null) {
            // Remove the field if it's now null but was not originally
            updatedData.remove(key);
          }
        }
      });
    }

    updateData(originalData, userInput.toJsonMap(), updatedData);
    // https://chatgpt.com/c/fe35ea32-b8e0-4200-b291-9741295ab098
    // if (value != originalData[key] && (value?.isNotEmpty ?? false)) {

    debugPrint('Updated data: $updatedData');
    final response = await http.patch(
      Uri.parse(objectUri),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedData),
    );
    if (response.statusCode == 200) {
      debugPrint('Updated phone body: ${response.body}');
      return Phone.fromJson(json.decode(response.body));
    } else {
      throw Exception('Patch exception/status is: ${response.statusCode}');
    }
  }
}
