import 'package:flutter/material.dart';
import 'http_api_client.dart';

class HttpListScreen extends StatefulWidget {
  const HttpListScreen({super.key});
  // static const String route = '/http-sample';

  @override
  State<HttpListScreen> createState() => _HttpListScreenState();
}

class _HttpListScreenState extends State<HttpListScreen> {
  Map<String, dynamic> userInputPost = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HTTP List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                HttpApiClient.getPostById();
              } /* fetchData */,
              child: const Text('Fetch Data'),
            ),
            const SizedBox(height: 20),
            // const Text("Fetch Response: {getPostById()['byIdPost']}"),
            FutureBuilder(
              future: HttpApiClient.getPostById(),
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
            // TextField(onChanged: (value) => userInputPost['id'] = value),
            // ID is generated automatically by the API
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  decoration: const InputDecoration(labelText: 'User ID'),
                  onChanged: (value) => userInputPost['userId'] = value),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  onChanged: (value) => userInputPost['title'] = value),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  decoration: const InputDecoration(labelText: 'Body'),
                  onChanged: (value) => userInputPost['body'] = value),
            ),

            ElevatedButton(
              onPressed: () {
                HttpApiClient.sendPost(userInputPost);
              } /* postData */,
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
