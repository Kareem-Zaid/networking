import 'package:flutter/material.dart';
import 'package:networking/dio_details_screen.dart';
import 'dio_api_client.dart';
import 'dio_entry_screen.dart';
import 'phone_model.dart';

class DioListScreen extends StatefulWidget {
  const DioListScreen({super.key});

  @override
  State<DioListScreen> createState() => _DioListScreenState();
}

class _DioListScreenState extends State<DioListScreen> {
  // This has to be here; in stateless part it's immutable, and inside build method added items are not reflected.
  List<String> objectIds = [
    'ff808181913d565501913dca3e9500a8',
    'ff808181912a2b8801913018747d0b3b',
    'ff808181915ec67c0191604c3ec4014b',
    'ff808181916475bf01916898acda047a',
    // 'ff808181916475bf019168a4651a0488', // To be deleted manually // Deleted
  ];
  // Be aware that deleting items from this list will not delete them from the server, and vice versa; and vice versa is the BIG PROBLEM, as it would cause 404 error.
  // Another notation is that refreshing the list (see [1]) after removing deleted item from the list (see [2]) doesn't throw 404 error, but not executing [2] throws.

  Future<List<Phone>> getPhoneFutures() async {
    setState(() {}); // Triggers a rebuild for the FutureBuilder
    List<Future<Phone>> phoneFutures = [];
    for (var id in objectIds) {
      phoneFutures.add(DioApiClient.getPhone(id));
    }
    var fixedPhoneFutures = await DioApiClient.getAllPhones();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent.shade200,
        tooltip: 'New Entry',
        child: const Icon(Icons.add),
        onPressed: () => buildBottomSheet(
          context,
          DioEntryScreen(onSaved: (newPhoneId) => addObjectId(newPhoneId)),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade200,
        title: const Text('Dio Phone List'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              tooltip: 'Refresh',
              onPressed: () => getPhoneFutures(), // Assign a new future [1]
              icon: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: getPhoneFutures(),
          builder: (c, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (cc, index) {
                  final phone = snapshot.data![index];
                  return Dismissible(
                    key: Key(phone.id),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      DioApiClient.deletePhone(phone.id);
                      objectIds.remove(phone.id); // [2]
                      debugPrint(objectIds.toString());
                      ScaffoldMessenger.of(cc).showSnackBar(SnackBar(
                        content: Text(
                            '${phone.name.isNotEmpty ? phone.name : 'Untitled phone'} deleted'),
                      ));
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
                                DioEntryScreen(phone: phone, whoRU: 'update'),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Replace',
                              icon: const Icon(Icons.change_circle),
                              onPressed: () => buildBottomSheet(
                                context,
                                DioEntryScreen(phone: phone, whoRU: 'replace'),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          final phFuture = DioApiClient.getPhone(phone.id);
                          Navigator.of(cc).push(MaterialPageRoute(
                              builder: (ccc) =>
                                  DioDetailsScreen(phoneFuture: phFuture)));
                        },
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
