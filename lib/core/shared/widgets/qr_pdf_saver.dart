// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';

import 'package:app/core/extensions/snackbar.extension.dart';
import 'package:app/core/themes/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pdf/widgets.dart' as pw;

class QrPdfSaver extends StatefulWidget {
  final Map<String, dynamic> data;
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
    final pdfBytes = await _generatePdf(jsonEncode(widget.data));

    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save your QR Code PDF',
      fileName: widget.fileName,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      bytes: pdfBytes,
    );

    if (result != null) {
      if (widget.onSaved != null) {
        widget.onSaved!(result);
      }

      if (!mounted) return;
      context.showSuccessSnackbar('PDF saved successfully');
    } else {
      if (!mounted) return;
      context.showErrorSnackbar('PDF saving canceled');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _savePdf(context),
      child: Icon(Symbols.qr_code, color: AppColors.green),
    );
  }
}
