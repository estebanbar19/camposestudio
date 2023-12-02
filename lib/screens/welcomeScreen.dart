import 'package:camposestudio/objects/AppPalette.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).popAndPushNamed('/main');
    },);

    return Scaffold(
      body: Container(
        color: AppPalette.quinaryColor,
        child: Center(child: Text("Welcome", style: TextStyle(color: AppPalette.secondaryColor, fontSize: 30, fontWeight: FontWeight.w900,),),),
      ),
    );
  }
}
