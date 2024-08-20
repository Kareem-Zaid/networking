import 'package:flutter/material.dart';
import 'package:networking/phone_model.dart';
import 'dio_api_client.dart';

bool isNew = true;

class CustomTextField extends StatelessWidget {
  const CustomTextField(this.label, this.hint, this.onChanged, {super.key});
  final String label;
  final String? hint;
  final void Function(String) onChanged;
  // final bool isNew;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          decoration: InputDecoration(
            labelText: label,
            // hintText: hint == null ? 'Enter New phone $label' : hint,
            // The statement above is logically equivalent to that below.
            // hintText: hint ?? 'New Phone $label',
            hintText: isNew ? 'New Phone $label' : hint,
          ),
          onChanged: (v) => onChanged(v)),
    );
  }
}

class DioEntryScreen extends StatefulWidget {
  const DioEntryScreen({super.key, this.phone, this.onSaved, this.whoRU});
  final Phone? phone;
  final Function(String newPhoneId)? onSaved;
  final String? whoRU;

  @override
  State<DioEntryScreen> createState() => _DioEntryScreenState();
}

class _DioEntryScreenState extends State<DioEntryScreen> {
  // Map<String, dynamic> userInput = {};
  Phone userInput = Phone(id: '', name: '', additionalData: {});

  @override
  Widget build(BuildContext context) {
    isNew = widget.phone == null;
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade200,
        title: Text(
          isNew
              ? 'New Phone'
              : widget.whoRU == 'replace'
                  ? 'Replace Phone'
                  : 'Update Phone',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CustomTextField(
                'Name', widget.phone?.name, (v) => userInput.name = v),
            CustomTextField(
                'Color', widget.phone?.color, (v) => userInput.color = v),
            CustomTextField('Storage Capacity', widget.phone?.capacity,
                (v) => userInput.capacity = v),
            CustomTextField('Price', widget.phone?.price.toString(),
                (v) => userInput.price = double.tryParse(v) ?? 0.0),
            CustomTextField('Generation', widget.phone?.generation,
                (v) => userInput.generation = v),
            CustomTextField('Screen Size', widget.phone?.screenSize.toString(),
                (v) => userInput.screenSize = int.tryParse(v) ?? 0),
            // const Spacer(flex: 2),
            // "Spacer" widget is intended to be used within a "Flex" widget like a "Row" or "Column"
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Check if any of the userInput values are non-empty or non-null
                // https://chatgpt.com/c/cbfbd6ab-b853-4eec-b9a0-af89ed9271b8
                bool userInputNonEmpty = userInput.toJsonMap().values.any((v) {
                  if (v is Map) {
                    return v.values
                        .any((vv) => vv != null && vv.toString().isNotEmpty);
                  }
                  return v != null && v.toString().isNotEmpty;
                });

                try {
                  if (!userInputNonEmpty) return;
                  if (isNew) {
                    final newPhone = await DioApiClient.sendPhone(userInput);
                    debugPrint('New phone sent with ID: ${newPhone.id}');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Created new phone with ID: ${newPhone.id}'),
                      ));
                    }
                    widget.onSaved!(newPhone.id);
                  } else if (widget.whoRU == 'replace') {
                    final replacedPhone = await DioApiClient.replacePhone(
                        userInput, widget.phone!.id);
                    debugPrint(
                        'Replaced existing phone with ID: ${replacedPhone.id}');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Replaced existing phone with ID: ${replacedPhone.id}'),
                      ));
                    }
                  } else {
                    final updatedPhone = await DioApiClient.updatePhone(
                      userInput,
                      widget.phone!.toJsonMap(),
                    );
                    debugPrint(
                        'Updated existing phone with ID: ${updatedPhone.id}');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Updated existing phone with ID: ${updatedPhone.id}'),
                      ));
                    }
                  }
                  if (context.mounted) Navigator.of(context).pop(true);
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
