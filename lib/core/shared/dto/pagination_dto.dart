import 'package:app/core/extensions/map_extension.dart';
import 'package:app/core/shared/dto/form_dto.dart';
import 'package:app/core/shared/editioncontollers/number_editingcontroller.dart';
import 'package:flutter/material.dart';

class PaginationDto with FormDto {
  final IntEditingcontroller pageController;
  final IntEditingcontroller limitController;
  final TextEditingController keywordController;
  final TextEditingController fieldsController;
  final TextEditingController sortController;

  PaginationDto({
    int page = 1,
    int limit = 10,
    String? keyword,
    String? fields,
    String? sort,
  }) : keywordController = TextEditingController(text: keyword),
       fieldsController = TextEditingController(text: fields),
       sortController = TextEditingController(text: sort),
       pageController = IntEditingcontroller(page),
       limitController = IntEditingcontroller(limit);

  @override
  void dispose() {
    pageController.dispose();
    limitController.dispose();
    keywordController.dispose();
    fieldsController.dispose();
    sortController.dispose();
  }

  @override
  Map<String, dynamic> toMap() => {
    'page': pageController.value,

    'limit': limitController.value,

    if (keywordController.text.isNotEmpty)
      'keyword': keywordController.text,

    if (fieldsController.text.isNotEmpty)
      'fields': fieldsController.text,

    if (sortController.text.isNotEmpty) 'sort': sortController.text,
  }.withoutNullsOrEmpty();
}
