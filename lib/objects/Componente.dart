import 'dart:convert';

import 'package:async/async.dart';
import 'package:camposestudio/objects/Indicador.dart';
import 'package:flutter/cupertino.dart';
import './IndicadoresInfo.dart';

class Componente{

  static Componente? _instance;

  int _cantComponentes = 0;
  List<Map<String, Indicador>> _indicadores = [];
  List<String> _componentes = [];

  Componente();

  static Componente getInstance() {
    _instance ??= Componente();
    return _instance!;
  }

  static Componente resetInstance(){
    _instance != null ? _instance = Componente() : _instance = getInstance();
    return _instance!;
  }

  List<String> get componentes => _componentes;

  void setNombresComponentes(List<String> nombresComponentes){
    _componentes = nombresComponentes;
  }

  int get cantComponentes => _cantComponentes;

  void setCantComponentes(int value) {
    _cantComponentes = value;
  }

  List<Map<String, Indicador>> get indicadores => _indicadores;

  void setIndicadores(List<Map<String, Indicador>> value) {
    _indicadores = value;
  }

  void setNotaIndicador(int indexComponente, String idIndicador, double nota){
    indicadores.elementAt(indexComponente)[idIndicador]!.setNota(nota);
  }

  void setDescripcionIndicador(int indexComponente, String idIndicador, String descripcion){
    indicadores.elementAt(indexComponente)[idIndicador]!.setDescripcion(descripcion);
  }

  void removeComponente(int indexComponente){
    indicadores.removeAt(indexComponente);
  }

  void removeIndicador(int indexComponente, String idIndicador){
    indicadores.elementAt(indexComponente).remove(idIndicador);
  }

  void createIndicadoresPorComponentes(){
    for(int i = 0; i < _cantComponentes; i++){
      _indicadores.add({});
      _componentes.add("");
    }
  }

  String getNombreComponente(int indexComponente){
    return _componentes.elementAt(indexComponente);
  }

  void setNombreComponente(int indexComponente, String nombre){
    _componentes[indexComponente] = nombre;
  }

  List<List<int>> getNotasPorComponentes(){
    List<List<int>> notas = [];
    _indicadores.forEach((element) {
      List<int> nota = [];
      element.values.forEach((element) {
        nota.add(element.nota.toInt());
      });
      notas.add(nota);
    });
    return notas;
  }

  void setNombreIndicador(int indexComponente, String idIndicador, String nombre){
    indicadores.elementAt(indexComponente)[idIndicador]!.setNombre(nombre);
  }

  String componenteToJson(){
    String aux = "[";
    for(int i = 0; i < _cantComponentes; i++){
      aux += '{';
      aux += '"nombre": "${_componentes.elementAt(i)}", "indicadores": ${jsonEncode(_indicadores.elementAt(i))}';
      aux = aux + ((i == _cantComponentes-1) ? '}' : '},');
    }
    aux += "]";
    return aux;
  }
}