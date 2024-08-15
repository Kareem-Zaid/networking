import 'package:flutter/material.dart';
import 'package:networking/phone_model.dart';
import 'http_api_client.dart';

// HttpListScreen httpListScreen =  HttpListScreen();

class HttpEntryScreen extends StatefulWidget {
  const HttpEntryScreen({super.key, required this.phone, this.onSaved});
  final Phone phone;
  final Function(String newPhoneId)? onSaved;

  @override
  State<HttpEntryScreen> createState() => _HttpEntryScreenState();
}

class _HttpEntryScreenState extends State<HttpEntryScreen> {
  // Map<String, dynamic> userInput = {};
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

  bool isNew = true;

  @override
  Widget build(BuildContext context) {
    isNew = widget.phone.id.isEmpty;
    return Scaffold(
      appBar: AppBar(title: Text(isNew ? 'New Phone' : 'Modify Phone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField('name', widget.phone.name),
            buildTextField('color', widget.phone.color),
            buildTextField('capacity', widget.phone.capacity),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                // newPhone ? print('New Phone') : print('Modify Phone');
                try {
                  if (context.mounted && userInput.isNotEmpty) {
                    Navigator.of(context).pop();
                  }
                  if (isNew) {
                    // debugPrint('No ID / New Phone');
                    debugPrint('User Input: $userInput');
                    final newPhone = await HttpApiClient.sendPhone(userInput);
                    // HttpListScreen.objectIds.add(widget.phone.id); // phone.id is empty, man
                    debugPrint('New phone sent with ID: ${newPhone.id}');
                    widget.onSaved!(newPhone.id);
                  } else {
                    debugPrint('Existing ID: ${widget.phone.id}');
                    await HttpApiClient.modifyPhone(userInput);
                  }
                  // debugPrint(HttpListScreen.objectIds.toString());
                } catch (e) {
                  debugPrint('Failed to send phone: $e');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
