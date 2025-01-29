import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class CurrencyModel {
  final String currency;
  final String currencyName;
  final String coinIcon;
  final double price;
  final double priceChange;
  final double priceChangePercentage;
  final double? high24h;
  final double low24h;
  final List<double>? weeklyGraphData;
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
    this.weeklyGraphData,
    required this.volume,
    required this.volumeChangePercentage,
    required this.marketCap,
    required this.marketRank,
    required this.supply,
    required this.tradingActivity,
  });

  String formatInDollar(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }
}

class CurrencyState {
  final List<CurrencyModel> currencyList;
  final List<CurrencyModel> currencies;
  final bool isLoading;

  CurrencyState({
    required this.currencyList,
    required this.currencies,
    required this.isLoading,
  });

  // Factory constructor to create an initial state with loading true
  factory CurrencyState.initial() {
    return CurrencyState(
      currencyList: [],
      currencies: [],
      isLoading: true,
    );
  }

  // Copy method to create a new state with updated values
  CurrencyState copyWith({
    List<CurrencyModel>? currencyList,
    List<CurrencyModel>? currencies,
    bool? isLoading,
  }) {
    return CurrencyState(
      currencyList: currencyList ?? this.currencyList,
      currencies: currencies ?? this.currencies,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CurrencyNotifier extends StateNotifier<CurrencyState> {
  CurrencyNotifier() : super(CurrencyState.initial());

  Future<List<CurrencyModel>> getFilteredCurrencies() async {
    try {
      state = state.copyWith(isLoading: true); // Set loading to true
      final response = await http.get(Uri.parse(
          'https://cs-india.coinswitch.co/api/v2/external/csk_website/currencies'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data']['currencies'] as List;

        List<CurrencyModel> currencies = [];
        List<CurrencyModel> currencyList = [];

        for (var item in data) {
          final model = CurrencyModel(
            currency: item['currency'],
            currencyName: item['currency_name'],
            coinIcon: item['coin_icon'],
            price: double.parse(item['price'].replaceAll(',', '')),
            priceChange: double.parse(item['price_change'].replaceAll(',', '')),
            priceChangePercentage: double.parse(
                item['price_change_percentage'].replaceAll(',', '')),
            high24h: double.tryParse(item['high_24h'].replaceAll(',', '')) ?? 0.0,
            low24h: double.tryParse(item['low_24h'].replaceAll(',', '')) ?? 0.0,
            volume: double.parse(
                    item['volume'].replaceAll(',', '').replaceAll(' Cr', '')) *
                1e6,
            volumeChangePercentage: double.parse(
                item['volume_change_percentage'].replaceAll(',', '')),
            marketCap: double.parse(item['market_cap']
                    .replaceAll(',', '')
                    .replaceAll(' Cr', '')) *
                1e6,
            marketRank: item['market_rank'],
            supply: item['supply'],
            tradingActivity: item['trading_activity'],
            weeklyGraphData: item['weekly_graph_data'] != null
                ? List<double>.from(item['weekly_graph_data'])
                : null,
          );

          if (['eth', 'bnb', 'matic', 'sol', 'usdt']
              .contains(item['currency'])) {
            currencies.add(model);
          }

          currencyList.add(model);
        }

        state = state.copyWith(
          currencies: currencies,
          currencyList: currencyList,
          isLoading: false,
        );

        return currencies;
      } else {
        state = state.copyWith(
          currencies: [],
          currencyList: [],
          isLoading: false,
        );
        return [];
        // throw Exception('Failed to load currencies');
      }
    } catch (e, stack) {
      state = state.copyWith(isLoading: false);
      print("Error: $e, Stack: $stack");
      return [];
    }
  }
}

// Riverpod provider
final currencyProvider = StateNotifierProvider<CurrencyNotifier, CurrencyState>(
  (ref) => CurrencyNotifier(),
);
