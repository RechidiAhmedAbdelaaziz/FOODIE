import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/map_extension.dart';
import 'package:app/core/services/geolocator/geo_locator_service.dart';
import 'package:app/core/shared/dto/filesdto/image_dto.dart';
import 'package:app/core/shared/dto/form_dto.dart';
import 'package:app/core/shared/editioncontollers/boolean_editigcontroller.dart';
import 'package:app/core/shared/editioncontollers/generic_editingcontroller.dart';
import 'package:app/core/shared/editioncontollers/list_generic_editingcontroller.dart';
import 'package:app/features/restaurant/data/model/restaurant_model.dart';
import 'package:flutter/widgets.dart';

class RestaurantDTO with AsyncFormDTO {
  final RestaurantModel _restaurant;

  final EditingController<ImageDTO> imageController;
  final TextEditingController nameController;
  final EditingController<String> categoryController;
  final TextEditingController descriptionController;
  final TextEditingController addressController;
  final ListEditingController<String> openingDaysController;
  final EditingController<String> startTimeController;
  final EditingController<String> endTimeController;
  final BooleanEditingController isPrePaidController;
  final EditingController<String> facebookLinkController;
  final EditingController<String> instagramLinkController;
  final EditingController<String> tiktokLinkController;
  final EditingController<String> phoneController;

  RestaurantDTO(this._restaurant)
    : imageController = EditingController<ImageDTO>(
        _restaurant.image != null
            ? RemoteImageDto(_restaurant.image!)
            : null,
      ),
      nameController = TextEditingController(text: _restaurant.name),
      categoryController = EditingController<String>(
        _restaurant.category,
      ),
      descriptionController = TextEditingController(
        text: _restaurant.description,
      ),
      addressController = TextEditingController(
        text: _restaurant.address?.link,
      ),
      openingDaysController = ListEditingController<String>(
        _restaurant.openingDays,
      ),
      startTimeController = EditingController<String>(
        _restaurant.startTime,
      ),
      endTimeController = EditingController<String>(
        _restaurant.endTime,
      ),
      isPrePaidController = BooleanEditingController(
        _restaurant.isPrePaid ?? false,
      ),
      facebookLinkController = EditingController<String>(
        _restaurant.facebookLink,
      ),
      instagramLinkController = EditingController<String>(
        _restaurant.instagramLink,
      ),
      tiktokLinkController = EditingController<String>(
        _restaurant.tiktokLink,
      ),
      phoneController = EditingController<String>(_restaurant.phone);

  @override
  void dispose() {
    imageController.dispose();
    nameController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    openingDaysController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    isPrePaidController.dispose();
    facebookLinkController.dispose();
    instagramLinkController.dispose();
    tiktokLinkController.dispose();
    phoneController.dispose();
  }

  @override
  Future<Map<String, dynamic>> toMap() async {
    final imageUrl = await imageController.value?.url;
    return {
      if (_restaurant.name != nameController.text)
        'name': nameController.text,

      if (_restaurant.category != categoryController.value)
        'category': categoryController.value,

      if (_restaurant.description != descriptionController.text)
        'description': descriptionController.text,

      if (_restaurant.address?.link != addressController.text) ...{
        'address': addressController.text,
        // Fetching the coordinates from the short URL
        ...(await locator<GeoLocatorService>().getLangLatFromShortUrl(
          addressController.text,
        )).toMap(), // {latitude: ..., longitude: ...}
      },

      if (_restaurant.openingDays != openingDaysController.value)
        'openingDays': openingDaysController.value,

      if (_restaurant.startTime != startTimeController.value)
        'startTime': startTimeController.value,

      if (_restaurant.endTime != endTimeController.value)
        'endTime': endTimeController.value,

      if (_restaurant.isPrePaid != isPrePaidController.value)
        'isPrePaid': isPrePaidController.value,

      if (_restaurant.facebookLink != facebookLinkController.value)
        'facebookLink': facebookLinkController.value,

      if (_restaurant.instagramLink != instagramLinkController.value)
        'instagramLink': instagramLinkController.value,

      if (_restaurant.tiktokLink != tiktokLinkController.value)
        'tiktokLink': tiktokLinkController.value,

      if (_restaurant.phone != phoneController.value)
        'phone': phoneController.value,

      if (_restaurant.image != imageUrl) 'image': imageUrl,
    }.withoutNullsOrEmpty();
  }
}
