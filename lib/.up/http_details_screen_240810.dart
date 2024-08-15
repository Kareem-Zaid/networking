import 'package:flutter/material.dart';
import 'phone_model.dart';

class HttpDetailsScreen extends StatefulWidget {
  const HttpDetailsScreen({super.key, required this.phoneFuture});
  final Future<Phone> phoneFuture;

  @override
  State<HttpDetailsScreen> createState() => _HttpDetailsScreenState();
}

class _HttpDetailsScreenState extends State<HttpDetailsScreen> {
  late Phone phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Info about: ${phone.name}')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: widget.phoneFuture,
          builder: (context, snapshot) {
            final Phone phone = snapshot.data!;
            if (snapshot.hasData) {
              return Text(snapshot.data!.name);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
