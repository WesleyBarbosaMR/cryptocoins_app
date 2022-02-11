import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:cryptocoins_app/models/coin.dart';
import 'package:flutter/cupertino.dart';

class FavoritesRepository extends ChangeNotifier {
  List<Coin> _favList = [];

  UnmodifiableListView<Coin> get favList => UnmodifiableListView(_favList);

  saveAll(List<Coin> coins) {
    coins.forEach((coin) {
      if (!_favList.contains(coin)) {
        _favList.add(coin);
      } else {
        return null;
      }
    });
    notifyListeners();
  }

  removeFavCoin(Coin coin) {
    _favList.remove(coin);
    notifyListeners();
  }
}
