import 'package:cryptocoins_app/models/coin.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CoinHiveAdapter extends TypeAdapter<Coin> {
  @override
  final typeId = 0;

  @override
  Coin read(BinaryReader reader) {
    return Coin(
      icon: reader.readString(),
      coinName: reader.readString(),
      initials: reader.readString(),
      cost: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Coin objCoin) {
    writer.writeString(objCoin.icon);
    writer.writeString(objCoin.coinName);
    writer.writeString(objCoin.initials);
    writer.writeDouble(objCoin.cost);
  }
}
