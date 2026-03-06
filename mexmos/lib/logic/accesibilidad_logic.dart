import 'package:flutter/material.dart';

class AccesibilidadLogic extends ChangeNotifier {
  String _modoDaltonismo = 'Normal';
  bool _altoContraste = false;
  double _escalaTexto = 1.0;

  String get modoDaltonismo => _modoDaltonismo;
  bool get altoContraste => _altoContraste;
  double get escalaTexto => _escalaTexto;

  void cambiarModo(String nuevoModo) {
    if (_modoDaltonismo != nuevoModo) {
      _modoDaltonismo = nuevoModo;
      notifyListeners();
    }
  }

  void toggleAltoContraste(bool valor) {
    if (_altoContraste != valor) {
      _altoContraste = valor;
      notifyListeners();
    }
  }

  void cambiarEscalaTexto(double nuevaEscala) {
    if (_escalaTexto != nuevaEscala) {
      _escalaTexto = nuevaEscala;
      notifyListeners();
    }
  }
}
