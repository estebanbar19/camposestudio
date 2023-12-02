class Indicador{
  String _nombre;
  String _descripcion;
  double _nota;
  bool _selected = false;

  Indicador(this._nombre, this._descripcion, this._nota);

  double get nota => _nota;

  String get descripcion => _descripcion;

  void setNota(double nota){
    _nota = nota;
  }

  void setDescripcion(String descripcion){
    _descripcion = descripcion;
  }

  void setSelected(bool selected){
    _selected = selected;
  }

  bool get selected => _selected;


  String get nombre => _nombre;

  void setNombre(String nombre) {
    _nombre = nombre;
  }

  Map<String, dynamic> toJson() => {
    "nombre": nombre,
    "descripcion": descripcion,
    "nota": nota,
  };
}