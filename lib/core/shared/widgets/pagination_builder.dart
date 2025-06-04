import 'package:app/core/themes/colors.dart';
import 'package:flutter/material.dart';

class PaginationBuilder<T> extends StatefulWidget {
  final List<T> Function(BuildContext context) items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final bool Function(BuildContext context)? isLoading;

  final VoidCallback? onLoadMore;
  final Future<void> Function()? onRefresh;

  final String? emptyText;
  final Axis scrollDirection;
  final bool shrinkWrap;

  const PaginationBuilder({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.loadingBuilder,
    this.isLoading,
    this.onLoadMore,
    this.onRefresh,
    this.emptyText,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
  });

  @override
  State<PaginationBuilder<T>> createState() => _PaginationBuilderState<T>();
}

class _PaginationBuilderState<T> extends State<PaginationBuilder<T>> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      if (widget.onLoadMore != null && !(widget.isLoading?.call(context) ?? false)) {
        widget.onLoadMore!();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loading = widget.isLoading?.call(context) ?? false;
    final itemList = widget.items(context);

    if (loading && itemList.isEmpty) {
      return widget.loadingBuilder?.call(context) ??
          const Center(
            child: CircularProgressIndicator(
              color: AppColors.greenLight,
            ),
          );
    }

    if (itemList.isEmpty) {
      return Center(child: Text(widget.emptyText ?? 'No items found.'));
    }

    Widget listView = ListView.builder(
      controller: _scrollController,
      shrinkWrap: widget.shrinkWrap,
      scrollDirection: widget.scrollDirection,
      itemCount: itemList.length,
      itemBuilder: (context, index) => widget.itemBuilder(context, itemList[index]),
    );

    if (widget.onRefresh != null) {
      listView = RefreshIndicator(
        onRefresh: widget.onRefresh!,
        child: listView,
      );
    }

    return listView;
  }
}
