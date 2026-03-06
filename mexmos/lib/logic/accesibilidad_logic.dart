import 'package:flutter/material.dart';

class AccesibilidadLogic extends ChangeNotifier {
  String _modoDaltonismo = 'Normal';

  String get modoDaltonismo => _modoDaltonismo;

  void cambiarModo(String nuevoModo) {
    if (_modoDaltonismo != nuevoModo) {
      _modoDaltonismo = nuevoModo;
      notifyListeners();
    }
  }
}
