import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DB {
  // * Constructor with private access
  DB._();

  // * DB instance creating
  static final DB instanceDB = DB._();

  // *SQLite instance
  static Database? _database;

  get database async {
    if (_database != null) {
      return _database;
    } else {
      return await _initDatabase();
    }
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'cryptocoins.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(Database db, int version) async {
    await db.execute(_account);
    await db.execute(_wallet);
    await db.execute(_purchaseHistory);
    await db.insert('account', {'bank_balance': 0});
  }

  String get _account => """
    CREATE TABLE account (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      bank_balance REAL
    )
  """;

  String get _wallet => """
    CREATE TABLE wallet (
      initials TEXT PRIMARY KEY,
      coin TEXT,
      amount TEXT
    )
  """;

  String get _purchaseHistory => """
    CREATE TABLE purchase_history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      op_date INT,
      op_type TEXT,
      coin TEXT,
      initials TEXT,
      value REAL,
      amount TEXT
    )
  """;
}
