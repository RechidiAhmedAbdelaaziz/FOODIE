import 'dart:async';

import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class AppSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const AppSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  Timer? _debounce;
  final Duration _debounceDuration = const Duration(seconds: 2);

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(_debounceDuration, () {
      widget.onChanged(query);
    });
  }

  @override
  void initState() {
    widget.controller.addListener(
      () => _onSearchChanged(widget.controller.text),
    );

    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      hintText: 'Search'.tr(context),
      prefixIcon: Symbols.search,
      // textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
    );
  }
}
