import 'package:cryptocoins_app/database/db.dart';
import 'package:cryptocoins_app/models/coin.dart';
import 'package:cryptocoins_app/models/historic.dart';
import 'package:cryptocoins_app/models/position.dart';
import 'package:cryptocoins_app/repositories/coin_repository.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class AccountRepository extends ChangeNotifier {
  late Database db;
  List<Position> _wallet = [];
  List<Historic> _historic = [];
  double _bank_balance = 0;

  get bank_balance => _bank_balance;
  List<Position> get wallet => _wallet;
  List<Historic> get historic => _historic;

  AccountRepository() {
    _initRepository();
  }

  _initRepository() async {
    await _getBankBalance();
    await _getWallet();
    await _getHistoric();
  }

  _getBankBalance() async {
    db = await DB.instanceDB.database;
    List account = await db.query('account', limit: 1);
    _bank_balance = account.first['bank_balance'];
    notifyListeners();
  }

  setBankBalance(double value) async {
    db = await DB.instanceDB.database;
    db.update('account', {
      'bank_balance': value,
    });
    _bank_balance = value;
    notifyListeners();
  }

  buy(Coin coin, double value) async {
    db = await DB.instanceDB.database;

    // Garante a consistência das informações, pois nenhuma transação é realizada se houverem erros.
    await db.transaction((txn) async {
      // Verifica se a moeda já foi comprada antes
      final positionCoin = await txn.query(
        'wallet',
        where: 'initials = ?',
        whereArgs: [coin.initials],
      );
      // Caso não tenha sido comprada adiciona
      if (positionCoin.isEmpty) {
        await txn.insert('wallet', {
          'initials': coin.initials,
          'coin': coin.coinName,
          'amount': (value / coin.cost).toString(),
        });
        // Caso já tenha sido comprada soma-se ao valor anterior
      } else {
        final actual = double.parse(positionCoin.first['amount'].toString());
        await txn.update(
          'wallet',
          {
            'amount': (actual + (value / coin.cost)).toString(),
          },
          where: 'initials = ?',
          whereArgs: [coin.initials],
        );
      }

      // Inserir Compra no histórico
      await txn.insert('purchaseHistory', {
        'initials': coin.initials,
        'coin': coin.coinName,
        'amount': (value / coin.cost).toString(),
        'value': value,
        'op_type': 'compra',
        'op_date': DateTime.now().millisecondsSinceEpoch,
      });

      // Atualizar saldo
      await txn.update(
        'account',
        {'bank_balance': bank_balance - value},
      );
    });

    await _initRepository();
    notifyListeners();
  }

  _getWallet() async {
    _wallet = [];
    List positions = await db.query('wallet');
    positions.forEach((position) {
      Coin coin = CoinRepository.table.firstWhere(
        (c) => c.initials == position['initials'],
      );
      _wallet.add(Position(
        coin: coin,
        amount: double.parse(position['amount']),
      ));
    });
    notifyListeners();
  }

  _getHistoric() async {
    _historic = [];
    List operations = await db.query('purchaseHistory');
    operations.forEach((operation) {
      Coin coin = CoinRepository.table.firstWhere(
        (c) => c.initials == operation['initials'],
      );
      _historic.add(Historic(
        opDate: DateTime.fromMillisecondsSinceEpoch(operation['op_date']),
        opType: operation['opType'],
        coin: coin,
        value: operation['value'],
        amount: double.parse(operation['amount']),
      ));
    });
    notifyListeners();
  }
}
