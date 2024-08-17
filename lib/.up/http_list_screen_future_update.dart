import 'package:flutter/material.dart';
import 'http_api_client.dart';
import 'http_details_screen.dart';
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
  // This has to be here; in stateless part it's immutable, and inside build method added items are not reflected.
  List<String> objectIds = [
    'ff808181913d565501913dca3e9500a8',
    'ff808181912a2b8801913018747d0b3b',
  ];

  Future<List<Phone>> getPhones() async {
    List<Future<Phone>> phoneFutures = [];
    for (var id in objectIds) {
      phoneFutures.add(HttpApiClient.getPhoneById(id));
    }
    var fixedPhoneFutures = await HttpApiClient.getAllPhones();
    phoneFutures.addAll(fixedPhoneFutures.map((item) => Future.value(item)));
    return Future.wait(phoneFutures);
  }

// late Phone phone;
// phone = Phone(id: 'id', name: 'name', color: 'color', capacity: 'capacity');

  void addObjectId(String newId) => setState(() {
        objectIds.add(newId);
        phoneListFuture = getPhones(); // Refresh the data after adding a new ID
      });

  late Future<List<Phone>> phoneListFuture;

  // void refreshPhones() => setState(() => phoneListFuture = getPhones());

  @override
  void initState() {
    phoneListFuture = getPhones();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'New Entry',
        child: const Icon(Icons.add),
        onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (c) => SizedBox(
            height: MediaQuery.of(context).size.height * .7,
            child: HttpEntryScreen(
              // phone: phone, // "phone" is not accessible here
              onSaved: (newPhoneId) => addObjectId(newPhoneId),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('HTTP List'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              tooltip: 'Refresh',
              // onPressed: () => setState(() => HttpApiClient.getAllPhones),
              onPressed: () => setState(() {
                phoneListFuture = getPhones(); // Assign a new future
              }),
              icon: const Icon(Icons.refresh),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: phoneListFuture,
          builder: (c, snapshot) {
            debugPrint(objectIds.toString());
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
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
                        // onHover: (value) => Text('Modify'),
                        customBorder: const CircleBorder(),
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (ccc) => HttpEntryScreen(
                            phone: phone,
                            // onSaved: (String newPhoneId) {},
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.edit),
                        ),
                      ),
                      // todo: Info screen using get request instead of passing data from here
                      onTap: () {
                        final phFuture = HttpApiClient.getPhoneById(phone.id);
                        Navigator.of(cc).push(MaterialPageRoute(
                            builder: (ccc) =>
                                HttpDetailsScreen(phoneFuture: phFuture)));
                      },
                    ),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
            // Fallback for unexpected states // No data available
          },
        ),
      ),
    );
  }
}
