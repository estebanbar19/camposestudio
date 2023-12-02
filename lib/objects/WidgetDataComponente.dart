import 'dart:math';

import 'package:camposestudio/objects/AppPalette.dart';
import 'package:camposestudio/objects/Componente.dart';
import 'package:camposestudio/objects/Indicador.dart';
import 'package:flutter/material.dart';

class WidgetDataComponente extends StatefulWidget {
  WidgetDataComponente({super.key, required this.indice});

  final int indice;

  @override
  State<WidgetDataComponente> createState() => _WidgetDataComponenteState();
}

class _WidgetDataComponenteState extends State<WidgetDataComponente> {

  Componente componentesData = Componente.getInstance();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: Card(
                  color: AppPalette.quaternaryColor,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: TextEditingController(text: componentesData.getNombreComponente(widget.indice)),
                          onChanged: (value){
                          componentesData.setNombreComponente(widget.indice, value);
                        }, decoration: InputDecoration(border: const OutlineInputBorder(), hintText: "Nombre del componente ${widget.indice+1}", filled: true, fillColor: Colors.white,),),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Expanded(child: Text("Indicadores", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 18),)),
                              FilledButton(onPressed: () {
                                setState(() {
                                  String id = "${Random().nextInt(10000)}";
                                  componentesData.indicadores.elementAt(widget.indice)[id] = Indicador("", "", 0);
                                });
                                }, style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(AppPalette.secondaryColor)), child: const Row(children: [Icon(Icons.add), Text("Add")],),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                          child: Column(
                            children: componentesData.indicadores.elementAt(widget.indice).entries.map((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(color: Color(
                                    0x88FFFFFF), borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 12),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Text("Indicador ${e.key}", style: TextStyle(fontSize: 12),),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(child: TextField(
                                            controller: TextEditingController(text: componentesData.indicadores.elementAt(widget.indice)[e.key]!.nombre),
                                            onChanged: (value) {
                                            componentesData.setNombreIndicador(widget.indice, e.key, value);
                                          }, decoration: const InputDecoration(border: OutlineInputBorder(), fillColor: Colors.white, filled: true, hintText: "Nombre"),)),
                                          IconButton(onPressed: () {
                                            setState(() {
                                              componentesData.removeIndicador(widget.indice, e.key);
                                            });
                                          }, icon: Icon(Icons.cancel, color: AppPalette.secondaryColor,), style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(AppPalette.quinaryColor)),)
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: TextField(
                                          controller: TextEditingController(text: componentesData.indicadores.elementAt(widget.indice)[e.key]!.descripcion),
                                          onChanged: (value) {
                                          componentesData.setDescripcionIndicador(widget.indice, e.key, value);
                                        }, decoration: InputDecoration(border: OutlineInputBorder(), fillColor: Colors.white, filled: true, hintText: "Descripción"),),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )).toList(),
                          ),
                        )
                      ],
                    ),
                  ))),
        ],
      ),
    );
  }
}
