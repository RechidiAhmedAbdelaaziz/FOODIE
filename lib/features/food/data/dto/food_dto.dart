import 'package:app/core/shared/dto/filesdto/image_dto.dart';
import 'package:app/core/shared/dto/form_dto.dart';
import 'package:app/core/shared/editioncontollers/generic_editingcontroller.dart';
import 'package:app/core/shared/editioncontollers/list_generic_editingcontroller.dart';
import 'package:app/features/food/data/model/food_model.dart';
import 'package:flutter/widgets.dart';

class FoodAvailabilityDTO with FormDTO {
  final FoodModel _food;

  FoodAvailabilityDTO(this._food);

  @override
  Map<String, dynamic> toMap() {
    return {'isAvailable': !(_food.isAvailable ?? false)};
  }

  String get id => _food.id!;

  @override
  void dispose() {}
}

class FoodDTO with AsyncFormDTO {
  final FoodModel? _food;

  final EditingController<ImageDTO> imageController;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController categoryController;
  final ListEditingController<AddOnsDTO> addOnsController;

  FoodDTO([this._food])
    : imageController = EditingController<ImageDTO>(
        _food?.image != null ? RemoteImageDto(_food!.image!) : null,
      ),
      nameController = TextEditingController(text: _food?.name),
      descriptionController = TextEditingController(
        text: _food?.description,
      ),
      priceController = TextEditingController(
        text: _food?.price?.toString(),
      ),
      categoryController = TextEditingController(
        text: _food?.category,
      ),
      addOnsController = ListEditingController<AddOnsDTO>(
        _food?.addOns?.map((e) => AddOnsDTO(e)).toList(),
      );

  String get id => _food?.id ?? '';

  @override
  void dispose() {
    imageController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    categoryController.dispose();
    addOnsController.dispose();
  }

  @override
  Future<Map<String, dynamic>> toMap() async {
    final imageUrl = await imageController.value?.url;
    return {
      if (_food == null || _food.image != imageUrl) 'image': imageUrl,

      if (_food == null || _food.name != nameController.text)
        'name': nameController.text,

      if (_food == null ||
          _food.description != descriptionController.text)
        'description': descriptionController.text,

      if (_food == null ||
          _food.price?.toString() != priceController.text)
        'price': int.tryParse(priceController.text) ?? 0,

      if (_food == null || _food.category != categoryController.value)
        'category': categoryController.value,

      if (_food == null ||
          _food.addOns?.length != addOnsController.value.length ||
          addOnsController.value.any((e) => e.isModified))
        'addOns': addOnsController.value
            .map((e) => e.toMap())
            .toList(),
    };
  }
}

class AddOnsDTO with FormDTO {
  final AddOnsModel? _addOns;

  final TextEditingController nameController;
  final TextEditingController priceController;

  AddOnsDTO([this._addOns])
    : nameController = TextEditingController(text: _addOns?.name),
      priceController = TextEditingController(
        text: _addOns?.price?.toString() ?? '0',
      );

  bool get isModified =>
      _addOns == null ||
      _addOns.name != nameController.text ||
      _addOns.price.toString() != priceController.text;

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': nameController.text,
      'price': int.tryParse(priceController.text) ?? 0,
    };
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
  }
}
