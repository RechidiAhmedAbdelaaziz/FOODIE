import 'package:app/core/flavors/flavors_screen.dart';
import 'package:app/features/home/ui/pages/client_home_screen.dart';
import 'package:app/features/home/ui/pages/owner_home_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends FlavorsScreen {
  const HomeScreen({super.key});

  @override
  Widget get ownerScreen => OwnerHomeScreen();

  @override
  Widget get clientScreen => ClientHomeScreen();
}
