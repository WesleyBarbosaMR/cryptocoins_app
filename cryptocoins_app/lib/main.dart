// * Import Libraries
import 'package:cryptocoins_app/configs/hive_config.dart';
import 'package:cryptocoins_app/repositories/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cryptocoins_app/configs/app_settings.dart';
import 'package:cryptocoins_app/my_app.dart';
import 'package:cryptocoins_app/repositories/favorites_repository.dart';

// * Run App
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AccountRepository(),
        ),
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
