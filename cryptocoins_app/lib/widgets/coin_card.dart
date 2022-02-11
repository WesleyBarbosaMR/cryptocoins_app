import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cryptocoins_app/models/coin.dart';
import 'package:cryptocoins_app/pages/coin_details_page.dart';
import 'package:cryptocoins_app/repositories/favorites_repository.dart';

class CoinCard extends StatefulWidget {
  Coin coin;

  CoinCard({Key? key, required this.coin}) : super(key: key);

  @override
  _CoinCardState createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {
  // * Money number format
  NumberFormat real = NumberFormat.currency(
    locale: 'pt-BR',
    name: 'R\$',
  );
  static Map<String, Color> colorCost = <String, Color>{
    'up': Colors.teal,
    'down': Colors.indigoAccent,
  };

  showDetails() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CoinDetailsPage(coin: widget.coin),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => showDetails(),
        child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
          child: Row(
            children: [
              Image.asset(
                widget.coin.icon,
                height: 40,
                width: 40,
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(left: 12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.coin.coinName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                      Text(widget.coin.initials,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black45,
                          )),
                    ]),
              )),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: colorCost['down']!.withOpacity(0.1),
                  border: Border.all(
                    color: colorCost['down']!.withOpacity(0.8),
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(real.format(widget.coin.cost),
                    style: TextStyle(
                      fontSize: 14,
                      color: colorCost['down'],
                      letterSpacing: -1,
                    )),
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert_rounded),
                itemBuilder: (context) => [
                  PopupMenuItem(
                      child: ListTile(
                    title: Text('Remover das Favoritas'),
                    onTap: () {
                      Navigator.pop(context);
                      Provider.of<FavoritesRepository>(context, listen: false)
                          .removeFavCoin(widget.coin);
                    },
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
