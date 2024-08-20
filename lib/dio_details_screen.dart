import 'package:flutter/material.dart';
import 'phone_model.dart';

class DioDetailsScreen extends StatefulWidget {
  const DioDetailsScreen({super.key, required this.phoneFuture});
  final Future<Phone> phoneFuture;

  @override
  State<DioDetailsScreen> createState() => _DioDetailsScreenState();
}

class _DioDetailsScreenState extends State<DioDetailsScreen> {
  Phone? phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade200,
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
              phone = snapshot.data;
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => setState(() {}));
              if (phone == null) {
                phone = snapshot.data;
                Future.microtask(() => setState(() {}));
              }
              final properties = phone!.toPropertiesMap();
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
