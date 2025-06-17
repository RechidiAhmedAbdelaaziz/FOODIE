import 'package:app/core/constants/data.dart';
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
  final TextEditingController facebookLinkController;
  final TextEditingController instagramLinkController;
  final TextEditingController tiktokLinkController;
  final TextEditingController phoneController;

  RestaurantDTO(this._restaurant)
    : imageController = EditingController<ImageDTO>(
        _restaurant.image != null
            ? RemoteImageDto(_restaurant.image!)
            : null,
      ),
      nameController = TextEditingController(text: _restaurant.name),
      categoryController = EditingController<String>(
        _restaurant.category ?? AppData.restaurantTypes.first,
      ),
      descriptionController = TextEditingController(
        text: _restaurant.description,
      ),
      addressController = TextEditingController(
        text: _restaurant.address?.title,
      ),
      openingDaysController = ListEditingController<String>(
        _restaurant.openingDays,
      ),
      startTimeController = EditingController(
        _restaurant.startTime ?? '08:00',
      ),
      endTimeController = EditingController(
        _restaurant.endTime ?? '10:00',
      ),
      isPrePaidController = BooleanEditingController(
        _restaurant.isPrePaid ?? false,
      ),
      facebookLinkController = TextEditingController(
        text: _restaurant.facebookLink,
      ),
      instagramLinkController = TextEditingController(
        text: _restaurant.instagramLink,
      ),
      tiktokLinkController = TextEditingController(
        text: _restaurant.tiktokLink,
      ),
      phoneController = TextEditingController(
        text: _restaurant.phone,
      );

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

      if (_restaurant.address?.title != addressController.text)
        'address': {
          "title": addressController.text,
          // Fetching the coordinates from the short URL
          "coordinates":
              (await locator<GeoLocatorService>()
                      .getLangLatFromShortUrl(addressController.text))
                  .toArray(), // {latitude: ..., longitude: ...}
        },

      if (_restaurant.openingDays != openingDaysController.value)
        'openingDays': openingDaysController.value,

      if (_restaurant.startTime != startTimeController.value)
        'startTime': startTimeController.value,

      if (_restaurant.endTime != endTimeController.value)
        'endTime': endTimeController.value,

      if (_restaurant.isPrePaid != isPrePaidController.value)
        'isPrePaid': isPrePaidController.value,

      if (_restaurant.facebookLink != facebookLinkController.text)
        'facebookLink': facebookLinkController.text,

      if (_restaurant.instagramLink != instagramLinkController.text)
        'instagramLink': instagramLinkController.text,

      if (_restaurant.tiktokLink != tiktokLinkController.text)
        'tiktokLink': tiktokLinkController.text,

      if (_restaurant.phone != phoneController.text)
        'phone': phoneController.text,

      if (_restaurant.image != imageUrl) 'image': imageUrl,
    }.withoutNullsOrEmpty();
  }
}
