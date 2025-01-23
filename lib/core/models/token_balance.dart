class TokenBalance {
  final String symbol;
  final String network;
  final double balance;
  final double price;
  final double value;

  TokenBalance({
    required this.symbol,
    required this.network,
    required this.balance,
    required this.price,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'network': network,
    'balance': balance,
    'price': price,
    'value': value,
  };

  factory TokenBalance.fromJson(Map<String, dynamic> json) {
    return TokenBalance(
      symbol: json['symbol'],
      network: json['network'],
      balance: json['balance'],
      price: json['price'],
      value: json['value'],
    );
  }
}