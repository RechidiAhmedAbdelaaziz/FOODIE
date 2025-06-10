import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/services/filepicker/file_picker_service.dart';
import 'package:app/core/shared/dto/filesdto/file_dto.dart';
import 'package:app/core/shared/editioncontollers/generic_editingcontroller.dart';
import 'package:app/core/shared/widgets/form_field_props.dart';
import 'package:app/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class AppFileField<T extends FileDTO> extends StatelessWidget {
  final EditingController<T> controller;
  final FilePickerService<T> picker;

  final bool isRequired;

  final double height;
  final double width;
  final double borderRadius;

  final String? lable;
  final String errorText;

  const AppFileField({
    super.key,
    required this.controller,
    required this.height,
    required this.width,
    required this.borderRadius,
    required this.errorText,
    required this.picker,
    this.lable,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: (_) =>
          isRequired && controller.value == null ? errorText : null,
      builder: (state) {
        return Column(
          spacing: 8.h,
          children: [
            if (lable != null)
              FormFieldLabel(lable!, isRequired: isRequired),

            ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, file, child) {
                return SizedBox(
                  height: height + 24.h,
                  width: width + 24.w,
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      file != null
                          ? file.build(
                              width: width,
                              height: height,
                              borderRadius: borderRadius,
                            )
                          : Container(
                              height: height,
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(
                                  borderRadius,
                                ),
                              ),
                            ),

                      Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: InkWell(
                          onTap: () async {
                            final file = await picker.pickFile();
                            if (file != null) {
                              controller.setValue(file);
                            }
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 20.r,
                            child: Icon(
                              Symbols.upload,
                              color: AppColors.black,
                              size: 24.r,
                            ),
                          ),
                        ),
                      ),

                      if (file != null && !isRequired)
                        Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: IconButton(
                            onPressed: controller.clear,
                            icon: const Icon(
                              Symbols.close,
                              color: Colors.white,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: const CircleBorder(),
                              padding: EdgeInsets.all(4.r),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),

            if (state.hasError)
              FormFieldError(state.errorText!.tr(context)),
          ],
        );
      },
    );
  }
}
