import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../objects/CamposInfo.dart';
import '../widgets/Radar_chart.dart';
import '../widgets/Radar_chart_info.dart';

class GraphicScreen extends StatelessWidget {
  const GraphicScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GraphicScreenArguments? args = ModalRoute.of(context) != null ?
      (ModalRoute.of(context)!.settings.arguments != null ? ModalRoute.of(context)!.settings.arguments as GraphicScreenArguments : null) : null;

    if(args != null){print(args.toString());}
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: args != null ? ListView(children: [Column(children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: RadarChartInfo(radarChart: RadarChart(data: [args.promRadarChart], size: Size(400, 400)), title: "Evaluación general", data: args.promRadarChart, isGeneral: true, labelsComponents: args.labelsComponents, labelsIndicators: [],),
        ),
        ...List.generate(args.cantComponents, (index) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: RadarChartInfo(radarChart: RadarChart(data: [args.componentsRadarChart[index].valoraciones], size: Size(200,200),), title: "Evaluación componente ${args.labelsComponents[index]}", data: args.componentsRadarChart[index].valoraciones, labelsComponents: args.labelsComponents, labelsIndicators: args.componentsRadarChart[index].valoracionesLabels,),
        ))
      ],)],) : Container(),
    );
  }
}

class GraphicScreenArguments{
  final int cantComponents;
  final List<String> labelsComponents;
  final List<int> promRadarChart;
  final List<CamposInfo> componentsRadarChart;

  GraphicScreenArguments(this.cantComponents, this.promRadarChart, this.componentsRadarChart, this.labelsComponents);

  @override
  String toString() {
    return """
    {
      cantComponents: $cantComponents,\n
      promRadarChart: ${promRadarChart.toString()},\n
      labelsComponents: ${labelsComponents.toString()},\n
      componentsRadarChart ${componentsRadarChart.toString()},
    }
    """;
  }
}
