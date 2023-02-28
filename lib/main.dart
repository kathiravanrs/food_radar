import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodradar/screens/results_page.dart';

import 'helper/temp_data.dart';
import 'screens/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp( const MyApp()));
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
      ),
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        ResultsPage.routeName: (context)=> ResultsPage(apiResult: result),
        // ResultsPage.routeName: (context) => const ResultsPage(apiResult: apiResult),
      },
      initialRoute: HomePage.routeName,
    );
  }
}
