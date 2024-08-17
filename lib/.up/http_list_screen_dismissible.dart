import 'package:flutter/material.dart';
import 'http_api_client.dart';
import 'http_details_screen.dart';
import 'http_entry_screen.dart';
import 'phone_model.dart';

class HttpListScreen extends StatefulWidget {
  const HttpListScreen({super.key});

  @override
  State<HttpListScreen> createState() => _HttpListScreenState();
}

class _HttpListScreenState extends State<HttpListScreen> {
  // This has to be here; in stateless part it's immutable, and inside build method added items are not reflected.
  List<String> objectIds = [
    'ff808181913d565501913dca3e9500a8',
    'ff808181912a2b8801913018747d0b3b',
    'ff808181915ec67c0191604c3ec4014b',
  ];

  Future<List<Phone>> getPhones() async {
    setState(() {}); // Triggers a rebuild for the FutureBuilder
    List<Future<Phone>> phoneFutures = [];
    for (var id in objectIds) {
      phoneFutures.add(HttpApiClient.getPhoneById(id));
    }
    var fixedPhoneFutures = await HttpApiClient.getAllPhones();
    phoneFutures.addAll(fixedPhoneFutures.map((item) => Future.value(item)));
    return Future.wait(phoneFutures);
  }

  void addObjectId(String newId) => setState(() => objectIds.add(newId));

  Future<dynamic> buildBottomSheet(BuildContext context, Widget child) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (c) => SizedBox(
          height: MediaQuery.of(context).size.height * .7, child: child),
    ).then((onSubmit) => onSubmit == true ? setState(() {}) : null);
    // Adding 'then' triggers a rebuild for the 'FutureBuilder' only after submitting, noting that removing 'if' condition causes rebuilding the state even if the user just presses the back button.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'New Entry',
        child: const Icon(Icons.add),
        onPressed: () => buildBottomSheet(
          context,
          HttpEntryScreen(onSaved: (newPhoneId) => addObjectId(newPhoneId)),
        ),
      ),
      appBar: AppBar(
        title: const Text('HTTP List'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              tooltip: 'Refresh',
              onPressed: () => getPhones(), // Assign a new future
              icon: const Icon(Icons.refresh),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: getPhones(),
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
                  return Dismissible(
                    key: Key(phone.id),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      // Remove the item from the cloud data source.
                      HttpApiClient.deletePhone(phone.id);
                      // Remove the item from the local list.
                      objectIds.remove(phone.id);
                      ScaffoldMessenger.of(cc).showSnackBar(
                          SnackBar(content: Text('${phone.name} deleted')));
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Card(
                      child: ListTile(
                        title: Text(phone.name),
                        subtitle: Text(
                            '${phone.color ?? ''}${phone.capacity == null ? '' : phone.color != null ? ', ${phone.capacity}' : phone.capacity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Update',
                              icon: const Icon(Icons.edit),
                              onPressed: () => buildBottomSheet(
                                context,
                                HttpEntryScreen(phone: phone, whoRU: 'update'),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Replace',
                              icon: const Icon(Icons.change_circle),
                              onPressed: () => buildBottomSheet(
                                context,
                                HttpEntryScreen(phone: phone, whoRU: 'replace'),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          final phFuture = HttpApiClient.getPhoneById(phone.id);
                          Navigator.of(cc).push(MaterialPageRoute(
                              builder: (ccc) =>
                                  HttpDetailsScreen(phoneFuture: phFuture)));
                        },
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
            // Fallback for unexpected states, i.e. No data available
          },
        ),
      ),
    );
  }
}
