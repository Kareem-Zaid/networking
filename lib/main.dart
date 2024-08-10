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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        appBarTheme:
            AppBarTheme(color: Theme.of(context).colorScheme.inversePrimary),
      ),
      home: const HomeScreen(),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => const HomeScreen(),
      // HttpSample.route: (context) => const HttpSample(),
      // },
    );
  }
}

// v1.0.0: http client example
// v1.0.0: chopper client example
// v1.0.0: dio client example
// v1.0.0: prayer times
// v1.0.0: weather