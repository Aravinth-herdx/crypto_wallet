import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyModel {
  final String currency;
  final String currencyName;
  final String coinIcon;
  final double price;
  final double priceChange;
  final double priceChangePercentage;
  final double high24h;
  final double low24h;
  // final double weeklyChangePercentGraphTrend;
  final double volume; // in dollar format
  final double volumeChangePercentage;
  final double marketCap; // in dollar format
  final String marketRank;
  final String supply;
  final String tradingActivity;

  CurrencyModel({
    required this.currency,
    required this.currencyName,
    required this.coinIcon,
    required this.price,
    required this.priceChange,
    required this.priceChangePercentage,
    required this.high24h,
    required this.low24h,
    // required this.weeklyChangePercentGraphTrend,
    required this.volume,
    required this.volumeChangePercentage,
    required this.marketCap,
    required this.marketRank,
    required this.supply,
    required this.tradingActivity,
  });

  // Function to format volume and market cap in dollar format
  String formatInDollar(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }
}

Future<List<CurrencyModel>> getFilteredCurrencies() async {
  final response = await http.get(Uri.parse('https://cs-india.coinswitch.co/api/v2/external/csk_website/currencies'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['data']['currencies'] as List;

    List<CurrencyModel> currencies = [];

    for (var item in data) {
      if (['eth', 'bnb', 'matic', 'sol', 'usdt'].contains(item['currency'])) {
        currencies.add(CurrencyModel(
          currency: item['currency'],
          currencyName: item['currency_name'],
          coinIcon: item['coin_icon'],
          price: double.parse(item['price'].replaceAll(',', '')), // Remove commas
          priceChange: double.parse(item['price_change'].replaceAll(',', '')),
          priceChangePercentage: double.parse(item['price_change_percentage'].replaceAll(',', '')),
          high24h: double.parse(item['high_24h'].replaceAll(',', '')),
          low24h: double.parse(item['low_24h'].replaceAll(',', '')),
          volume: double.parse(item['volume'].replaceAll(',', '').replaceAll(' Cr', '')) * 1e6, // Convert Cr to dollar
          volumeChangePercentage: double.parse(item['volume_change_percentage'].replaceAll(',', '')),
          marketCap: double.parse(item['market_cap'].replaceAll(',', '').replaceAll(' Cr', '')) * 1e6, // Convert Cr to dollar
          marketRank: item['market_rank'],
          supply: item['supply'],
          tradingActivity: item['trading_activity'],
        ));
      }
    }
    return currencies;
  } else {
    throw Exception('Failed to load currencies');
  }
}
