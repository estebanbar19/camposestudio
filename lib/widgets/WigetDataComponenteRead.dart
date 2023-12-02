import 'dart:collection';
import 'dart:math';

import 'package:camposestudio/objects/AppPalette.dart';
import 'package:camposestudio/objects/Componente.dart';
import 'package:camposestudio/objects/Formatters/NumericalRangeFormatter.dart';
import 'package:camposestudio/objects/Indicador.dart';
import 'package:flutter/material.dart';

class WidgetDataComponenteRead extends StatefulWidget {
  WidgetDataComponenteRead({super.key, required this.indice, required this.componenteEvaluar});

  int indice;
  Componente componenteEvaluar;

  @override
  State<WidgetDataComponenteRead> createState() =>
      _WidgetDataComponenteReadState();
}

class _WidgetDataComponenteReadState extends State<WidgetDataComponenteRead> {
  Componente _componente = Componente.getInstance();
  late List<Map<String, Indicador>> indicadoresAux;
  late List<Map<String, String>> lastIndicadoresAux;

  @override
  void initState() {
    // TODO: implement initState
    indicadoresAux = _componente.indicadores.map((e) => e).toList();
    lastIndicadoresAux = indicadoresAux.map((e) => {}.cast<String,String>()).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: Card(
            color: AppPalette.tertiaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Componente: ",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      Expanded(
                          child: Text(
                        _componente.getNombreComponente(widget.indice),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                        softWrap: true,
                      ))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        Row(children: [
                          const Expanded(
                            child: Text(
                              "Indicadores",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ),
                          FilledButton(
                            onPressed: widget.componenteEvaluar.indicadores.elementAt(widget.indice).length < indicadoresAux[widget.indice].length ? () {
                              setState(() {
                                String id = "${Random().nextInt(10000)}";
                                widget.componenteEvaluar.indicadores.elementAt(widget.indice)[id] = Indicador("","", -1);
                              });
                            } : null,
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    AppPalette.quinaryColor)),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: AppPalette.primaryColor,
                                ),
                                Text("Añadir")
                              ],
                            ),
                          )
                        ]),
                        Column(
                          children: widget.componenteEvaluar.indicadores[widget.indice].entries.map((e) => Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: DropdownMenu(
                                  textStyle: TextStyle(color: AppPalette.primaryColor),
                                  inputDecorationTheme: InputDecorationTheme(fillColor: AppPalette.quaternaryColor, filled: true, iconColor: AppPalette.primaryColor),
                                  dropdownMenuEntries: indicadoresAux[widget.indice].entries.where((element) => !element.value.selected).map((e) => DropdownMenuEntry(value: "${e.key}-${e.value.nombre}", label: e.value.nombre)).toList(),
                                  onSelected: (value) {
                                    String id = value!.substring(0, value!.indexOf("-"));
                                    String val = value!.substring(value!.indexOf("-")+1);
                                    setState(() {
                                      if(lastIndicadoresAux[widget.indice].keys.contains(e.key)){
                                        indicadoresAux[widget.indice][lastIndicadoresAux[widget.indice][e.key]]!.setSelected(false);
                                      }
                                      lastIndicadoresAux[widget.indice][e.key] = id;
                                      widget.componenteEvaluar.setNombreIndicador(widget.indice, e.key, val);
                                      indicadoresAux[widget.indice][id]!.setSelected(true);
                                    });
                                  }
                                ,),
                              ),
                              Expanded(flex: 1, child: TextField(onChanged: (value) {
                                widget.componenteEvaluar.indicadores[widget.indice][e.key]!.setNota(value == "" ? 0 : double.parse(value));
                              }, keyboardType: TextInputType.number, inputFormatters: [NumericalRangeFormatter(min: 0, max: 5)], maxLength: 1, decoration: InputDecoration(counterText: "", border: OutlineInputBorder(), fillColor: Colors.white, filled: true, hintText: "Nota"),))
                            ],
                          )).toList(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
