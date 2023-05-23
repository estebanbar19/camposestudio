import 'package:flutter/material.dart';

class RadarChartInfo extends StatelessWidget {
  final Widget radarChart;
  final String title;
  final List<int> data;
  final bool isGeneral;
  final List<String> labelsComponents;
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


  late int indexMaxValor = data.indexOf(data.reduce((value, element) => value > element ? value : element));
  late int indexMinValor = data.indexOf(data.reduce((value, element) => value < element ? value : element));
  late String maxValor = "El valor maxímo es para el ${isGeneral ? "componente" : "indicador"} ${indexMaxValor+1} \n ${isGeneral ? "[${labelsComponents[indexMaxValor]}]" : ""}";
  late String minValor = "El valor minímo es para el ${isGeneral ? "componente" : "indicador"} ${indexMinValor+1} \n ${isGeneral ? "[${labelsComponents[indexMinValor]}]" : ""}";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        radarChart,
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, textAlign: TextAlign.start,),
                  Text(data.toString(), textAlign: TextAlign.start,),
                  Text(minValor, textAlign: TextAlign.start,),
                  Text(maxValor, textAlign: TextAlign.start,)
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
