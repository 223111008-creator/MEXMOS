import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/models/capa_grano.dart';
import '../utils/calculador_tamano_grano.dart';

class PiedraRenderizable {
  final Path path;
  final CapaGrano capa;
  PiedraRenderizable(this.path, this.capa);
}

class Particula {
  final double x;
  final double y;
  final double radio;
  final CapaGrano capa;
  Particula(this.x, this.y, this.radio, this.capa);
}

class VoronoiEngine {
  final double width;
  final double height;
  final double offsetPasta;

  VoronoiEngine({
    required this.width,
    required this.height,
    this.offsetPasta = 1.0,
  });

  List<PiedraRenderizable> generarSistema(
      List<CapaGrano> capas, double escalaPixelesPorMm) {
    if (capas.isEmpty || width == 0 || height == 0) return [];
    List<Particula> particulas = _generarParticulas(capas, escalaPixelesPorMm);
    return _generarDiagramas(particulas);
  }

  List<Particula> _generarParticulas(
      List<CapaGrano> capas, double escalaPixelesPorMm) {
    List<Particula> particulas = [];
    // Usamos una semilla fija general para que el posicionamiento no parpadee en re-renders
    final random = Random(42);

    // 1. Ordenar de rocas grandes a polvos pequeños
    final capasOrdenadas = List<CapaGrano>.from(capas)
      ..sort((a, b) {
        double rA = CalculadorTamanoGrano.inferirRadioMilimetros(
            a.grano.abertura, a.grano.codigoTamano);
        double rB = CalculadorTamanoGrano.inferirRadioMilimetros(
            b.grano.abertura, b.grano.codigoTamano);
        return rB.compareTo(rA);
      });

    double maxRadius = 0;
    for (var c in capasOrdenadas) {
      double r = CalculadorTamanoGrano.inferirRadioMilimetros(
              c.grano.abertura, c.grano.codigoTamano) *
          escalaPixelesPorMm *
          1.5;
      if (r > maxRadius) maxRadius = r;
    }

    if (maxRadius == 0) return [];

    // Grid espacial para validación rápida de colisiones O(1)
    double cellSize = maxRadius * 2;
    int cols = (width / cellSize).ceil();
    Map<int, List<Particula>> grid = {};

    int getCell(double x, double y) {
      int c = (x / cellSize).floor();
      int r = (y / cellSize).floor();
      return r * cols + c;
    }

    // Hard Constraint: Radio de exclusión Poisson Disk
    bool checkCollision(double x, double y, double r) {
      int c = (x / cellSize).floor();
      int row = (y / cellSize).floor();

      for (int i = -2; i <= 2; i++) {
        for (int j = -2; j <= 2; j++) {
          int neighborCell = (row + i) * cols + (c + j);
          if (grid.containsKey(neighborCell)) {
            for (var p in grid[neighborCell]!) {
              double distSq = (pow(p.x - x, 2) + pow(p.y - y, 2)).toDouble();
              double minDist = p.radio + r + offsetPasta;
              if (distSq < minDist * minDist) {
                return true;
              }
            }
          }
        }
      }
      return false;
    }

    // 2. Colocar semillas
    for (var capa in capasOrdenadas) {
      double radioMm = CalculadorTamanoGrano.inferirRadioMilimetros(
          capa.grano.abertura, capa.grano.codigoTamano);
      double radioPxs = radioMm *
          escalaPixelesPorMm *
          1.5; // Escalar para compensar Insets y empaquetamiento

      double areaCanvas = width * height;
      double areaParticula = pi * radioPxs * radioPxs;
      if (areaParticula == 0) continue;

      // El área dicta la cantidad teórica, inflada para intentar compensar fallos por colisión
      int maxParticulas =
          ((areaCanvas * capa.densidad * 1.8) / areaParticula).toInt();
      if (maxParticulas > 15000) maxParticulas = 15000;

      int fallosMaximos = 800;
      int fallosConsecutivos = 0;
      int colocadas = 0;

      while (colocadas < maxParticulas && fallosConsecutivos < fallosMaximos) {
        double x = random.nextDouble() * width;
        double y = random.nextDouble() * height;

        // Jitter de tamaño estocástico
        double radioVariado = radioPxs * (0.8 + random.nextDouble() * 0.4);

        if (!checkCollision(x, y, radioVariado)) {
          var p = Particula(x, y, radioVariado, capa);
          particulas.add(p);
          grid.putIfAbsent(getCell(x, y), () => []).add(p);
          colocadas++;
          fallosConsecutivos = 0;
        } else {
          fallosConsecutivos++;
        }
      }
    }

    return particulas;
  }

  // Diagrama de Voronoi mediante Recorte de Semiplano (Sutherland-Hodgman) y Diagrama de Potencia (Power Diagram)
  List<PiedraRenderizable> _generarDiagramas(List<Particula> particulas) {
    List<PiedraRenderizable> piedras = [];
    final random = Random(42);

    double maxRadius = 0;
    for (var p in particulas) {
      if (p.radio > maxRadius) maxRadius = p.radio;
    }
    double searchRadius = maxRadius * 3;
    double cellSize = searchRadius;
    if (cellSize <= 0) return [];

    int cols = (width / cellSize).ceil();
    Map<int, List<Particula>> grid = {};

    int getCell(double x, double y) {
      int c = (x / cellSize).floor();
      int r = (y / cellSize).floor();
      return r * cols + c;
    }

    for (var p in particulas) {
      grid.putIfAbsent(getCell(p.x, p.y), () => []).add(p);
    }

    for (var p in particulas) {
      // Polígono Anisotrópico Inicial
      List<Offset> poly = _createInitialPolygon(p, random);

      // Evaluar interacción con otras celdas
      int c = (p.x / cellSize).floor();
      int row = (p.y / cellSize).floor();

      List<Particula> vecinos = [];
      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          int neighborCell = (row + i) * cols + (c + j);
          if (grid.containsKey(neighborCell)) {
            vecinos.addAll(grid[neighborCell]!.where((v) => v != p));
          }
        }
      }

      for (var vecino in vecinos) {
        double dx = vecino.x - p.x;
        double dy = vecino.y - p.y;
        double distSq = dx * dx + dy * dy;

        if (distSq > 0 && distSq < searchRadius * searchRadius) {
          double dist = sqrt(distSq);

          // Peso Asimétrico (Relajación): Partículas más pesadas desplazan el centro a su favor
          double peso = p.radio / (p.radio + vecino.radio);
          double cutDist = dist * peso - offsetPasta; // Buffer de vaciado

          if (cutDist < p.radio * 1.6) {
            double normX = dx / dist;
            double normY = dy / dist;

            Offset pointOnLine =
                Offset(p.x + normX * cutDist, p.y + normY * cutDist);
            Offset normal = Offset(normX,
                normY); // Apuntando hacia el vecino (el "exterior" se descarta)

            poly = _clipPolygon(poly, pointOnLine, normal);
          }
        }
      }

      if (poly.length >= 3) {
        Path path = Path();
        for (int i = 0; i < poly.length; i++) {
          // Jitter natural en vértices para mimetizar cantos rotos
          double jitterX = (random.nextDouble() - 0.5) * p.radio * 0.15;
          double jitterY = (random.nextDouble() - 0.5) * p.radio * 0.15;
          Offset v = Offset(poly[i].dx + jitterX, poly[i].dy + jitterY);

          if (i == 0) {
            path.moveTo(v.dx, v.dy);
          } else {
            path.lineTo(v.dx, v.dy);
          }
        }
        path.close();
        piedras.add(PiedraRenderizable(path, p.capa));
      }
    }

    return piedras;
  }

  List<Offset> _createInitialPolygon(Particula p, Random random) {
    List<Offset> poly = [];
    int sides = 5 + random.nextInt(4); // 5 a 8 lados
    double maxR = p.radio *
        1.5; // Espacio expandido disponible para crecer previo al clip

    // Anisotropía: Estirar polígonos de forma aleatoria para emular rotura direccional
    double stretchX = 0.8 + random.nextDouble() * 0.4;
    double stretchY = 0.8 + random.nextDouble() * 0.4;
    double rotation = random.nextDouble() * pi;

    for (int i = 0; i < sides; i++) {
      double angle = (2 * pi / sides) * i;
      double lx = (maxR * cos(angle)) * stretchX;
      double ly = (maxR * sin(angle)) * stretchY;

      // Aplicación de orientación asimétrica
      double rx = lx * cos(rotation) - ly * sin(rotation);
      double ry = lx * sin(rotation) + ly * cos(rotation);

      poly.add(Offset(p.x + rx, p.y + ry));
    }
    return poly;
  }

  List<Offset> _clipPolygon(
      List<Offset> subjectPoly, Offset pointOnLine, Offset normal) {
    if (subjectPoly.isEmpty) return [];

    List<Offset> outputList = [];
    Offset cp1 = subjectPoly.last;

    bool isInside(Offset pt) {
      return (pt.dx - pointOnLine.dx) * normal.dx +
              (pt.dy - pointOnLine.dy) * normal.dy <=
          0;
    }

    Offset computeIntersection(Offset pt1, Offset pt2) {
      double d1 = (pt1.dx - pointOnLine.dx) * normal.dx +
          (pt1.dy - pointOnLine.dy) * normal.dy;
      double d2 = (pt2.dx - pointOnLine.dx) * normal.dx +
          (pt2.dy - pointOnLine.dy) * normal.dy;
      double t = d1 / (d1 - d2);
      return Offset(
          pt1.dx + t * (pt2.dx - pt1.dx), pt1.dy + t * (pt2.dy - pt1.dy));
    }

    for (var cp2 in subjectPoly) {
      if (isInside(cp2)) {
        if (!isInside(cp1)) {
          outputList.add(computeIntersection(cp1, cp2));
        }
        outputList.add(cp2);
      } else if (isInside(cp1)) {
        outputList.add(computeIntersection(cp1, cp2));
      }
      cp1 = cp2;
    }

    return outputList;
  }
}
