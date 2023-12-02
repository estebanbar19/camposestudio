import 'dart:convert';

import 'package:camposestudio/objects/AppPalette.dart';
import 'package:camposestudio/objects/Indicador.dart';
import 'package:camposestudio/objects/WidgetListComponentes.dart';
import 'package:camposestudio/screens/graphicScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

import '../objects/Componente.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GettingInformationKey = GlobalKey();
  late final Widget _mainWidget = GettingInformation(
    key: GettingInformationKey,
  );
  String? code = null;
  Map<String, dynamic> snackbar = {
    "show": false,
    "isError": false,
    "message": "",
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Componente.resetInstance();
    getCode();
  }

  void getCode() async {
    DataSnapshot vinculationCodeDataSnapshot = await FirebaseDatabase.instance
        .ref()
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("vinculationCode")
        .get();
    setState(() {
      code = "${vinculationCodeDataSnapshot.value as int}";
      getComponentes();
    });
  }

  void getComponentes() async {
    DataSnapshot componentesDataSnapshot =
        await FirebaseDatabase.instance.ref().child(code!).get();
    List<Object?> listaComponentes =
        componentesDataSnapshot.value as List<Object?>;
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
  }

  bool validateData() {
    Componente componente = Componente.getInstance();
    if(componente.cantComponentes == 0) {
      setState(() {
        snackbar["show"] = true;
        snackbar["isError"] = true;
        snackbar["message"] = "No has generado una rubrica";
      });
      return false;
    }
    componente.indicadores.asMap().forEach((key, value) {
      if(value.length < 3){
        setState(() {
          snackbar["show"] = true;
          snackbar["isError"] = true;
          snackbar["message"] = "El componente ${componente.componentes.elementAt(key)} tiene menos de 3 indicadores";
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(children: [
        Column(
          children: [
            FittedBox(
              fit: BoxFit.contain,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: AppPalette.primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Transform.rotate(
                                angle: -45,
                                child: const Icon(Icons.link,
                                    color: AppPalette.quinaryColor)),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            const Text("Codigo de vinculación",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            code != null
                                ? Text(
                                    code!,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 2,
                                    ),
                                  )
                                : Container(
                                    color: Colors.blue,
                                    height: 20,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 2,
                color: AppPalette.quaternaryColor,
              ),
            ),
            Expanded(
              child: ListView(
                children: [_mainWidget],
              ),
            ),
          ],
        ),
        (snackbar["show"] as bool) ?
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
      ]),
      floatingActionButton: Container(
        height: 60,
        width: 100,
        child: FloatingActionButton(onPressed: () {
          if (validateData()) {
            DatabaseReference ref = FirebaseDatabase.instance.ref();
            ref.child(code!).set(jsonDecode(Componente.getInstance().componenteToJson()));
            setState(() {
              snackbar["show"] = true;
              snackbar["message"] = "Guardado exitosamente";
            });
            Future.delayed(Duration(seconds: 2), () {
              setState(() {
                snackbar["show"] = false;
                snackbar["message"] = "";
              });
            },);
          }
        }, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: const BorderSide(color: AppPalette.primaryColor, width: 2)), elevation: 10, backgroundColor: AppPalette.quinaryColor, child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save, color: AppPalette.primaryColor,),
            Text("Guardar", style: TextStyle(color: AppPalette.primaryColor, fontWeight: FontWeight.w700),),
          ],
        ),),
      ),
    );
  }
}

class GettingInformation extends StatefulWidget {
  const GettingInformation({Key? key}) : super(key: key);

  @override
  State<GettingInformation> createState() => _GettingInformationState();
}

class _GettingInformationState extends State<GettingInformation> {
  late TextEditingController _cantCamposController;
  bool enableBtnContinuar = false;
  bool showLayoutCampos = false;

  @override
  void initState() {
    // TODO: implement initState
    int cantComponentes = Componente.getInstance().cantComponentes;
    _cantCamposController = TextEditingController();
    if (cantComponentes > 0) {
      _cantCamposController.text = "$cantComponentes";
      showLayoutCampos = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cantCamposController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Ingrese la cantidad de componentes"),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Container(
            height: 70,
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: _cantCamposController,
                        onChanged: (value) {
                          setState(() {
                            showLayoutCampos = false;
                            enableBtnContinuar = (value != "" &&
                                2 < int.parse(value) &&
                                int.parse(value) <= 5);
                          });
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "No. de componentes"),
                        textAlign: TextAlign.center)),
                FilledButton(
                  onPressed: enableBtnContinuar
                      ? () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            Componente.getInstance().setCantComponentes(
                                _cantCamposController.text != ""
                                    ? int.parse(_cantCamposController.text)
                                    : 0);
                            Componente.getInstance()
                                .createIndicadoresPorComponentes();
                            showLayoutCampos = true;
                          });
                        }
                      : null,
                  style: ButtonStyle(
                    fixedSize: const MaterialStatePropertyAll(Size(130, 60)),
                    backgroundColor:
                        const MaterialStatePropertyAll(AppPalette.quinaryColor),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
                  ),
                  child: const Text(
                    "CONTINUAR",
                    style: TextStyle(color: AppPalette.primaryColor),
                  ),
                )
              ],
            ),
          ),
        ),
        Visibility(visible: showLayoutCampos, child: WidgetListComponentes()),
      ],
    );
  }

// @override
  // Widget build(BuildContext context) {
  //   return SizedBox(
  //     width: maxWidth,
  //     child: Padding(
  //       padding: const EdgeInsets.all(30.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           const Text(
  //             "Ingrese la cantidad de campos que va a evaluar",
  //             textAlign: TextAlign.start,
  //           ),
  //           TextField(
  //             keyboardType: TextInputType.number,
  //             inputFormatters: <TextInputFormatter>[
  //               FilteringTextInputFormatter.digitsOnly,
  //             ],
  //             decoration: const InputDecoration(border: OutlineInputBorder()),
  //             onChanged: (text) {
  //               setState(() {
  //                 if (text.isEmpty) {
  //                   cantCampos = 0;
  //                 } else {
  //                   cantCampos = int.parse(text);
  //                 }
  //
  //                 camposInfo.reset();
  //
  //                 for (int j = 0; j < cantCampos; j++) {
  //                   camposInfo.nombresDeComponentes[j] = "";
  //                   camposInfo.indicadoresPorComponente[j] = [];
  //                   camposInfo.cantidadIndicadores.add(0);
  //                 }
  //                 showLayoutCampos = false;
  //               });
  //             },
  //           ),
  //           TextButton(
  //             onPressed: (cantCampos == 0 || cantCampos < 3)
  //                 ? null
  //                 : () {
  //                     setState(() {
  //                       showLayoutCampos = true;
  //                     });
  //                   },
  //             child: const Text("Continuar"),
  //           ),
  //           Visibility(
  //             visible: showLayoutCampos,
  //             child: Column(
  //               children: [
  //                 Column(
  //                   children: List.generate(
  //                     cantCampos,
  //                     (index) => Padding(
  //                       padding: const EdgeInsets.all(6.0),
  //                       child: Container(
  //                         decoration: const BoxDecoration(
  //                             borderRadius:
  //                                 BorderRadius.all(Radius.circular(15.0)),
  //                             color: Color.fromARGB(255, 235, 235, 235)),
  //                         child: Column(
  //                           children: [
  //                             Padding(
  //                               padding: const EdgeInsets.all(12.0),
  //                               child: Row(
  //                                 children: [
  //                                   Padding(
  //                                     padding:
  //                                         const EdgeInsets.only(right: 12.0),
  //                                     child: Text("Componente ${index + 1}"),
  //                                   ),
  //                                   Expanded(
  //                                       child: TextField(
  //                                     onChanged: (text) {
  //                                       camposInfo.nombresDeComponentes[index] =
  //                                           text;
  //                                     },
  //                                     decoration: InputDecoration(
  //                                         border: OutlineInputBorder(),
  //                                         fillColor:
  //                                             Colors.white.withOpacity(0.3),
  //                                         filled: true,
  //                                         hintText: "Nombre del componente"),
  //                                   )),
  //                                 ],
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.symmetric(
  //                                   vertical: 0.0, horizontal: 8.0),
  //                               child: Row(
  //                                 children: [
  //                                   const Expanded(
  //                                       flex: 3,
  //                                       child: Text(
  //                                           "Aquí puedes poner la valoración por cada indicador")),
  //                                   Expanded(
  //                                       flex: 1,
  //                                       child: Row(
  //                                         crossAxisAlignment:
  //                                             CrossAxisAlignment.end,
  //                                         children: [
  //                                           FilledButton(
  //                                             onPressed: () {
  //                                               print(camposInfo.toString());
  //                                               print(
  //                                                   "${camposInfo.indicadoresPorComponente[index]!.length}  ${camposInfo.cantidadIndicadores[index]}");
  //                                               if (camposInfo
  //                                                       .indicadoresPorComponente[
  //                                                           index]!
  //                                                       .length ==
  //                                                   camposInfo
  //                                                           .cantidadIndicadores[
  //                                                       index]) {
  //                                                 setState(() {
  //                                                   camposInfo
  //                                                           .cantidadIndicadores[
  //                                                       index]++;
  //                                                 });
  //                                               }
  //                                             },
  //                                             child: Row(
  //                                               children: const [
  //                                                 Padding(
  //                                                   padding:
  //                                                       EdgeInsets.symmetric(
  //                                                           horizontal: 4.0,
  //                                                           vertical: 0.0),
  //                                                   child: Text("Agregar"),
  //                                                 ),
  //                                                 Icon(
  //                                                   Icons.add,
  //                                                   color: Colors.white,
  //                                                   size: 20,
  //                                                 )
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ))
  //                                 ],
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.all(10.0),
  //                               child: Column(
  //                                 children: List.generate(
  //                                     camposInfo.cantidadIndicadores[index],
  //                                     (index1) {
  //                                   return Indicador(
  //                                     index: index1,
  //                                     parentIndex: index,
  //                                     callback: () {
  //                                       removeIndicador(index, index1);
  //                                     },
  //                                   );
  //                                 }),
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 FilledButton(
  //                     onPressed: () {
  //                       if (camposInfo.indicadoresPorComponente.isNotEmpty) {
  //                         List<int> promediosComponentes = [];
  //
  //                         camposInfo.indicadoresPorComponente
  //                             .forEach((key, value) {
  //                           int prom = 0;
  //                           for (var element in value) {
  //                             prom += element.valoracion;
  //                           }
  //                           if (value.isNotEmpty) {
  //                             promediosComponentes
  //                                 .add((prom / value.length).round());
  //                           } else {
  //                             promediosComponentes.add(0);
  //                           }
  //                         });
  //
  //                         Navigator.of(context).pushNamed("/graphic",
  //                             arguments: GraphicScreenArguments(
  //                                 cantCampos,
  //                                 promediosComponentes,
  //                                 camposInfo.nombresDeComponentes,
  //                                 camposInfo.indicadoresPorComponente));
  //                       }
  //                     },
  //                     child: const Text("Continuar")),
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
