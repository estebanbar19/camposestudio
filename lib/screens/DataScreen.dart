import 'package:camposestudio/objects/AppPalette.dart';
import 'package:camposestudio/objects/Componente.dart';
import 'package:camposestudio/objects/Maths/Maths.dart';
import 'package:camposestudio/screens/graphicScreen.dart';
import 'package:camposestudio/widgets/WigetDataComponenteRead.dart';
import 'package:flutter/material.dart';

class DataScreen extends StatefulWidget {
  DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  Componente _componente = Componente.getInstance();
  Componente _componenteEvaluar = Componente();

  Map<String, dynamic> snackbar = {
    "show": false,
    "isError": false,
    "message": "",
  };

  bool validateData() {
    _componenteEvaluar.indicadores.asMap().forEach((key, value) {
      bool success = true;
      String message = "";
      if(value.length < 3){
        success = false;
        message = "El componente ${_componenteEvaluar.componentes.elementAt(key)} tiene menos de 3 indicadores";
      }

      if(success) {
        value.forEach((keyIndicador, valueIndicador) {
          if (valueIndicador.nota == -1) {
            success = false;
            message = "El componente ${_componenteEvaluar.componentes.elementAt(key)} tiene un indicador sin nota asignada";
          }
          if(valueIndicador.nombre == ""){
            success = false;
            message = "El componente ${_componenteEvaluar.componentes.elementAt(key)} tiene un indicador sin asignar";
          }
        });
      }

      if(!success) {
        setState(() {
          snackbar["show"] = true;
          snackbar["isError"] = true;
          snackbar["message"] = message;
        });
      }
    });

    if(snackbar["show"] as bool){
      Future.delayed(Duration(seconds: 2), () {
        setState((){
          snackbar["show"] = false;
          snackbar["isError"] = false;
          snackbar["message"] = "";
        });
      },);
    }

    return !snackbar["isError"] as bool;
  }

  @override
  void initState() {
    // TODO: implement initState
    _componenteEvaluar.setCantComponentes(_componente.cantComponentes);
    if(_componenteEvaluar.indicadores.isEmpty) _componenteEvaluar.createIndicadoresPorComponentes();
    _componenteEvaluar.setNombresComponentes(_componente.componentes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        ListView.builder(itemCount: _componente.cantComponentes, itemBuilder: (BuildContext context, int index) => WidgetDataComponenteRead(indice: index, componenteEvaluar: _componenteEvaluar)), (snackbar["show"] as bool) ?
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Container(
            width: MediaQuery.of(context).size.width*0.65,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 15),
              child: Container(decoration: BoxDecoration(color: snackbar["isError"] as bool ? Color.fromARGB(255, 255, 143, 132) : Color.fromARGB(255, 163, 255, 132), borderRadius: BorderRadius.circular(15), border: Border.all(color: snackbar["isError"] as bool ? Colors.red : Colors.green, width: 2)), child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("${snackbar["message"]}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
              ),),
            ),
          )],
        ) : Container(),
      ],),
      floatingActionButton: Container(
        height: 60,
        width: 100,
        child: FloatingActionButton(onPressed: (){
          if(validateData()){
            List<List<int>> maxAreasPerComponente = [];
            _componenteEvaluar.getNotasPorComponentes().forEach((element) {
              maxAreasPerComponente.add(Maths().CalcAreaMax(element));
            });

            List<String> titles = _componenteEvaluar.componentes;
            Navigator.of(context).pushNamed("/graphic", arguments: GraphicScreenArguments(titles,_componenteEvaluar,maxAreasPerComponente));
          }
        }, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: const BorderSide(color: AppPalette.primaryColor, width: 2)), elevation: 10, backgroundColor: AppPalette.quinaryColor, child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.graphic_eq_sharp, color: AppPalette.primaryColor,),
            Text("Gráficar", style: TextStyle(color: AppPalette.primaryColor, fontWeight: FontWeight.w700),),
          ],
        ), ),
      ),
    );
  }
}
