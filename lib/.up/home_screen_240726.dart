import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:networking/post_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
// HTTP Networking START (We are top-level here)

  // Future<http.Response> getPostById() async {
  Future<Post> getPostById() async {
    String postUri = 'https://jsonplaceholder.typicode.com/posts/2';

    // Future<http.Response> futureByIdPost = http.get(Uri.parse(postUri));
    // Either declare as Future - as above -, or use await - as below -.
    http.Response byIdPost = await http.get(Uri.parse(postUri));

    // if(futureByIdPost.statusCode==200)
    // The getter 'statusCode' isn't defined for the type 'Future<Response>'
    if (byIdPost.statusCode == 200) {
      // Success
      if (kDebugMode) print('Printed post body: ${byIdPost.body}');
    } else {
      // Error
      throw Exception('Cannot load data');
    }
    if (kDebugMode) print(json.decode(byIdPost.body));

    // return {"idPost": futureByIdPost, "awaitIdPost": byIdPost};
    return Post.fromJson(json.decode(byIdPost.body));
  }

// HTTP Networking END

  late Future<Post> postBody;
  @override
  void initState() {
    postBody = getPostById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HTTP Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                getPostById();
              } /* fetchData */,
              child: const Text('Fetch Data'),
            ),
            const SizedBox(height: 20),
            // const Text("Fetch Response: {getPostById()['byIdPost']}"),
            FutureBuilder(
              future: postBody,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.title);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {} /* postData */,
              child: const Text('Post Data'),
            ),
            const SizedBox(height: 20),
            const Text('Post Response: _postResponse'),
          ],
        ),
      ),
    );
  }
}
