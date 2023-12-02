import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../objects/AppPalette.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  dynamic args;

  var user = {
    'email': '',
    'confirm_email': '',
    'password': '',
    'confirm_password': ''
  };

  Map<String, dynamic> error = {'message': '', 'success': false};

  @override
  Widget build(BuildContext context) {
    args = (ModalRoute.of(context)!.settings.arguments ?? LoginArguments(true))
        as LoginArguments;

    return Scaffold(
      body: args.isSignIn
          ? Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Iniciar sesión",
                        style: TextStyle(
                            color: AppPalette.quaternaryColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        width: 500,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Container(
                                color: AppPalette.secondaryColor,
                                height: 4,
                              ),
                            ),
                            error['success'] as bool ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: BoxDecoration(color: const Color.fromARGB(
                                    255, 255, 175, 175),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(error['message'] as String,
                                        style: const TextStyle(color: Colors.red,), softWrap: true,),
                                    ),
                                  )
                                  ],
                                ),
                              ),
                            ) : Container(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: TextField(
                                onTap: (){
                                  setState(() {
                                    error['message'] = '';
                                    error['success'] = false;
                                  });
                                },
                                onChanged: (val) {
                                  user['email'] = val;
                                },
                                decoration: InputDecoration(
                                    labelText: "E-mail",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: AppPalette.quaternaryColor,
                                        ))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: TextField(
                                onTap: (){
                                  setState(() {
                                    error['message'] = '';
                                    error['success'] = false;
                                  });
                                },
                                onChanged: (val) {
                                  user['password'] = val;
                                },
                                decoration: InputDecoration(
                                    labelText: "Contraseña",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: AppPalette.quaternaryColor,
                                        ))),
                                obscureText: true,
                              ),
                            ),
                            Row(mainAxisAlignment: MainAxisAlignment.end, children: [TextButton(onPressed: () {
                              if(user["email"] != ""){
                                FirebaseAuth.instance.sendPasswordResetEmail(email: user["email"]!).then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Se ha enviado un correo de recuperación"),));
                                }).catchError((error) {
                                  print(error);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ha habido un error"),));
                                });

                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ingresa un correo electronico"),));
                              }
                              }, child: const Text("He olvidado mi contraseña", style: TextStyle(color: AppPalette.secondaryColor, fontStyle: FontStyle.italic),))],)
                          ],
                        ),
                      ),
                      FilledButton(
                        onPressed: () async {
                          Map<String,dynamic> validation = validateData(user, true);
                          if(validation['success'] as bool){
                            UserCredential? credentials;
                            try{
                              credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(email: user['email']!, password: user['password']!);
                            }on FirebaseAuthException catch (e){
                              setState(() {
                                error['message'] = e.message;
                                error['success'] = true;
                              });
                            }

                            if(credentials != null){
                              Navigator.of(context).pushNamed('/initial');
                            }
                          }else{
                            setState(() {
                              error['message'] = validation['message'];
                              error['success'] = true;
                            });
                          }
                        },

                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                AppPalette.secondaryColor)),
                        child: const Text(
                          "Ingresar",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton(onPressed: () => {Navigator.of(context).pop()}, style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.transparent), iconColor: MaterialStatePropertyAll(AppPalette.quinaryColor), fixedSize: MaterialStatePropertyAll(Size(120, 50)),), child: const Row(children: [Icon(Icons.arrow_back_ios_new_outlined), Text("Volver", style: TextStyle(color: AppPalette.quinaryColor),)],),)
              ]),
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Crear usuario",
                        style: TextStyle(
                            color: AppPalette.quaternaryColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        width: 500,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Container(
                                color: AppPalette.secondaryColor,
                                height: 4,
                              ),
                            ),
                            error['success'] as bool ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: BoxDecoration(color: const Color.fromARGB(
                                    255, 255, 175, 175),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(error['message'] as String,
                                      style: const TextStyle(color: Colors.red),),
                                  )
                                  ],
                                ),
                              ),
                            ) : Container(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: TextField(
                                onTap: (){
                                  setState(() {
                                    error['message'] = '';
                                    error['success'] = false;
                                  });
                                },
                                onChanged: (val) {
                                  user['email'] = val;
                                },
                                decoration: InputDecoration(
                                    labelText: "E-mail",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: AppPalette.quaternaryColor,
                                        ))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: TextField(
                                onTap: (){
                                  setState(() {
                                    error['message'] = '';
                                    error['success'] = false;
                                  });
                                },
                                onChanged: (val) {
                                  user['confirm_email'] = val;
                                },
                                decoration: InputDecoration(
                                    labelText: "Confirmar e-mail",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: AppPalette.quaternaryColor,
                                        ))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: TextField(
                                onTap: (){
                                  setState(() {
                                    error['message'] = '';
                                    error['success'] = false;
                                  });
                                },
                                onChanged: (val) {
                                  user['password'] = val;
                                },
                                decoration: InputDecoration(
                                    labelText: "Contraseña",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: AppPalette.quaternaryColor,
                                        ))),
                                obscureText: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: TextField(
                                onTap: (){
                                  setState(() {
                                    error['message'] = '';
                                    error['success'] = false;
                                  });
                                },
                                onChanged: (val) {
                                  user['confirm_password'] = val;
                                },
                                decoration: InputDecoration(
                                    labelText: "Confirmar contraseña",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: AppPalette.quaternaryColor,
                                        ))),
                                obscureText: true,
                              ),
                            )
                          ],
                        ),
                      ),
                      FilledButton(
                        onPressed: () async {
                          Map<String,dynamic> validation = validateData(user, false);
                          if(validation['success'] as bool){
                            UserCredential? credentials;
                            try{
                              credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user['email']!, password: user['password']!);
                              generateVinculationCode(credentials.user!);
                            }on FirebaseAuthException catch (e){
                              setState(() {
                                error['message'] = e.message;
                                error['success'] = true;
                              });
                            }

                            if(credentials != null){
                              Navigator.of(context).pushNamed('/initial');
                            }
                          }else{
                            setState(() {
                              error['message'] = validation['message'];
                              error['success'] = true;
                            });
                          }
                        },
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                AppPalette.secondaryColor)),
                        child: const Text(
                          "Registrarme",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton(onPressed: () => {Navigator.of(context).pop()}, style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.transparent), iconColor: MaterialStatePropertyAll(AppPalette.quinaryColor), fixedSize: MaterialStatePropertyAll(Size(120, 50)),), child: const Row(children: [Icon(Icons.arrow_back_ios_new_outlined), Text("Volver", style: TextStyle(color: AppPalette.quinaryColor),)],),)
              ]),
            ),
    );
  }
}

void generateVinculationCode(User user){
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  String code = (DateTime.now().microsecondsSinceEpoch).toString();
  code = code.substring(0,6);
  int vinculationCode = int.parse(code);
  ref.child(user.uid).child("vinculationCode").set(vinculationCode);
}

Map<String,dynamic> validateData(Map<String,String> userData, bool isSignIn){

  if(userData['email'] == '' && userData['password'] == '' || (!isSignIn && (userData['confirm_email'] == '' && userData['confirm_password'] == ''))){
    return {'message': 'Please fill all fields', 'success': false};
  }

  if(!isSignIn && (userData['email'] != userData['confirm_email'])) return {'message': "Emails don't match", 'success': false};

  if(!isSignIn && (userData['password'] != userData['confirm_password'])) return {'message': "Passwords don't match", 'success': false};

  return {'message': '', 'success': true};
}

class LoginArguments {
  bool _isSignIn = false;

  LoginArguments(this._isSignIn);

  bool get isSignIn => _isSignIn;

  set isSignIn(bool value) {
    _isSignIn = value;
  }
}
