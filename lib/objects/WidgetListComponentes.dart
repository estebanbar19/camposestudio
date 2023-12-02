import 'package:camposestudio/objects/Componente.dart';
import 'package:camposestudio/objects/WidgetDataComponente.dart';
import 'package:flutter/material.dart';

class WidgetListComponentes extends StatelessWidget {
  WidgetListComponentes({super.key});

  Componente componente = Componente.getInstance();
  @override
  Widget build(BuildContext context) {
    print(Componente.getInstance().cantComponentes);
    return Column(children: List.generate(componente.cantComponentes, (index) {
      return WidgetDataComponente(indice: index);
    }),);
  }
}
