import 'package:flutter_test/flutter_test.dart';
import 'package:test_api/test_api.dart';
import 'package:http/http.dart';

import 'package:cryptocoins_app/configs/app_settings.dart';
import 'package:cryptocoins_app/models/position.dart';
import 'package:cryptocoins_app/repositories/account_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  int index = 0;
  double walletAmount = 0;
  double walletBalance = 0;
  late NumberFormat real;
  late AccountRepository account;

  String chartLabel = '';
  double chartValue = 0;
  List<Position> wallet = [];

  @override
  Widget build(BuildContext context) {
    account = context.watch<AccountRepository>();
    final loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
    walletBalance = account.bank_balance;

    setWalletAmount();

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 48, bottom: 8),
              child: Text('Valor na Carteira',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
            ),
            Text(real.format(walletAmount),
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.5,
                )),
            loadChart(),
          ],
        ),
      ),
    );
  }

  setWalletAmount() {
    final walletList = account.wallet;
    setState(() {
      walletAmount = account.bank_balance;
      for (var position in walletList) {
        walletAmount += position.coin.cost * position.amount;
      }
    });
  }

  loadWallet() {
    setDataChart(index);
    wallet = account.wallet;
    final listSize = wallet.length + 1;

    return List.generate(listSize, (i) {
      final isTouched = i == index;
      final isBalance = i == listSize - 1;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = isTouched ? Colors.tealAccent : Colors.tealAccent[400];

      double percent = 0;
      if (!isBalance) {
        percent = (wallet[i].coin.cost * wallet[i].amount) / walletAmount;
      } else {
        percent = (account.bank_balance > 0)
            ? account.bank_balance / walletAmount
            : 0;
      }
      percent *= 100;

      return PieChartSectionData(
          color: color,
          value: percent,
          title: '${percent.toStringAsFixed(0)}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ));
    });
  }

  setDataChart(int index) {
    // * If the user clicks outside the chart, there will be no reaction.
    if (index < 0) return;

    if (index == wallet.length) {
      chartLabel = 'Saldo';
      chartValue = account.bank_balance;
    } else {
      chartLabel = wallet[index].coin.coinName;
      chartValue = wallet[index].coin.cost * wallet[index].amount;
    }
  }

  loadChart() {
    return (account.bank_balance <= 0)
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(PieChartData(
                    sectionsSpace: 5,
                    centerSpaceRadius: 110,
                    sections: loadWallet(),
                    pieTouchData: PieTouchData(
                      /*pieTouchData: PieTouchData(touchCallback:
                          (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });*/
                      touchCallback: (FlTouchEvent touch, pieTouchResponse) =>
                          setState(() {
                        if (!touch.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          index = -1;
                          return;
                        }
                        index = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                        setDataChart(index);
                      }),
                    ))),
              ),
              Column(
                children: [
                  Text(chartLabel,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.teal,
                      )),
                  Text(real.format(chartValue),
                      style: TextStyle(
                        fontSize: 28,
                      )),
                ],
              )
            ],
          );
  }
}
