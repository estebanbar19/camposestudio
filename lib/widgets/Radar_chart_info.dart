import 'dart:convert';

import 'package:camposestudio/objects/OpenAI/ChatCompletion/ChatCompletionApi.dart';
import 'package:camposestudio/objects/OpenAI/Models/ChatCompletionResponse.dart';
import 'package:flutter/material.dart';

class RadarChartInfo extends StatefulWidget {
  final Widget radarChart;
  final String title;
  final List<int> data;
  final bool isGeneral;
  final Map<int, String> labelsComponents;
  final List<String> labelsIndicators;

  RadarChartInfo(
      {Key? key,
      required this.radarChart,
      required this.title,
      required this.data,
      required this.labelsComponents,
      required this.labelsIndicators,
      this.isGeneral = false})
      : super(key: key);

  @override
  State<RadarChartInfo> createState() => _RadarChartInfoState();
}

class _RadarChartInfoState extends State<RadarChartInfo> {
  late int indexMaxValor = widget.data.indexOf(widget.data.reduce((value, element) => value > element ? value : element));

  late int indexMinValor = widget.data.indexOf(widget.data.reduce((value, element) => value < element ? value : element));

  late String maxValor = "El valor maxímo es para el ${widget.isGeneral ? "componente" : "indicador"} ${indexMaxValor+1} \n ${widget.isGeneral ? "[${widget.labelsComponents[indexMaxValor]}]" : ""}";

  late String minValor = "El valor minímo es para el ${widget.isGeneral ? "componente" : "indicador"} ${indexMinValor+1} \n ${widget.isGeneral ? "[${widget.labelsComponents[indexMinValor]}]" : ""}";

  late String result ="", prompt;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prompt = 'Eres un experto evaluador de calidad. Tienes que responder de manera concisa y en un solo párrafo de máximo 5 líneas, no debes decir la misma información que te doy en la conclusión, solamente tu deducción. Como evaluador tienes estas siguientes notas que van de 1 a 5, siendo 5 la máxima calificación. Para la ${widget.title}, las notas están en una lista de entero ${widget.data.toString()} donde';

    if(!widget.isGeneral) {
      for (int i = 0; i < widget.data.length; i++) {
        prompt =
        "$prompt el indicador $i es '${widget.labelsIndicators[i]}' ${i == widget.data.length - 2 ? 'y' : (i == widget.data.length - 1 ? '' : ',')} ";
      }
    }else{
      for(int i = 0; i < widget.data.length; i++){
        prompt = "$prompt la nota $i corresponde al componente ${widget.labelsComponents[i]}  ${i == widget.data.length - 2 ? 'y' : (i == widget.data.length - 1 ? '' : ',')} ";
      }
    }
    prompt = "$prompt. Dime cuál es la fortaleza y debilidad para ${widget.isGeneral ? 'esta evaluación' : 'este componente'}";

    print(prompt);
    ChatCompletitionApi().sendPrompt(prompt).then((value){
      setState(() {
        result = ChatCompletionResponse.fromJson(jsonDecode(value.body)).choices.first.message.content;
        print(result);
      });
    });

    // result = prompt;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.radarChart,
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(widget.data.toString(), textAlign: TextAlign.start,),
                  // Text(minValor, textAlign: TextAlign.start,),
                  // Text(maxValor, textAlign: TextAlign.start,)
                  (result.isNotEmpty && result != null) ? SizedBox(width: 200, height: 200, child: ListView(children: [Text(result)],)) : Container(),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
