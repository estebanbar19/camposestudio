import 'dart:convert';

import 'package:camposestudio/objects/AppPalette.dart';
import 'package:camposestudio/objects/Maths/Maths.dart';
import 'package:camposestudio/objects/OpenAI/ChatCompletion/ChatCompletionApi.dart';
import 'package:camposestudio/objects/OpenAI/Models/ChatCompletionResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../objects/Componente.dart';
import '../objects/IndicadoresInfo.dart';
import 'dart:math' as math;
import '../widgets/Radar_chart.dart';
import '../widgets/Radar_chart_info.dart';

class GraphicScreen extends StatefulWidget {
  GraphicScreen({Key? key}) : super(key: key);

  @override
  State<GraphicScreen> createState() => _GraphicScreenState();
}

class _GraphicScreenState extends State<GraphicScreen> {
  bool _debug = true;

  final Map<int, List<int>> valoresIndicadoresPorComponente = {};

  final Map<int, List<String>> labelsIndicadoresPorComponentes = {};

  late GraphicScreenArguments args;
  late List<List<int>> mainData;
  late String mainTitle, mainResult ="";
  late List<List<List<int>>> listData;
  late List<String> mainLabels;
  late List<List<String>> labels;
  late List<String> titles, results;
  late Color mainColor;
  late List<Color> colors;
  late double mainSize, itemSize;
  late bool isVertical;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void handleChange(int index){
    setState(() {
      List<List<int>> aux = listData.elementAt(index);
      String auxTitle = titles.elementAt(index);
      String auxResult = results.elementAt(index);
      List<String> auxLabels = labels.elementAt(index);
      Color auxColor = colors.elementAt(index);
      listData.insert(index, mainData);
      titles.insert(index, mainTitle);
      results.insert(index, mainResult);
      labels.insert(index, mainLabels);
      colors.insert(index, mainColor);
      listData.removeAt(index+1);
      titles.removeAt(index+1);
      results.removeAt(index+1);
      labels.removeAt(index+1);
      colors.removeAt(index+1);
      mainData = aux;
      mainTitle = auxTitle;
      mainResult = auxResult;
      mainLabels = auxLabels;
      mainColor = auxColor;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    double displayHeight = MediaQuery.of(context).size.height;
    double displayWidth = MediaQuery.of(context).size.width;
    mainSize = displayHeight > displayWidth ? displayWidth*0.7 : displayHeight*0.4;
    itemSize = displayHeight > displayWidth ? displayWidth*0.12 : displayHeight*0.12;
    isVertical = displayHeight > displayWidth;

    args = ModalRoute.of(context)!.settings.arguments as GraphicScreenArguments;
    List<int> notasPorComponente = [];
    args.dataPerComponent.forEach((element) {
      double areaMax = Maths().CalcArea(element.map((e) => 5).toList());
      double areaComponente = Maths().CalcArea(Maths().CalcAreaMax(element));
      print("Area Componente: $areaComponente  Area Max: $areaMax  Nota asignada: ${(areaComponente/areaMax * 5).toInt()}");
      notasPorComponente.add((areaComponente/areaMax * 5).toInt());
    });
    mainData = [notasPorComponente];
    mainTitle = "General";
    listData = [];
    titles = args.titles;
    args.dataPerComponent.forEach((element) {
      listData.add([element]);
    });
    mainLabels = args.titles;
    labels = args.componente.indicadores.map((e) => e.values.map((e) => e.nombre).toList()).toList();
    mainColor = Color.fromARGB(255, math.Random().nextInt(255), math.Random().nextInt(255), math.Random().nextInt(255));
    colors = args.titles.map((e) => Color.fromARGB(255, math.Random().nextInt(255), math.Random().nextInt(255), math.Random().nextInt(255))).toList();
    results = [];

    void getResults() async {
      String messageGeneral = "Este es el resultado general por cada componente, para tu información son ${args.dataPerComponent.length} componentes. Así";
      print(args.titles);
      print(notasPorComponente);
      for(int i = 0; i < args.titles.length; i++){
        messageGeneral += "para el componente ${args.titles.elementAt(i)} se obtuvo por valoración ${notasPorComponente.elementAt(i)}";
      }
      messageGeneral += "entonces dime por favor, cuál es tu retroalimentación.";
      mainResult = ChatCompletionResponse.fromJson(jsonDecode(utf8.decode((await ChatCompletitionApi().sendPrompt(messageGeneral)).bodyBytes))).choices[0].message.content;
      for(int i = 0; i < args.titles.length; i++){
        String messageComponente = "En este componente ${args.titles.elementAt(i)}, se tuvieron las siguientes valoraciones basada en indicadores. Por esto, ";
        args.componente.indicadores.elementAt(i).forEach((key, value) {
          messageComponente += "para el indicador ${value.nombre} que tiene por descripción \"${value.descripcion}\" hay una valoración de ${value.nota}";
        });
        messageComponente += "entonces dime por favor, cuál es tu retroalimentación.";
        results.add(ChatCompletionResponse.fromJson(jsonDecode(utf8.decode((await ChatCompletitionApi().sendPrompt(messageComponente)).bodyBytes))).choices[0].message.content);
      }
      setState(() {});
    }
    getResults();

    super.didChangeDependencies();
  }

  List<Widget> getMainWidget(){
    return [Expanded(flex: 3, child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(mainTitle, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),),
        ),
        Center(child: RadarChart(data: mainData, labels: mainLabels, size: Size(mainSize, mainSize), color: mainColor,)),
      ],
    )),
      Expanded(flex: 1, child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
        child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppPalette.secondaryColor,), child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(children: [Text(mainResult == "" ? "Cargando..." : mainResult, style: TextStyle(fontWeight: FontWeight.w500),)]),
        ),),
      ),),];
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(children: [
        Expanded(
          flex: isVertical ? 3 : 2,
          child: isVertical ? Column(children: getMainWidget(),) : Row(crossAxisAlignment: CrossAxisAlignment.center, children: getMainWidget(),),
        ),
        Expanded(flex: 1, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: listData.length, itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            handleChange(index);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 15),
                  child: Text(titles.elementAt(index), style: TextStyle(fontWeight: FontWeight.w500),softWrap: true,),
                ),
                RadarChart(data: listData[index], labels: labels[index].map((e) => "").toList(), size: Size(itemSize, itemSize), color: colors[index],),
              ],
            ),
          ),
        )))
      ],),
    );
  }
}

class GraphicScreenArguments{
  List<List<int>> dataPerComponent;
  Componente componente;
  List<String> titles;
  GraphicScreenArguments(this.titles, this.componente, this.dataPerComponent);
}

