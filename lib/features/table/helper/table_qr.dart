import 'dart:convert';

import 'package:app/features/table/data/model/table_model.dart';

abstract class TableQr {
  static Map<String, dynamic> generateQrData(TableModel table) => {
    'tableId': table.id,
  };

  static String getPath(String qrData) {
    // restaurants/:restaurantId?tableId=:tableId
    final decoded = jsonDecode(qrData) as Map<String, dynamic>;

    final tableId = decoded['tableId'] ?? '';

    return '/restaurants/menu/?tableId=$tableId';
  }
}
