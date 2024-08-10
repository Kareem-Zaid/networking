import 'package:flutter/material.dart';
import 'package:networking/phone_model.dart';

import 'http_api_client.dart';

class HttpEntryScreen extends StatefulWidget {
  const HttpEntryScreen({super.key, required this.phone});
  final Phone phone;
  @override
  State<HttpEntryScreen> createState() => _HttpEntryScreenState();
}

class _HttpEntryScreenState extends State<HttpEntryScreen> {
  Map<String, dynamic> userInput = {};

  Padding buildTextField(String label, String? hint) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          decoration: InputDecoration(
            // labelText: label.substring(0, 1).toUpperCase() + label.substring(1),
            labelText: label[0].toUpperCase() + label.substring(1),
            hintText: hint,
          ),
          onChanged: (v) => userInput[label] = v),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Info about: ${widget.phone.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField('name', widget.phone.name),
            buildTextField('color', widget.phone.color),
            buildTextField('capacity', widget.phone.capacity),
            const Spacer(),
            ElevatedButton(
              onPressed: () => HttpApiClient.sendPhone(userInput),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
