// * Import Libraries
import 'package:flutter/material.dart';
import 'package:cryptocoins_app/pages/home_page.dart';
import 'package:cryptocoins_app/pages/coins_page.dart';

// * App Init
class MyApp extends StatelessWidget {
  // * Constructor
  const MyApp({Key? key}) : super(key: key);

  // * Renders the widgets on the screen
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coinsbase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomePage(),
    );
  }
}
