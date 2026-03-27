import 'package:flutter/foundation.dart';

class Configurador2DLogic extends ChangeNotifier {
  String _activeLine = 'trad';
  String _activeSize = '40x40';
  int _activeColorIndex = 0;
  
  double _grainFino = 35;
  double _grainMedio = 50;
  double _grainGrueso = 15;
  
  String _activeCvd = 'normal';
  
  // App Bar specific states
  bool _highContrast = false;
  bool _largeText = false;

  // Getters
  String get activeLine => _activeLine;
  String get activeSize => _activeSize;
  int get activeColorIndex => _activeColorIndex;
  
  double get grainFino => _grainFino;
  double get grainMedio => _grainMedio;
  double get grainGrueso => _grainGrueso;
  double get totalGrain => _grainFino + _grainMedio + _grainGrueso;
  
  String get activeCvd => _activeCvd;
  
  bool get highContrast => _highContrast;
  bool get largeText => _largeText;

  // Setters
  void setActiveLine(String val) {
    if (_activeLine != val) {
      _activeLine = val;
      notifyListeners();
    }
  }

  void setActiveSize(String val) {
    if (_activeSize != val) {
      _activeSize = val;
      notifyListeners();
    }
  }

  void setActiveColorIndex(int val) {
    if (_activeColorIndex != val) {
      _activeColorIndex = val;
      notifyListeners();
    }
  }

  void setGrains(double fino, double medio, double grueso) {
    _grainFino = fino;
    _grainMedio = medio;
    _grainGrueso = grueso;
    notifyListeners();
  }

  void updateGrainFino(double val) {
    _grainFino = val;
    notifyListeners();
  }

  void updateGrainMedio(double val) {
    _grainMedio = val;
    notifyListeners();
  }

  void updateGrainGrueso(double val) {
    _grainGrueso = val;
    notifyListeners();
  }

  void setActiveCvd(String val) {
    if (_activeCvd != val) {
      _activeCvd = val;
      notifyListeners();
    }
  }

  void toggleHighContrast() {
    _highContrast = !_highContrast;
    notifyListeners();
  }

  void toggleLargeText() {
    _largeText = !_largeText;
    notifyListeners();
  }

  // Deshacer / Rehacer (Simulación básica para el placeholder)
  void undo() {
    // Aquí implementaremos patrón Memento más adelante
  }

  void redo() {
    // Aquí implementaremos patrón Memento más adelante
  }
}
