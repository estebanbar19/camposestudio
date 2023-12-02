import 'package:camposestudio/objects/Componente.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import '../objects/IndicadoresInfo.dart';

class Indicador extends StatefulWidget {
  int index;
  int parentIndex;
  // CamposInfo camposInfo = CamposInfo.getInstance();
  final VoidCallback callback;
  Indicador({Key? key, required this.index, required this.parentIndex, required this.callback}) : super(key: key);

  @override
  State<Indicador> createState() => _IndicadorState();
}

class _IndicadorState extends State<Indicador> {

  bool nameIndicatorIsEmpty = true;
  String nombre = "";
  late GlobalKey globalKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.camposInfo);
    // globalKey = widget.camposInfo.key;
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
    // return Row(
    //   children: [
    //     Expanded(
    //       flex: 2,
    //       child: Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
    //         child: Column(
    //           children: [
    //             Row(
    //               children: [
    //                 Text("Indicador ${widget.index}:", textAlign: TextAlign.start,),
    //               ],
    //             ),
    //             Row(children: [Expanded(child: TextField(
    //               controller: TextEditingController()..text= (widget.camposInfo.indicadoresPorComponente.isNotEmpty && widget.camposInfo.indicadoresPorComponente[widget.parentIndex]!.isNotEmpty) ? (widget.camposInfo.indicadoresPorComponente[widget.parentIndex]!.length > widget.index ? widget.camposInfo.indicadoresPorComponente[widget.parentIndex]![widget.index].nombreIndicador : "") : "",
    //               onChanged: (text){
    //                 /*if(widget.camposInfo.indicadoresPorComponente[widget.parentIndex]!.isEmpty) {
    //                   widget.camposInfo.indicadoresPorComponente[widget.parentIndex];
    //                   campoInfo[index].valoracionesLabels.add(text);
    //                 }else {
    //                   if(widget.index == campoInfo[index].valoracionesLabels.length) {
    //                     campoInfo[index].valoracionesLabels.add(text);
    //                   }else {
    //                     campoInfo[index].valoracionesLabels[widget.index] = text;
    //                   }
    //                 }*/
    //                 text.isEmpty ? nameIndicatorIsEmpty = true : nameIndicatorIsEmpty = false;
    //                 nombre = text;
    //               },
    //               decoration:
    //               InputDecoration(
    //                 border:
    //                 OutlineInputBorder(), hintText: "Descripción", fillColor: Colors.white.withOpacity(0.3), filled: true,),
    //             )),],)
    //           ],
    //         ),
    //       ),
    //     ),
    //     Expanded(
    //       flex: 1,
    //       child: Column(
    //         children: [
    //           const Text(""),
    //           Row(children: [Expanded(child: TextField(
    //             controller: TextEditingController()..text= (widget.camposInfo.indicadoresPorComponente.isNotEmpty && widget.camposInfo.indicadoresPorComponente[widget.parentIndex]!.isNotEmpty) ? "${(widget.camposInfo.indicadoresPorComponente[widget.parentIndex]!.length > widget.index ? widget.camposInfo.indicadoresPorComponente[widget.parentIndex]![widget.index].valoracion : '')}" : "",
    //             keyboardType: TextInputType.number,
    //             inputFormatters: <TextInputFormatter>[
    //               FilteringTextInputFormatter.digitsOnly,
    //               RangeTextInputFormatter(1, 5),
    //             ],
    //             onChanged: (text) {
    //               int value = text.isEmpty ? 0 : int.parse(text);
    //               print(value);
    //               if(!nameIndicatorIsEmpty){
    //                 if(value >= 0 && value <= 5){
    //                   if(widget.camposInfo.indicadoresPorComponente[widget.parentIndex]!.isEmpty){
    //                     widget.camposInfo.indicadoresPorComponente[widget.parentIndex]!.add(IndicadoresInfo(nombre, value));
    //                   }else{
    //                     if(widget.index == widget.camposInfo.indicadoresPorComponente[widget.parentIndex]!.length){
    //                       widget.camposInfo.indicadoresPorComponente[widget.parentIndex]!.add(IndicadoresInfo(nombre, value));
    //                     }else{
    //                       widget.camposInfo.indicadoresPorComponente[widget.parentIndex]![widget.index] = IndicadoresInfo(nombre, value);
    //                     }
    //                   }
    //                 }
    //               }
    //             },
    //             decoration:
    //             InputDecoration(
    //                 border:
    //                 OutlineInputBorder(), fillColor: Colors.white.withOpacity(0.3), filled: true, hintText: "Valoración"),
    //           )),],)
    //         ],
    //       ),
    //     ),
    //     FilledButton(onPressed: () {
    //       widget.camposInfo.indicadoresPorComponente[widget.parentIndex]!.removeAt(widget.index);
    //       widget.camposInfo.cantidadIndicadores[widget.parentIndex]--;
    //       widget.callback!.call();
    //     }, child: Row(children: [Icon(Icons.delete, color: Colors.white,), Text("Eliminar")],), style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),)
    //   ],
    // );
  }
}

class RangeTextInputFormatter extends TextInputFormatter {
  final int minValue;
  final int maxValue;

  RangeTextInputFormatter(this.minValue, this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int value = newValue.text.isNotEmpty ? int.parse(newValue.text) : minValue;

    if (value < minValue || value > maxValue) {
      // Input is invalid or outside the desired range, revert to old value
      return oldValue;
    }

    return newValue;
  }
}
