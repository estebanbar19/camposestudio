class IndicadoresInfo{
  late final String _nombreIndicador;
  late final int _valoracion;

  String get nombreIndicador => _nombreIndicador;


  IndicadoresInfo(this._nombreIndicador, this._valoracion);

  set nombreIndicador(String value) {
    _nombreIndicador = value;
  }

  int get valoracion => _valoracion;

  set valoracion(int value) {
    _valoracion = value;
  }

  @override
  String toString() {
    return 'IndicadoresInfo{_nombreIndicador: $_nombreIndicador, _valoracion: $_valoracion}';
  }
}