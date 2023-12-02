import 'dart:math' as math;
import 'package:camposestudio/flutter_radar_chart.dart';
import 'package:flutter/material.dart';

class RadarChart extends StatefulWidget {
  List<List<int>> data;
  Size size;
  List<String> labels;
  Color color;
  RadarChart({Key? key, required this.labels, required this.data, required this.size, required this.color}) : super(key: key);

  @override
  State<RadarChart> createState() => _RadarChartState();
}

class _RadarChartState extends State<RadarChart> {

  late int maxValue = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    addMaxArea();
  }

  void addMaxArea(){
    widget.data = [...widget.data, List.generate(widget.data.first.length, (index) => maxValue)];

    widget.data.sort((a, b) {
      int sumA = 0;
      int sumB = 0;

      for (var element in a) {sumA += element;}
      for (var element in b) {sumB += element;}

      return sumA > sumB ? -1 : (sumA == sumB ? 0 : 1);
    },);
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    addMaxArea();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [RadarChartBackground(size: widget.size,), ...List.generate(widget.data.length, (index) => RadarChartPolygon(size: widget.size, data: widget.data[index], labels: widget.labels, maxValue: maxValue, color: (index == 0) ? Colors.grey : widget.color))],
    );
  }
}

class RadarChartPolygon extends StatefulWidget {
  Size size;
  List<int> data;
  int maxValue;
  Color color;
  List<String> labels;
  RadarChartPolygon({Key? key, required this.size, required this.labels, required this.data, required this.maxValue, required this.color}) : super(key: key);

  @override
  State<RadarChartPolygon> createState() => _RadarChartPolygonState();
}

class _RadarChartPolygonState extends State<RadarChartPolygon> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RadarChartPainter(data: widget.data, maxValue: 5, labels: widget.labels, color: widget.color),
      size: widget.size,
    );
  }
}


class RadarChartBackground extends StatefulWidget {
  Size size;

  RadarChartBackground({Key? key,required this.size}) : super(key: key);

  @override
  State<RadarChartBackground> createState() => _RadarChartBackgroundState();
}

class _RadarChartBackgroundState extends State<RadarChartBackground> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RadarChartPainter(isBackground: true),
      size: widget.size,
    );
  }
}

class RadarChartPainter extends CustomPainter {
  bool isBackground;
  List<int>? data;
  int? maxValue;
  List<String>? labels;
  Color? color;
  RadarChartPainter({this.isBackground = false, this.labels, this.data, this.maxValue, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    
    var path = Path();
    final centerX = size.width / 2.0;
    final centerY = size.height / 2.0;
    final centerOffset = Offset(centerX, centerY);
    var radius = math.min(centerX, centerY);

    //PAINTS
    var outlinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    var ticksPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    if(isBackground){
      path.addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: radius,
      ));

      int decrement = (radius/5).round();

      for(int i = radius.toInt(); i > 0; i-=decrement){
        canvas.drawPath(Path()..addOval(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: i*1.0)), ticksPaint);
      }

      canvas.drawPath(path, outlinePaint);
    }else{

      Color colorGraph = color!;

      var graphPaint = Paint()
        ..color = colorGraph.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      var graphOutlinePaint = Paint()
        ..color = colorGraph
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..isAntiAlias = true;

      if(maxValue! > 0){
        var scale = radius / maxValue!;
        var scaledPoint = scale * data![0];
        var angle = (2 * math.pi) / data!.length;

        //PAINTING AXIS
        data!.asMap().forEach((index, value) {

          var xAngle = math.cos(angle * index - math.pi / 2);
          var yAngle = math.sin(angle * index - math.pi / 2);

          var featureOffset =
          Offset(centerX + radius * xAngle, centerY + radius * yAngle);

          canvas.drawLine(centerOffset, featureOffset, ticksPaint);

          var featureLabelFontHeight = const TextStyle(color: Colors.black, fontSize: 16).fontSize;
          var labelYOffset = yAngle < 0 ? -featureLabelFontHeight! : 0;
          var labelXOffset = xAngle > 0 ? featureOffset.dx : 0.0;

          TextPainter(
            text: TextSpan(text: "${labels![index]}", style: TextStyle(color: Colors.black, fontSize: 16)),
            textAlign: xAngle < 0 ? TextAlign.right : TextAlign.left,
            textDirection: TextDirection.ltr,
          )
            ..layout(minWidth: featureOffset.dx)
            ..paint(canvas, Offset(labelXOffset, featureOffset.dy + labelYOffset));
        });

        //PAINTING POLYGON
        path.moveTo(centerX, centerY - scaledPoint);
        data!.asMap().forEach((index, point) {
          if (index == 0) return;

          var xAngle = math.cos(angle * index - math.pi / 2);
          var yAngle = math.sin(angle * index - math.pi / 2);
          var scaledPoint = scale * point;

          path.lineTo(
              centerX + scaledPoint * xAngle, centerY + scaledPoint * yAngle);
        });
        path.close();
        canvas.drawPath(path, graphPaint);
        canvas.drawPath(path, graphOutlinePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}
