import 'package:flutter_test/flutter_test.dart';
import 'package:test_api/test_api.dart';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cryptocoins_app/repositories/favorites_repository.dart';
import 'package:cryptocoins_app/widgets/coin_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritas'),
      ),
      body: Container(
        color: Colors.indigo.withOpacity(0.05),
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(12),
        child:
            Consumer<FavoritesRepository>(builder: (context, favorites, child) {
          return favorites.favList.isEmpty
              ? ListTile(
                  leading: Icon(Icons.star_rounded),
                  title: Text('Ainda não há moedas favoritadas'),
                )
              : ListView.builder(
                  itemCount: favorites.favList.length,
                  itemBuilder: (_, index) {
                    return CoinCard(coin: favorites.favList[index]);
                  },
                );
        }),
      ),
    );
  }
}
