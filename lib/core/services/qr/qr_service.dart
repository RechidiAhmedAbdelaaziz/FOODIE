import 'dart:convert';
import 'dart:io';
import 'package:app/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

part 'qr_scanner.dart';

@lazySingleton
class QrService {
  /// Generate a QR code as a PDF and save it to a file.
  ///
  /// [data]: The string to encode in the QR code.
  /// [fileName]: The name of the PDF file (default: qr_code.pdf).
  ///
  /// Returns the full file path of the saved PDF.
  Future<String> generateAndSaveQrPdf({
    required Map<String, dynamic> data,
    required String fileName,
  }) async {
    final pdf = pw.Document();

    // Add a page with QR code
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Center(
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.qrCode(),
            data: jsonEncode(data),
            width: 200,
            height: 200,
          ),
        ),
      ),
    );

    // Save the PDF to a file
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$fileName';
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  /// Open a camera screen and return scanned QR code result
  Future<Map<String, dynamic>?> scanQrCode(
    BuildContext context,
  ) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const _QRScanScreen()),
    );

    if (result != null && result.isNotEmpty) {
      return jsonDecode(result);
    }

    return null;
  }
}
