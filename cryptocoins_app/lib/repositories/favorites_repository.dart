import 'dart:collection';
import 'package:cryptocoins_app/adapters/coin_hive_adapter.dart';
import 'package:flutter/material.dart';
import 'package:cryptocoins_app/models/coin.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class FavoritesRepository extends ChangeNotifier {
  List<Coin> _favList = [];

  late LazyBox box;

  FavoritesRepository() {
    _startRepository();
  }

  _startRepository() async {
    await _openBox();
    await _readFavorites();
  }

  _openBox() async {
    Hive.registerAdapter(CoinHiveAdapter());
    box = await Hive.openLazyBox<Coin>('favorite_coins');
  }

  _readFavorites() {
    box.keys.forEach((coin) async {
      Coin c = await box.get(coin);
      _favList.add(c);
      notifyListeners();
    });
  }

  UnmodifiableListView<Coin> get favList => UnmodifiableListView(_favList);

  saveAll(List<Coin> coins) {
    coins.forEach((coin) {
      if (!_favList.any((actual) => actual.initials == coin.initials)) {
        _favList.add(coin);
        box.put(coin.initials, coin);
      }
      /*if (!_favList.contains(coin)) {
        _favList.add(coin);
      } else {
        return null;
      }*/
    });
    notifyListeners();
  }

  removeFavCoin(Coin coin) {
    _favList.remove(coin);
    box.delete(coin.initials);
    notifyListeners();
  }
}
