import 'package:camposestudio/screens/graphicScreen.dart';
import 'package:camposestudio/screens/initialScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EvaluAPP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        '/': (context) => const MyHomePage(title: "Evaluación de componentes",),
        '/graphic': (context) => const GraphicScreen(),
      },
        // "Evaluación de componentes"
    );
  }
}


