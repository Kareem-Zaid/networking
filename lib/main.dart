import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Networking',
      theme: ThemeData(
        fontFamily: 'Courier',
        scaffoldBackgroundColor: Theme.of(context).colorScheme.inversePrimary,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme:
            AppBarTheme(color: Theme.of(context).colorScheme.inversePrimary),
      ),
      home: const HomeScreen(),
    );
  }
}

// v1.0.0: HTTP API client request methods + UI {240817}
// v1.0.0: Dio API client requests methods (same UI) {240819}
// v1.0.0: Prayer Times
// v1.0.0: Weather
// v1.1.0: Replace null values with '' (See HttpListScreen line: 90, ListTile(subtitle: Text(...)))
// v1.1.0: Add keyboard type to CustomTextField
// v1.1.0: Let patch / update entry IconButton/UI be inside HttpDetailsScreen besides each property
// v1.2.0: Enable user to add custom properties to an entry
// v1.2.0: Add loading indicator into Submit button and other API awaits
// v1.2.0: Test posting and getting all data fields (int & double have issues)
// v1.3.0: Test the results of the universal GET-POST-PUT-PATCH-DELETE API request
// v1.4.0: Chopper client example
// v1.4.0: Swipe then press to delete (https://chatgpt.com/c/7298bde3-8595-4c93-b8c7-dbed282aaa55)
// v1.5.0: Chopper & GetX API client requests methods (same UI)
