import 'package:camposestudio/screens/graphicScreen.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../objects/CamposInfo.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  final Widget _mainWidget = const GettingInformation();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [widget._mainWidget],
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
  int cantCampos = 0;
  bool showLayoutCampos = false;
  List<CamposInfo> campoInfo = [];
  List<String> labelsComponents = [];

  // Future<Uint8List?> getPlot({valoraciones = List}) async {
  //   //var request = http.Request('GET', Uri.parse("http:/localhost:8000/plot"));
  //   final Uri url = Uri.parse("http://localhost:8000/plot");
  //   final String body = jsonEncode({"cant": 5, "data": valoraciones});
  //
  //   final response = await http.post(url,
  //       headers: {"Content-Type": "application/json", "Accept": '*/*'},
  //       body: body);
  //
  //   if (response.statusCode == 200) {
  //     return response.bodyBytes;
  //   } else {
  //     return null;
  //   }
  // }

  static const double maxWidth = 450;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Ingrese la cantidad de campos que va a evaluar",
              textAlign: TextAlign.start,
            ),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,],
              decoration:
              const InputDecoration(border: OutlineInputBorder()),
              onChanged: (text) {
                setState(() {
                  if (text.isEmpty) {
                    cantCampos = 0;
                  } else {
                    cantCampos = int.parse(text);
                  }

                  campoInfo = [];

                  for (int j = 0; j < cantCampos; j++) {
                    campoInfo.add(CamposInfo(0, [], []));
                  }
                  showLayoutCampos = false;
                });
              },
            ),
            TextButton(
              onPressed: (cantCampos == 0 || cantCampos < 3)
                  ? null
                  : () {
                setState(() {
                  showLayoutCampos = true;
                  for(int i = 0; i < cantCampos; i++){
                    labelsComponents.add("");
                  }
                });
              },
              child: const Text("Continuar"),
            ),
            Visibility(
              visible: showLayoutCampos,
              child: Column(
                children: [
                  Column(
                    children: List.generate(
                      cantCampos,
                          (index) => Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(15.0)),
                              color: Color.fromARGB(
                                  255, 235, 235, 235)),
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Text("Componente ${index+1}"),
                                  ),
                                  Expanded(child: TextField(
                                    onChanged: (text) {
                                      if(labelsComponents.isEmpty) {
                                        labelsComponents.add(text);
                                      }else {
                                        if(index == labelsComponents.length) {
                                          campoInfo[index].valoracionesLabels.add(text);
                                        }else {
                                          labelsComponents[index] = text;
                                        }
                                      }
                                    },
                                    decoration:
                                    InputDecoration(
                                        border:
                                        OutlineInputBorder(), fillColor: Colors.white.withOpacity(0.3), filled: true, hintText: "Nombre del componente"),
                                  )),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                              child: Row(
                                children: [
                                  const Expanded(flex: 3,child: Text("Aquí puedes poner la valoración por cada indicador")),
                                  Expanded(flex: 1, child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      FilledButton(onPressed: () {
                                        if(campoInfo[index].valoracionesLabels.length == campoInfo[index].cantValoraciones){
                                          setState(() {
                                            campoInfo[index].increment();
                                          });
                                        }
                                      },child: Row(children: const [Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
                                        child: Text("Agregar"),
                                      ), Icon(Icons.add, color: Colors.white,size: 20,)],),),
                                    ],
                                  ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [...List.generate(campoInfo[index].cantValoraciones, (index1) => Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                                        child: Column(
                                          children: [
                                            Text("Indicador ${index1+1}:", textAlign: TextAlign.start,),
                                            Row(children: [Expanded(child: TextField(
                                              onChanged: (text){
                                                if(campoInfo[index].valoracionesLabels.isEmpty) {
                                                  campoInfo[index].valoracionesLabels.add(text);
                                                }else {
                                                  if(index1 == campoInfo[index].valoracionesLabels.length) {
                                                    campoInfo[index].valoracionesLabels.add(text);
                                                  }else {
                                                    campoInfo[index].valoracionesLabels[index1] = text;
                                                  }
                                                }
                                              },
                                              decoration:
                                              InputDecoration(
                                                  border:
                                                  OutlineInputBorder(), hintText: "Descripción", fillColor: Colors.white.withOpacity(0.3), filled: true,),
                                            )),],)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          const Text(""),
                                          Row(children: [Expanded(child: TextField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly,],
                                            onChanged: (text) {
                                              int value = text.isEmpty ? 0 : int.parse(text);

                                              if(campoInfo[index].valoraciones.isEmpty) {
                                                campoInfo[index].valoraciones.add(value);
                                              }else {
                                                if(index1 == campoInfo[index].valoraciones.length) {
                                                  campoInfo[index].valoraciones.add(value);
                                                }else {
                                                  campoInfo[index].valoraciones[index1] = value;
                                                }
                                              }
                                            },
                                            decoration:
                                            InputDecoration(
                                                border:
                                                OutlineInputBorder(), fillColor: Colors.white.withOpacity(0.3), filled: true, hintText: "Valoración"),
                                          )),],)
                                        ],
                                      ),
                                    ),
                                  ],
                                ))],
                              ),
                            )
                          ],),
                        ),
                      ),
                    ),
                  ),
                  FilledButton(
                      onPressed: () {
                        if(campoInfo.isNotEmpty) {
                          List<int> promediosValoraciones = [];

                          campoInfo.forEach((element) {
                            int prom = 0;
                            element.valoraciones.forEach((element1) {prom+=element1;});
                            if(element.valoraciones.isNotEmpty) {
                              promediosValoraciones.add((prom / element.valoraciones.length).round());
                            }else{
                              promediosValoraciones.add(0);
                            }
                          });

                          Navigator.of(context).pushNamed("/graphic",
                              arguments: GraphicScreenArguments(
                                  campoInfo.length,
                                  promediosValoraciones,
                                  campoInfo,
                                  labelsComponents
                              ));
                        }
                      },
                      child: const Text("Continuar")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}