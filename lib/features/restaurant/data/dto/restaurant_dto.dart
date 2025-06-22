import 'package:app/core/constants/data.dart';
import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/map_extension.dart';
import 'package:app/core/services/geolocator/geo_locator_service.dart';
import 'package:app/core/shared/dto/filesdto/image_dto.dart';
import 'package:app/core/shared/dto/form_dto.dart';
import 'package:app/core/shared/dto/working_time_dto.dart';
import 'package:app/core/shared/editioncontollers/boolean_editigcontroller.dart';
import 'package:app/core/shared/editioncontollers/generic_editingcontroller.dart';
import 'package:app/core/shared/editioncontollers/list_generic_editingcontroller.dart';
import 'package:app/features/restaurant/data/model/restaurant_model.dart';
import 'package:flutter/widgets.dart';

class RestaurantDTO with AsyncFormDTO {
  final RestaurantModel _restaurant;

  final EditingController<ImageDTO> imageController;
  final TextEditingController nameController;
  final ListEditingController<String> categoryController;
  final TextEditingController descriptionController;
  final TextEditingController addressController;

  final ListEditingController<WorkingTimeDto> workingTimesController;

  final BooleanEditingController isPrePaidController;
  final BooleanEditingController hasDeliveryController;

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
      categoryController = ListEditingController(
        _restaurant.categories ?? [AppData.restaurantTypes.first],
      ),
      descriptionController = TextEditingController(
        text: _restaurant.description,
      ),
      addressController = TextEditingController(
        text: _restaurant.address?.title,
      ),
      workingTimesController = ListEditingController<WorkingTimeDto>(
        _restaurant.workingTimes
                ?.map((e) => WorkingTimeDto(e))
                .toList() ??
            [],
      ),

      isPrePaidController = BooleanEditingController(
        _restaurant.isPrePaid ?? false,
      ),
      hasDeliveryController = BooleanEditingController(
        _restaurant.hasDelivery ?? false,
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
    isPrePaidController.dispose();
    facebookLinkController.dispose();
    instagramLinkController.dispose();
    tiktokLinkController.dispose();
    phoneController.dispose();
    workingTimesController.dispose();
    hasDeliveryController.dispose();
  }

  @override
  Future<Map<String, dynamic>> toMap() async {
    final imageUrl = await imageController.value?.url;
    return {
      if (_restaurant.name != nameController.text)
        'name': nameController.text,

      if (_restaurant.categories != categoryController.value)
        'categories': categoryController.value,

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

      if (workingTimesController.value.any((e) => e.isModified))
        'workingTimes': workingTimesController.value
            .map((e) => e.toMap())
            .toList(),

      if (_restaurant.isPrePaid != isPrePaidController.value)
        'isPrePaid': isPrePaidController.value,

      if (_restaurant.hasDelivery != hasDeliveryController.value)
        'hasDelivery': hasDeliveryController.value,

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
