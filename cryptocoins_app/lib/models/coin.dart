// * Import Libraries
import 'package:flutter/material.dart';

// * Creating a coin model
class Coin {
  // * Creating class attributes
  late String icon;
  late String coinName;
  late String initials; //sigla
  late double cost; //preço

  // * Creating constructor
  Coin({
    required this.icon,
    required this.coinName,
    required this.initials,
    required this.cost,
  });
}
