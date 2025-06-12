import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/snackbar.extension.dart';
import 'package:app/features/table/data/model/table_model.dart';
import 'package:app/features/table/data/repository/table_repository.dart';
import 'package:flutter/material.dart';

class TableWidget extends StatefulWidget {
  final String tableId;
  const TableWidget(this.tableId, {super.key});

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  late final TableModel _table;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    // Initialize the table model here or fetch it from a provider or service.
    locator<TableRepo>().getTableById(widget.tableId).then((result) {
      result.when(
        success: (table) {
          setState(() {
            _table = table;
            _isLoaded = true;
          });
        },
        error: (error) => context.showErrorSnackbar(error.message),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return !_isLoaded ? SizedBox.shrink() : Column();
  }
}
