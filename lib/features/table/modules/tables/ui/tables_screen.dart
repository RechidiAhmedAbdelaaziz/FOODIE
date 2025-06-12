// ignore_for_file: use_build_context_synchronously

import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/popup_extension.dart';
import 'package:app/core/extensions/snackbar.extension.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/services/qr/qr_service.dart';
import 'package:app/core/shared/widgets/pagination_builder.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/features/table/data/model/table_model.dart';
import 'package:app/features/table/helper/table_qr.dart';
import 'package:app/features/table/modules/tableform/ui/table_form_view.dart';
import 'package:app/features/table/modules/tables/logic/tables_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class TablesScreen extends StatelessWidget {
  const TablesScreen({super.key});

  static RouteBase get route => GoRoute(
    path: AppRoutes.tables.path,
    builder: (context, state) {
      return BlocProvider(
        create: (context) => TablesCubit()..fetchTables(),
        child: const TablesScreen(),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.back,
          icon: const Icon(Symbols.arrow_back),
        ),
        title: Text('Tables'.tr(context)),
      ),
      body: PaginationBuilder(
        items: (ctx) => ctx.watch<TablesCubit>().state.tables,
        itemBuilder: _buildTableCard,
        isLoading: (ctx) =>
            ctx.select((TablesCubit cubit) => cubit.state.isLoading),
        onLoadMore: () => context.read<TablesCubit>().fetchTables(),
        onRefresh: () async =>
            context.read<TablesCubit>().clearAndFetch(),
        emptyText: 'No tables found',
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => context.dialogWith<TableModel>(
          child: TableFormView(),
          onResult: context.read<TablesCubit>().addTable,
        ),
        backgroundColor: AppColors.green,
        child: const Icon(Symbols.add, color: Colors.white),
      ),
    );
  }

  // table card container contains only table name
  Widget _buildTableCard(BuildContext context, TableModel table) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        spacing: 8.w,
        children: [
          Icon(Symbols.table_bar, color: Colors.white, size: 24.sp),

          Expanded(
            child: Text(
              table.name ?? 'Unnamed Table',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Row(
            spacing: 16.w,
            children: [
              InkWell(
                onTap: () {
                  locator<QrService>()
                      .generateAndSaveQrPdf(
                        data: TableQr.generateQrData(table),
                        fileName: 'table_${table.name}.pdf',
                      )
                      .then((path) {
                        context.showSuccessSnackbar(
                          '${'Successfully generated QR code'.tr(context)}\n$path',
                        );
                      });
                },
                child: Icon(Symbols.qr_code, color: AppColors.green),
              ),
              InkWell(
                onTap: () => context.dialogWith<TableModel>(
                  child: TableFormView(table: table),
                  onResult: context.read<TablesCubit>().updateTable,
                ),
                child: Icon(Symbols.edit, color: Colors.white),
              ),
              InkWell(
                onTap: () => context.alertDialog(
                  title: 'Delete Table'.tr(context),
                  content:
                      'Are you sure you want to delete this table?'
                          .tr(context),
                  onConfirm: () =>
                      context.read<TablesCubit>().removeTable(table),
                ),
                child: Icon(Symbols.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
