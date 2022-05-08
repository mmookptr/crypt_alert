class Token {
  Token({
    required this.name,
    required this.symbol,
    required this.price,
    required this.marketCap,
    required this.dailyChange,
  });

  factory Token.fromJson(Map<String, dynamic> json, name, symbol) {
    return Token(
      name: name,
      symbol: symbol,
      price: json['usd'],
      marketCap: json['usd_market_cap'],
      dailyChange: json['usd_24h_change'],
    );
  }

  final String name;
  final String symbol;
  final num price;
  final num marketCap;
  final num dailyChange;
  bool hasActiveAlert = false;
}
