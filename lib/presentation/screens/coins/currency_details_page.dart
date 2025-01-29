import 'package:crypto_wallet/core/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/models/currency_model.dart';

class CurrencyDetailsCard extends ConsumerWidget {
  final CurrencyModel currency;

  const CurrencyDetailsCard({required this.currency, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade500)),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(CupertinoIcons.money_dollar_circle,
                    size: 24, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Price:',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                ),
                const Spacer(),
                Text(
                  '\$${currency.price}',
                  style:
                      CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(CupertinoIcons.arrow_2_squarepath,
                    size: 24, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  '24h Change:',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                ),
                const Spacer(),
                Text(
                  '${currency.priceChangePercentage}%',
                  style:
                      CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            fontSize: 16,
                            color: currency.priceChangePercentage >= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(CupertinoIcons.chart_bar,
                    size: 24, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  'Market Cap:',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                ),
                const Spacer(),
                Text(
                  formatMarketCap(currency.marketCap),
                  style:
                      CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            fontSize: 16,
                            color: Colors.blueGrey,
                          ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatMarketCap(double value) {
    if (value >= 1e9) {
      return '\$${(value / 1e9).toStringAsFixed(2)} B'; // Billion
    } else if (value >= 1e6) {
      return '\$${(value / 1e6).toStringAsFixed(2)} M'; // Million
    } else {
      return '\$${value.toStringAsFixed(2)}'; // Standard formatting
    }
  }
}

class Currency {
  final double price;
  final double priceChangePercentage;
  final double marketCap;

  Currency({
    required this.price,
    required this.priceChangePercentage,
    required this.marketCap,
  });
}
