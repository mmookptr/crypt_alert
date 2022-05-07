import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/token.dart';

class TokenRepository {
  final tokenInfos = [
    {
      "symbol": "BTC",
      "name": "Bitcoin",
      "id": "bitcoin",
    },
    {
      "symbol": "ETH",
      "name": "Ethereum",
      "id": "ethereum",
    },
    {
      "symbol": "ADA",
      "name": "Cardano",
      "id": "cardano",
    },
    {
      "symbol": "SAND",
      "name": "Sandbox",
      "id": "the-sandbox",
    },
    {
      "symbol": "KUB",
      "name": "Bitkub Coin",
      "id": "bitkub-coin",
    },
  ];

  Future<List<Token>> getTokens() async {
    final response = await http.get(
      Uri.parse(
          'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin%2Cethereum%2Ccardano%2Cthe-sandbox%2Cbitkub-coin&vs_currencies=usd&include_market_cap=true&include_24hr_vol=true&include_24hr_change=true'),
      headers: {'accept': 'application/json'},
    );

    final responseBody = jsonDecode(response.body);

    return tokenInfos.map((e) {
      final name = e["name"];
      final symbol = e["symbol"];
      final json = responseBody[e["id"]];

      return Token.fromJson(json, name, symbol);
    }).toList();
  }
}
