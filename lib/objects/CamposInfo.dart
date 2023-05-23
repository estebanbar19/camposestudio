class CamposInfo{
  int _cantValoraciones;
  List<String> _valoracionesLabels;
  List<int> _valoraciones;

  CamposInfo(this._cantValoraciones, this._valoracionesLabels, this._valoraciones);

  List<int> get valoraciones => _valoraciones;

  set valoraciones(List<int> value) {
    _valoraciones = value;
  }

  List<String> get valoracionesLabels => _valoracionesLabels;

  set valoracionesLabels(List<String> labels){
    _valoracionesLabels = labels;
  }

  int get cantValoraciones => _cantValoraciones;

  set cantValoraciones(int value) {
    _cantValoraciones = value;
  }

  void increment(){
    _cantValoraciones++;
  }

  @override
  String toString() {
    return """{Cantidad de valoraciones: $cantValoraciones,
        \n Labels de las valoraciones: ${valoracionesLabels.toString()},
        \n Valoraciones: ${valoraciones.toString()}}""";
  }
}