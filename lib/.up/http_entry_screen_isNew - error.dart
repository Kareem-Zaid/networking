import 'package:flutter/material.dart';
import 'package:networking/phone_model.dart';
import 'http_api_client.dart';

// HttpListScreen httpListScreen =  HttpListScreen();
class MyTextField extends StatelessWidget {
  const MyTextField(this.label, this.hint, this.onChanged,
      {super.key, required this.isNew});
  final String label;
  final String? hint;
  final void Function(String) onChanged;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          decoration: InputDecoration(
            labelText: label,
            hintText: isNew ? 'Enter New phone $label' : hint,
          ),
          onChanged: (v) => onChanged(v)),
    );
  }
}

class HttpEntryScreen extends StatefulWidget {
  const HttpEntryScreen({super.key, this.phone, this.onSaved});
  final Phone? phone;
  final Function(String newPhoneId)? onSaved;

  @override
  State<HttpEntryScreen> createState() => _HttpEntryScreenState();
}

class _HttpEntryScreenState extends State<HttpEntryScreen> {
  // Map<String, dynamic> userInput = {};
  Phone userInput = Phone(id: '', name: '', additionalData: {});

  bool isNew = true;

  @override
  Widget build(BuildContext context) {
    isNew = widget.phone!.id.isEmpty;
    return Scaffold(
      appBar: AppBar(title: Text(isNew ? 'New Phone' : 'Modify Phone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            MyTextField('Name', widget.phone!.name, (v) => userInput.name = v,
                isNew: isNew),
            MyTextField(
                'Color', widget.phone!.color, (v) => userInput.color = v,
                isNew: isNew),
            MyTextField('Storage Capacity', widget.phone!.capacity,
                (v) => userInput.capacity = v,
                isNew: isNew),
            MyTextField('Price', widget.phone!.price.toString(),
                (v) => userInput.price = double.parse(v),
                isNew: isNew),
            MyTextField('Generation', widget.phone!.generation,
                (v) => userInput.generation = v,
                isNew: isNew),
            MyTextField('Screen Size', widget.phone!.screenSize.toString(),
                (v) => userInput.screenSize = int.parse(v),
                isNew: isNew),
            // const Spacer(flex: 2),
            // "Spacer" widget is intended to be used within a "Flex" widget like a "Row" or "Column"
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // isNew ? print('New Phone') : print('Modify Phone');
                try {
                  if (context.mounted && userInput.name.isNotEmpty) {
                    Navigator.of(context).pop();
                  }
                  if (isNew) {
                    // debugPrint('No ID / New Phone');
                    debugPrint('User Input: $userInput');
                    debugPrint('User Input name: ${userInput.name}');
                    final newPhone = await HttpApiClient.sendPhone(userInput);
                    // HttpListScreen.objectIds.add(widget.phone.id); // phone.id is empty, man
                    debugPrint('New phone sent with ID: ${newPhone.id}');
                    widget.onSaved!(newPhone.id);
                  } else {
                    debugPrint('Existing ID: ${widget.phone!.id}');
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
