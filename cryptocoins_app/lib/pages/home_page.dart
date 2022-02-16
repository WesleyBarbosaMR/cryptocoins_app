import 'package:flutter_test/flutter_test.dart';
import 'package:test_api/test_api.dart';
import 'package:http/http.dart';

import 'package:cryptocoins_app/pages/configs_page.dart';
import 'package:cryptocoins_app/pages/wallet_page.dart';
import 'package:flutter/material.dart';
import 'package:cryptocoins_app/pages/coins_page.dart';
import 'package:cryptocoins_app/pages/favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // * Dynamic Page Controller
  late int actPg = 0;
  late PageController pgController;

  @override
  void initState() {
    super.initState();
    pgController = PageController(initialPage: actPg);
  }

  // * Dynamic Actual Page Change
  setActPg(pg) {
    setState(() {
      actPg = pg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // * Page list for dynamic slide control
      body: PageView(
        controller: pgController,
        children: [
          CoinsPage(),
          FavoritesPage(),
          WalletPage(),
          ConfigsPage(),
        ],
        onPageChanged: setActPg,
      ),
      // * Page slider button
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          // * Bottom navigation Style
          backgroundColor: Colors.blueGrey[200],
          indicatorColor: Colors.blueGrey[100],
          labelTextStyle: MaterialStateProperty.all(const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          )),
        ),
        child: NavigationBar(
          // * Slider animation
          // * Changed to new bottomNavigationBar (as per to Flutter 2.6 version)
          // currentIndex: actPg,
          /* onTap: (pg) {
            pgController.animateToPage(
              pg,
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
            );
          },*/
          selectedIndex: actPg,
          onDestinationSelected: (pg) {
            pgController.animateToPage(
              pg,
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
            );
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.format_list_bulleted_outlined, size: 20),
              selectedIcon: Icon(
                Icons.format_list_bulleted_rounded,
                size: 30,
                color: Colors.indigo,
              ),
              label: 'Todas',
            ),
            NavigationDestination(
              icon: Icon(Icons.star_border_rounded, size: 20),
              selectedIcon: Icon(
                Icons.star_rounded,
                size: 30,
                color: Colors.indigo,
              ),
              label: 'Favoritas',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined, size: 20),
              selectedIcon: Icon(
                Icons.account_balance_wallet_rounded,
                size: 30,
                color: Colors.indigo,
              ),
              label: 'Carteira',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined, size: 20),
              selectedIcon: Icon(
                Icons.settings_rounded,
                size: 30,
                color: Colors.indigo,
              ),
              label: 'Configurações',
            ),
          ],
        ),
      ),
    );
  }
}
