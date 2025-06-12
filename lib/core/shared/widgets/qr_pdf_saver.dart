// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:app/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class QrPdfSaver extends StatefulWidget {
  final String data;
  final String fileName;
  final void Function(String path)? onSaved;

  const QrPdfSaver({
    super.key,
    required this.data,
    this.fileName = "qr_code.pdf",
    this.onSaved,
  });

  @override
  State<QrPdfSaver> createState() => _QrPdfSaverState();
}

class _QrPdfSaverState extends State<QrPdfSaver> {
  Future<Uint8List> _generatePdf(String data) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Center(
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.qrCode(),
            data: data,
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
    return pdf.save();
  }

  Future<void> _savePdf(BuildContext context) async {
    final pdfBytes = await _generatePdf(widget.data);
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/${widget.fileName}';
    final file = File(path);
    await file.writeAsBytes(pdfBytes);

    if (widget.onSaved != null) {
      widget.onSaved!(path);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('PDF saved to: $path')));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _savePdf(context),
      child: Icon(Symbols.qr_code, color: AppColors.green),
    );
  }
}
