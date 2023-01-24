import 'package:flutter/material.dart';

import 'screens/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Radar',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
          useMaterial3: true
      ),
      routes: {
        HomePage.routeName: (context) => const HomePage(),
      },
      initialRoute: HomePage.routeName,
    );
  }
}
