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
      debugPrint('Phone body: ${byIdPhone.body}');
      debugPrint('Decoded phone body: ${json.decode(byIdPhone.body)}');
      return Phone.fromJson(json.decode(byIdPhone.body));
    } else {
      throw Exception('Failed to get entry by ID');
    }
  }

  static Future<List<Phone>> getAllPhones() async {
    debugPrint('Method started');
    String objectUri = baseUri;
    final response = await http.get(Uri.parse(objectUri));
    debugPrint('After awaiting request: ${response.body}');

    if (response.statusCode == 200) {
      debugPrint('If true started');
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      debugPrint('Parsed: ${parsed[12]}');
      return parsed.map<Phone>((item) => Phone.fromJson(item)).toList();
    } else {
      throw Exception('Failed to get all entries');
    }
  }

  static Future<Phone> sendPhone(Map<String, dynamic> phoneData) async {
    final response = await http.post(
      Uri.parse(baseUri),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(phoneData),
    );
    if (response.statusCode == 200) {
      debugPrint('Sent phone body: ${response.body}');
      return Phone.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Exception/Status is: ${response.statusCode}');
    }
  }

  static Future<Phone> modifyPhone(Map<String, dynamic> phoneData) async {
    final response = await http.post(
      Uri.parse(baseUri), // Add identifier
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(phoneData),
      // body: json.encode(phoneToPhone),
    );
    if (response.statusCode == 200) {
      debugPrint('Printed sent phone body: ${response.body}');
      return Phone.fromJson(json.decode(response.body));
    } else {
      throw Exception('Exception/Status is: ${response.statusCode}');
    }
  }
}
