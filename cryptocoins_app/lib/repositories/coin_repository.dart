// * Import Libraries
import 'package:flutter/material.dart';
import 'package:cryptocoins_app/models/coin.dart';

// * Assigning coins to be listed in table format
class CoinRepository {
  static List<Coin> table = [
    Coin(
      icon: 'images/bitcoin.png',
      coinName: 'Bitcoin',
      initials: 'BTC',
      cost: 164603.00,
    ),
    Coin(
      icon: 'images/ethereum.png',
      coinName: 'Ethereum',
      initials: 'ETH',
      cost: 9716.00,
    ),
    Coin(
      icon: 'images/xrp.png',
      coinName: 'XRP',
      initials: 'XRP',
      cost: 3.34,
    ),
    Coin(
      icon: 'images/cardano.png',
      coinName: 'Cardano',
      initials: 'ADA',
      cost: 6.32,
    ),
    Coin(
      icon: 'images/usdcoin.png',
      coinName: 'USD Coin',
      initials: 'USDC',
      cost: 5.02,
    ),
    Coin(
      icon: 'images/litecoin.png',
      coinName: 'Litecoin',
      initials: 'LTC',
      cost: 669.93,
    ),
  ];
}
