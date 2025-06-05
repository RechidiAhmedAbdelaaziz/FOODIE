import 'package:app/core/routing/app_route.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/features/food/data/model/food_model.dart';
import 'package:app/features/food/modules/foodform/logic/food_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UpdateFoodFormParams extends RouteParams {
  UpdateFoodFormParams(FoodModel food)
    : super(pathParams: {'id': food.id!});
}

class FoodFormScreen extends StatelessWidget {
  const FoodFormScreen({super.key});

  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.createFood.path,
      builder: (context, state) => BlocProvider(
        create: (context) => FoodFormCubit()..init(),
        child: const FoodFormScreen(),
      ),
    ),

    GoRoute(
      path: AppRoutes.updateFood.path,
      builder: (context, state) {
        final foodId = state.pathParameters['id']!;
        return BlocProvider(
          create: (context) => FoodFormCubit()..init(foodId),
          child: const FoodFormScreen(),
        );
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
