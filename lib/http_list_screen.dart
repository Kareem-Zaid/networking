import 'package:flutter/material.dart';
import 'http_api_client.dart';
import 'http_entry_screen.dart';
import 'phone_model.dart';

class HttpListScreen extends StatefulWidget {
  const HttpListScreen({super.key});
  // static const String route = '/http-sample';
  // void ay7aga() => HttpApiClient.baseUri;

  @override
  State<HttpListScreen> createState() => _HttpListScreenState();
}

class _HttpListScreenState extends State<HttpListScreen> {
  // todo: Update the list on posting a new phone
  static const List<String> objectIds = [
    'ff808181912a2b8801913018747d0b3b',
  ];

  Future<List<Phone>> getPhones() async {
    List<Future<Phone>> phoneFutures = [];
    for (var id in objectIds) {
      phoneFutures.add(HttpApiClient.getPhoneById(id));
      debugPrint('id: $id');
      debugPrint('phones: $phoneFutures');
    }
    var tempPhoneFutures = await HttpApiClient.getAllPhones();
    phoneFutures.addAll(tempPhoneFutures.map((item) => Future.value(item)));
    return Future.wait(phoneFutures);
  }

  late Phone phone;
// phone = Phone(id: 'id', name: 'name', color: 'color', capacity: 'capacity');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'New Entry',
        child: const Icon(Icons.add),
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (c) => HttpEntryScreen(
            phone: Phone(
                id: 'New Phone ID',
                name: 'New Phone Name',
                color: 'New Phone Color',
                capacity: 'New Phone Capacity',
                additionalData: {}),
          ),
        ),
      ),
      appBar: AppBar(title: const Text('HTTP List')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: getPhones(),
          builder: (c, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (cc, index) {
                  final phone = snapshot.data![index];
                  // Adding "final" here is radical for tapped item index correspondence
                  // https://chatgpt.com/c/13520923-f948-4373-88fd-26bddebe6c4e
                  // https://chatgpt.com/share/6fe3c9da-9896-45bb-b7f3-362dc73cb9f9
                  return Card(
                    child: ListTile(
                      title: Text(phone.name),
                      subtitle: Text('${phone.color}, ${phone.capacity}'),
                      trailing: InkWell(
                        child: const Icon(Icons.edit),
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (ccc) => HttpEntryScreen(phone: phone),
                        ),
                      ),
                      // todo: Info screen using get request instead of passing data from here
                      onTap: () => Navigator.of(cc).push(MaterialPageRoute(
                          builder: (ccc) => HttpEntryScreen(phone: phone))),
                    ),
                  );
                },
              );
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
