import 'package:camposestudio/firebase_options.dart';
import 'package:camposestudio/screens/DataScreen.dart';
import 'package:camposestudio/screens/graphicScreen.dart';
import 'package:camposestudio/screens/initialScreen.dart';
import 'package:camposestudio/screens/mainScreen.dart';
import 'package:camposestudio/screens/welcomeScreen.dart';
import 'package:flutter/material.dart';
import 'screens/loginScreen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        useMaterial3: true,
        primaryColor: const Color.fromARGB(96, 244, 225, 82),
      ),
      initialRoute: "/",
      routes: {
        '/': (context) => WelcomePage(),
        '/main': (context) => MainPage(),
        '/initial': (context) => MyHomePage(title: "Evaluación de componentes",),
        '/data': (context) => DataScreen(),
        '/login': (context) => LoginPage(),
        '/graphic': (context) => GraphicScreen(),
      },
        // "Evaluación de componentes"
    );
  }
}


