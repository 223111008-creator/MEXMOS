import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

import '../models/ficha_tecnica.dart';

class PdfGeneratorService {
  /// Genera un documento PDF estructurado a partir de una [FichaTecnica].
  Future<Uint8List> generarFichaTecnicaPDF(FichaTecnica ficha) async {
    final pdf = pw.Document();

    final fontRegular = pw.Font.helvetica();
    final fontBold = pw.Font.helveticaBold();

    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');
    final currencyFormatter =
        NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return [
            // Encabezado
            _buildHeader(ficha, fontBold, fontRegular, dateFormatter),
            pw.SizedBox(height: 20),

            // Parámetros de Producción
            _buildParametrosBox(ficha, fontBold, fontRegular),
            pw.SizedBox(height: 20),

            // Tabla de Insumos (BOM)
            pw.Text('Lista de Materiales (BOM)',
                style: pw.TextStyle(font: fontBold, fontSize: 16)),
            pw.SizedBox(height: 10),
            _buildInsumosTable(ficha, fontBold, fontRegular, currencyFormatter),
            pw.SizedBox(height: 20),

            // Instrucciones
            pw.Text('Instrucciones de Mezcla:',
                style: pw.TextStyle(font: fontBold, fontSize: 14)),
            pw.SizedBox(height: 5),
            pw.Text(ficha.instruccionesMezcla,
                style: pw.TextStyle(font: fontRegular, fontSize: 12)),
            pw.SizedBox(height: 30),

            // Totales
            _buildTotales(ficha, fontBold, currencyFormatter),
          ];
        },
        footer: (context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 20),
            child: pw.Text(
              'Página ${context.pageNumber} de ${context.pagesCount}',
              style: pw.TextStyle(
                  color: PdfColors.grey, fontSize: 10, font: fontRegular),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(
      FichaTecnica ficha, pw.Font bold, pw.Font regular, DateFormat df) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('MEXANA DE MOSAICOS S.A DE C.V',
                style: pw.TextStyle(
                    font: bold, fontSize: 18, color: PdfColors.blue900)),
            pw.Text('Ficha Técnica de Producción',
                style: pw.TextStyle(
                    font: regular, fontSize: 14, color: PdfColors.grey700)),
            pw.SizedBox(height: 10),
            pw.Text('Diseño: ${ficha.configuracion.recetaBase.nombre}',
                style: pw.TextStyle(font: bold, fontSize: 14)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('Folio: #${ficha.id.substring(0, 8)}',
                style: pw.TextStyle(font: bold, fontSize: 12)),
            pw.Text('Fecha: ${df.format(ficha.fechaGeneracion)}',
                style: pw.TextStyle(font: regular, fontSize: 10)),
          ],
        )
      ],
    );
  }

  pw.Widget _buildParametrosBox(
      FichaTecnica ficha, pw.Font bold, pw.Font regular) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildDatoPar(bold, regular, 'Área a Cubrir',
              '${ficha.configuracion.metrosCuadrados.toStringAsFixed(2)} m²'),
          _buildDatoPar(bold, regular, 'Rendimiento Base',
              '${ficha.configuracion.recetaBase.rendimientoKgPorM2.toStringAsFixed(2)} kg/m²'),
          _buildDatoPar(bold, regular, 'Masa Bruta Esperada',
              '${ficha.totalKg.toStringAsFixed(2)} kg'),
        ],
      ),
    );
  }

  pw.Widget _buildDatoPar(
      pw.Font bold, pw.Font regular, String etiqueta, String valor) {
    return pw.Column(
      children: [
        pw.Text(etiqueta,
            style: pw.TextStyle(
                font: regular, fontSize: 10, color: PdfColors.grey700)),
        pw.SizedBox(height: 4),
        pw.Text(valor,
            style: pw.TextStyle(
                font: bold, fontSize: 14, color: PdfColors.blue800)),
      ],
    );
  }

  pw.Widget _buildInsumosTable(
      FichaTecnica ficha, pw.Font bold, pw.Font regular, NumberFormat cf) {
    final tableHeaders = [
      'Código',
      'Descripción',
      'Tipo',
      'Cantidad',
      'Costo Est.'
    ];

    final data = ficha.insumosRequeridos.map((linea) {
      return [
        linea.insumo.id,
        linea.insumo.nombre,
        linea.insumo.tipo.name.toUpperCase(),
        '${linea.cantidadTotalKg.toStringAsFixed(2)} ${linea.insumo.unidadMedida}',
        cf.format(linea.cantidadTotalKg * linea.insumo.costoPorKg),
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: tableHeaders,
      data: data,
      headerStyle:
          pw.TextStyle(font: bold, color: PdfColors.white, fontSize: 11),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
      cellStyle: pw.TextStyle(font: regular, fontSize: 10),
      cellAlignment: pw.Alignment.centerLeft,
      rowDecoration: const pw.BoxDecoration(
          border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5))),
      columnWidths: {
        0: const pw.FlexColumnWidth(1.5),
        1: const pw.FlexColumnWidth(3),
        2: const pw.FlexColumnWidth(1.5),
        3: const pw.FlexColumnWidth(1.5),
        4: const pw.FlexColumnWidth(1.5),
      },
    );
  }

  pw.Widget _buildTotales(FichaTecnica ficha, pw.Font bold, NumberFormat cf) {
    final totalCosto = ficha.insumosRequeridos.fold(
        0.0,
        (sum, linea) =>
            sum + (linea.cantidadTotalKg * linea.insumo.costoPorKg));

    return pw.Container(
        alignment: pw.Alignment.centerRight,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('Costo Directo Materiales',
                style: pw.TextStyle(font: bold, fontSize: 14)),
            pw.SizedBox(height: 5),
            pw.Text(cf.format(totalCosto),
                style: pw.TextStyle(
                    font: bold, fontSize: 24, color: PdfColors.green800)),
          ],
        ));
  }
}
