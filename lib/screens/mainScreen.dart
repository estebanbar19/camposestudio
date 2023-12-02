import 'package:camposestudio/objects/Componente.dart';
import 'package:camposestudio/objects/Indicador.dart';
import 'package:camposestudio/screens/loginScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../objects/AppPalette.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  late TextEditingController _codeController;
  Map<String, dynamic> error = {'message': '', 'success': true};

  @override
  void initState() {
    // TODO: implement initState
    _codeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    handleCheckCode() async {
      setState(() {
        error["success"] = true;
        error["message"] = "";
      });
      if(_codeController.text.isNotEmpty){
        // print("Waiting");
        DatabaseReference ref = FirebaseDatabase.instance.ref();
        DataSnapshot componenteDataSnapshot = await ref.child(_codeController.text).get();
        if(componenteDataSnapshot.exists) {
          List<Object?> listaComponentes =
              componenteDataSnapshot.value as List<Object?>;
          Componente componenteData = Componente.getInstance();
          componenteData.setCantComponentes(listaComponentes.length);
          componenteData.createIndicadoresPorComponentes();
          List<Map<String, Indicador>> indicadores = [];
          listaComponentes.asMap().forEach((key, value) {
            Map<String, dynamic> componenteInfo =
                (value as Map<Object?, Object?>).cast<String, dynamic>();
            componenteData.setNombreComponente(
                key, componenteInfo["nombre"] as String);
            Map<String, Indicador> indicador = {};
            (componenteInfo["indicadores"] as Map<Object?, Object?>)
                .cast<String, Object?>()
                .forEach((key, value) {
              indicador[key] = Indicador(
                  ((value as Map<Object?, Object?>)
                      .cast<String, dynamic>())["nombre"] as String,
                  ((value as Map<Object?, Object?>)
                      .cast<String, dynamic>())["descripcion"] as String,
                  (((value).cast<String, dynamic>())["nota"] as int) * 1.0);
            });
            indicadores.add(indicador);
          });
          componenteData.setIndicadores(indicadores);
          Navigator.of(context).pushNamed("/data");
        }else{
          setState(() {
            error["message"] = "Este código no existe";
            error["success"] = false;
          });
        }
        // print("Finished");
      }
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppPalette.secondaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Bienvenido al", style: TextStyle(color: AppPalette.quinaryColor, fontSize: 30, fontWeight: FontWeight.w900), textAlign: TextAlign.center,),
              const Text("Sistema de Evaluación", style: TextStyle(color: AppPalette.quinaryColor, fontSize: 50, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: SizedBox(
                  width: 500,
                  child: Column(
                    children: [
                      const Text("Ingresa con tu codigo de vinculación"),
                      SizedBox(
                        height: 60,
                        child: Row(children: [
                          Expanded(child: TextField(controller: _codeController, keyboardType: TextInputType.number, maxLength: 6, decoration: InputDecoration(counterText: "", hintText: "000000", filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderSide: const BorderSide(color: AppPalette.quinaryColor, width: 5), borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)))), textAlign: TextAlign.center,)),
                          Container(height: double.maxFinite, child: FilledButton(onPressed: handleCheckCode, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(AppPalette.quaternaryColor), shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20))))), child: Text("Continuar"))),
                        ],),
                      ),
                      if(!error['success']) Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text("Error: ${error["message"]}", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),),
                      ),
                      Padding(padding: const EdgeInsets.all(20), child: Container(color: AppPalette.quinaryColor, height: 2,),),
                      FilledButton(onPressed: () => Navigator.of(context).pushNamed('/login', arguments: LoginArguments(false)), style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(AppPalette.quaternaryColor)), child: const Text("Crear código de vinculación")),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        const Text("Ya tienes un usuario?"),
                        TextButton(onPressed: () => Navigator.of(context).pushNamed('/login', arguments: LoginArguments(true)), child: const Text("Ingresa aquí", style: TextStyle(color: AppPalette.quinaryColor), textAlign: TextAlign.center,))
                      ],)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
