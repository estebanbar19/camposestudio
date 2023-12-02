import 'dart:math';

import 'package:collection/collection.dart';

class Maths{
  List<int> CalcAreaMax(List<int> numbers){

    List<List<int>> permutaciones = getPermutations(numbers);

    double areaMax = 0;
    List<int> numbersWithMaxArea = permutaciones.first;

    permutaciones.forEach((element) {
      double newArea = CalcArea(element);
      print("Element: $element Area value: $newArea");
      if(newArea > areaMax){
        areaMax = newArea;
        numbersWithMaxArea = element;
      }
    });

    return numbersWithMaxArea;
  }

  double CalcArea(List<int> values){
    double area = 0.0;
    int index = 0;
    values.forEach((element) {
      if(index < values.length-1){
        int base = element < values[index+1] ? element : values[index+1];
        int hipotenusa = element < values[index+1] ? element : values[index+1];
        double catOpuesto = sqrt(pow(hipotenusa, 2) - pow(base/2, 2));
        area += base * catOpuesto / 2;
      }else if(index == values.length-1){
        int base = element < values.first ? element : values.first;
        int hipotenusa = element < values.first ? element : values.first;
        double catOpuesto = sqrt(pow(hipotenusa, 2) - pow(base/2, 2));
        area += base * catOpuesto / 2;
      }
      index++;
    });

    return area;
  }

  List<List<int>> getPermutations(List<int> list) {
    List<List<int>> permutations = [];

    void _permute(List<int> list, int currentIndex) {
      if (currentIndex == list.length) {
        permutations.add(List.from(list));
        return;
      }

      for (int i = currentIndex; i < list.length; i++) {
        // Intercambia los elementos en los índices currentIndex e i
        _swap(list, currentIndex, i);
        // Realiza la permutación en el siguiente índice
        _permute(list, currentIndex + 1);
        // Vuelve a intercambiar los elementos para restablecer el orden original
        _swap(list, currentIndex, i);
      }
    }

    _permute(list, 0);
    return permutations;
  }

  void _swap(List<int> list, int index1, int index2) {
    int temp = list[index1];
    list[index1] = list[index2];
    list[index2] = temp;
  }
}