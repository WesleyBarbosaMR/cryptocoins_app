// * Import Libraries
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cryptocoins_app/configs/app_settings.dart';
import 'package:cryptocoins_app/models/coin.dart';
import 'package:cryptocoins_app/pages/coin_details_page.dart';
import 'package:cryptocoins_app/repositories/favorites_repository.dart';
import 'package:cryptocoins_app/repositories/coin_repository.dart';

class CoinsPage extends StatefulWidget {
  CoinsPage({Key? key}) : super(key: key);

  @override
  State<CoinsPage> createState() => _CoinsPageState();
}

class _CoinsPageState extends State<CoinsPage> {
  // * Creating a table to store the coins
  final table = CoinRepository.table;
  // * Money number format
  late NumberFormat real;
  late Map<String, String> loc;
  /*
  NumberFormat real = NumberFormat.currency(
    locale: 'pt-BR',
    name: 'R\$',
  );
  */
  readNumberFormat() {
    // * Reading the provider
    loc = context.watch<AppSettings>().locale;
    // * Seting number format as per user preference
    real = NumberFormat.currency(
      locale: loc['locale'],
      name: loc['name'],
    );
  }

  changeLangButton() {
    final locale = loc['locale'] == 'pt_BR' ? 'en_US' : 'pt_BR';
    final name = loc['locale'] == 'pt_BR' ? '\$' : 'R\$';

    return PopupMenuButton(
      icon: Icon(Icons.language_rounded),
      itemBuilder: (context) => [
        PopupMenuItem(
            child: ListTile(
          leading: Icon(Icons.swap_vert_rounded),
          title: Text('Usar $locale'),
          onTap: () {
            context.read<AppSettings>().setLocale(locale, name);
            Navigator.pop(context);
          },
        ))
      ],
    );
  }

  // * Create the Favorites List
  late FavoritesRepository favorites;

  // * List dynamic selection
  List<Coin> selected = [];

  // * Make Appbar dynamic
  appBarDynamic() {
    // * Default Appbar
    if (selected.isEmpty) {
      return AppBar(
        title: Text('Cripto Moedas'),
        actions: [
          changeLangButton(),
        ],
      );
      // * Options Selected Appbar
    } else {
      return AppBar(
        // * Reset Appbar Button (Cancel selections)
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            setState(() {
              selected = [];
            });
          },
        ),
        // * Appbar dynamic style
        // ! Put styles in functions during code refactoring
        title: Text(
          '${selected.length} selecionadas',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigoAccent[100],
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black54),
      );
    }
  }

  showDetails(Coin coin) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoinDetailsPage(coin: coin),
      ),
    );
  }

  clearSelected() {
    setState(() {
      selected = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    // * Three ways to retrieve Favorites Repository
    // favorites = Provider.of<FavoritesRepository>(context);
    // favorites = context.watch<FavoritesRepository>();
    // favorites = context.read(); If you don't need screen reactivity
    // * Retreiving Favorites Repository
    favorites = context.watch<FavoritesRepository>();

    readNumberFormat();

    // * Coin listing page
    return Scaffold(
      appBar: appBarDynamic(),
      // * Coin list
      body: ListView.separated(
        // * Items to be listed
        itemBuilder: (BuildContext context, int coin) {
          return ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            leading: (selected.contains(table[coin]))
                ? CircleAvatar(
                    child: Icon(Icons.check_circle_outline_rounded),
                  )
                : SizedBox(
                    child:
                        Image.asset('/images/bitcoin.png'), //table[coin].icon),
                    width: 40,
                  ),
            title: Row(
              children: [
                Text(
                  table[coin].coinName,
                  // ! Put styles in functions during code refactoring
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (favorites.favList
                    .any((fav) => fav.initials == table[coin].initials))
                  Icon(
                    Icons.star_rounded,
                    color: Colors.amberAccent[700],
                    size: 20,
                  ),
              ],
            ),
            trailing: Text(
              real.format(table[coin].cost),
            ),
            selected: selected.contains(table[coin]),
            selectedTileColor: Colors.indigo[60],
            onLongPress: () {
              // * Updating page state
              setState(() {
                // * Conditional select
                (selected.contains(table[coin]))
                    ? selected.remove(table[coin])
                    : selected.add(table[coin]);
              });
            },
            onTap: () => showDetails(table[coin]),
          );
        },
        padding: EdgeInsets.all(16),
        // * List item divider
        separatorBuilder: (_, __) => Divider(),
        // * Counter
        itemCount: table.length,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      // ! Put styles in functions during code refactoring
      floatingActionButton: selected.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                favorites.saveAll(selected);
                clearSelected();
              },
              icon: Icon(Icons.star_rounded),
              label: Text(
                'Favoritar',
                style: TextStyle(
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
