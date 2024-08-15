import 'package:flutter/material.dart';
import 'phone_model.dart';

class HttpDetailsScreen extends StatefulWidget {
  const HttpDetailsScreen({super.key, required this.phoneFuture});
  final Future<Phone> phoneFuture;

  @override
  State<HttpDetailsScreen> createState() => _HttpDetailsScreenState();
}

class _HttpDetailsScreenState extends State<HttpDetailsScreen> {
  Phone? phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(phone != null
            ? 'Info about ${phone!.name}'
            : 'Info about: loading phone name...'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: widget.phoneFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
              // https://chatgpt.com/c/b29834a7-5bba-40cf-ad03-737cce1a197f
              // phone = snapshot.data;
              // WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
              // https://chatgpt.com/share/e33d077a-0240-4f30-b5c4-a32d3868f8c6

              // Only call setState if the phone variable is not yet set
              if (phone == null) {
                // Update the phone variable and call setState
                phone = snapshot.data;
                // Trigger a rebuild to update the AppBar
                Future.microtask(() => setState(() {}));
              }
              final properties = phone!.toMap();
              return ListView.builder(
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  String key = properties.keys.elementAt(index);
                  return Card(
                    child: ListTile(
                      title: Text('$key: ${properties[key]}'),
                    ),
                  );
                },
              );
            } else {
              return const Text('No data available');
            }
          },
        ),
      ),
    );
  }
}
