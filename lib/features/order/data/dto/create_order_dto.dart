import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/map_extension.dart';
import 'package:app/core/services/geolocator/geo_locator_service.dart';
import 'package:app/core/shared/dto/form_dto.dart';
import 'package:app/core/shared/editioncontollers/generic_editingcontroller.dart';
import 'package:app/core/shared/editioncontollers/list_generic_editingcontroller.dart';
import 'package:app/core/shared/editioncontollers/number_editingcontroller.dart';
import 'package:app/features/food/data/model/food_model.dart';
import 'package:app/features/restaurant/data/model/restaurant_model.dart';
import 'package:app/features/table/data/model/table_model.dart';

class CreateOrderDTO with AsyncFormDTO {
  final menuController = ListEditingController<OrderMenuDTO>();
  final tableController = EditingController<TableModel>();
  final restaurantController = EditingController<RestaurantModel>();

  @override
  void dispose() {
    for (var menu in menuController.value) {
      menu.dispose();
    }
    menuController.dispose();
    tableController.dispose();
    restaurantController.dispose();
  }

  int get totalPrice {
    return menuController.value.fold<int>(
      0,
      (sum, order) => sum + order.price,
    );
  }

  @override
  Future<Map<String, dynamic>> toMap() async {
    return {
      'foods': menuController.value
          .map((menu) => menu.toMap())
          .toList(),

      ...tableController.value != null
          ? {'table': tableController.value?.id}
          : {
              "address": {
                "coordinates":
                    (await locator<GeoLocatorService>()
                            .getCurrentLocation())
                        .toArray(),
              },
            },

      'restaurant': restaurantController.value?.id,
    }.withoutNullsOrEmpty();
  }
}

class OrderMenuDTO with FormDTO {
  final foodController = EditingController<FoodModel>();
  final addOnsController = ListEditingController<AddOnsModel>();
  final quantityController = IntEditingcontroller(1);

  int get price {
    final foodPrice = foodController.value?.price ?? 0;
    final addOnsPrice = addOnsController.value.fold<int>(
      0,
      (sum, addOn) => sum + (addOn.price ?? 0),
    );
    return (foodPrice + addOnsPrice) * quantityController.value;
  }

  @override
  void dispose() {
    foodController.dispose();
    addOnsController.dispose();
    quantityController.dispose();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'food': foodController.value?.id,

      'selectedAddOns': addOnsController.value
          .map((addOn) => addOn.name)
          .toList(),

      'quantity': quantityController.value,
    }.withoutNullsOrEmpty();
  }
}
