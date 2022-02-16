import 'package:cryptocoins_app/models/coin.dart';

class Historic {
  DateTime opDate;
  String opType;
  Coin coin;
  double value;
  double amount;

  Historic({
    required this.opDate,
    required this.opType,
    required this.coin,
    required this.value,
    required this.amount,
  });
}
