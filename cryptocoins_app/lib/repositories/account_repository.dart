import 'package:cryptocoins_app/database/db.dart';
import 'package:cryptocoins_app/models/position.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class AccountRepository extends ChangeNotifier {
  late Database db;
  List<Position> _wallet = [];
  double _bank_balance = 0;

  get bank_balance => _bank_balance;
  List<Position> get wallet => _wallet;

  AccountRepository() {
    _initRepository();
  }

  _initRepository() async {
    await _getBankBalance();
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
}
