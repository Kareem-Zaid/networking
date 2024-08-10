import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:networking/post_model.dart';

class HttpApiClient {
  static Future<Post> getPostById() async {
    const postUri = 'https://jsonplaceholder.typicode.com/posts/2';
    final byIdPost = await http.get(Uri.parse(postUri));
    // http.post(Uri.parse('url'), headers: {}, body: {});
    if (byIdPost.statusCode == 200) {
      if (kDebugMode) print('Printed post body: ${byIdPost.body}');
      if (kDebugMode) print(json.decode(byIdPost.body));
      return Post.fromJson(json.decode(byIdPost.body));
    } else {
      throw Exception('Cannot load data');
    }
  }

  static Future<Post> sendPost(Map<String, dynamic> postToPost) async {
    const baseUri = 'https://jsonplaceholder.typicode.com';
    final response = await http.post(
      Uri.parse('$baseUri/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(postToPost),
      // body: json.encode(postToPost),
    );
    if (response.statusCode == 200) {
      if (kDebugMode) print('Printed sent post body: ${response.body}');
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Exception/Status is: ${response.statusCode}');
    }
  }

  static Future<Post> modifyPost(Map<String, dynamic> postToPost) async {
    const baseUri = 'https://jsonplaceholder.typicode.com';
    final response = await http.post(
      Uri.parse('$baseUri/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(postToPost),
      // body: json.encode(postToPost),
    );
    if (response.statusCode == 200) {
      if (kDebugMode) print('Printed sent post body: ${response.body}');
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Exception/Status is: ${response.statusCode}');
    }
  }
}
