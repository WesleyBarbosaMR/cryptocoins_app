// * Import Libraries
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cryptocoins_app/configs/app_settings.dart';
import 'package:cryptocoins_app/my_app.dart';
import 'package:cryptocoins_app/repositories/favorites_repository.dart';

// * Run App
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppSettings(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoritesRepository(),
        ),
      ],
      child: MyApp(),
    ),
  );
}
