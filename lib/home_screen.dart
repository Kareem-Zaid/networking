import 'package:flutter/material.dart';
import 'package:networking/dio_list_screen.dart';
import 'package:networking/http_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Widget> screens = [
    HttpListScreen(), // https://api.restful-api.dev/objects: 100 requests/day
    DioListScreen(), // https://api.restful-api.dev/objects: 100 requests/day
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Screens')),
      body: ListView.builder(
        itemCount: screens.length,
        itemBuilder: (c, i) => Padding(
          padding: const EdgeInsets.all(4.0),
          child: ElevatedButton(
            onPressed: () => Navigator.of(c)
                .push(MaterialPageRoute(builder: (context) => screens[i])),
            child: Text(screens[i].toString().replaceAllMapped(
                RegExp(r'([a-z])([A-Z])'),
                (match) => '${match.group(1)} ${match.group(2)}')),
          ),
        ),
      ),
    );
  }
}
