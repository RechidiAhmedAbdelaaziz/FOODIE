import 'dart:async';

import 'package:app/features/order/data/model/order_model.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:injectable/injectable.dart';

@singleton
class OrderPrinter {
  final _flutterThermalPrinterPlugin = FlutterThermalPrinter.instance;

  List<Printer> printers = [];

  StreamSubscription<List<Printer>>? _devicesStreamSubscription;

  @postConstruct
  Future<void> startScan() async {
    
    _devicesStreamSubscription?.cancel();

    await _flutterThermalPrinterPlugin.getPrinters(
      connectionTypes: [ConnectionType.USB, ConnectionType.BLE],
    );

    _devicesStreamSubscription = _flutterThermalPrinterPlugin
        .devicesStream
        .listen((List<Printer> event) {
          printers = event;
          printers.removeWhere(
            (element) => element.name == null || element.name == '',
          );
        });
  }


  // prints the order details to the thermal printer
  // print only list of foods with their quantities and add-ons
  void printOrder(OrderModel model) async {
    if (printers.isEmpty) await startScan();

    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    bytes += generator.text(
      'Client Name: ${model.clientName ?? 'N/A'}',
      styles: PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += generator.text(
      'Table: ${model.table?.name ?? 'N/A'}',
      styles: PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += generator.feed(2); // add two lines of feed

    for (final food in model.mergedFoods) {
      final addOns = food.selectedAddOns?.isNotEmpty == true
          ? ' (${food.selectedAddOns!.join(', ')})'
          : '';
      final foodName = food.food?.name ?? 'Unknown Food';
      final quantity = food.quantity ?? 1;
      bytes += generator.text(
        '$quantity x $foodName$addOns ',
        styles: PosStyles(align: PosAlign.left),
      );
    }

    bytes += generator.cut();

    final printer = printers.first;
    await _flutterThermalPrinterPlugin.printData(printer, bytes);
  }
}
