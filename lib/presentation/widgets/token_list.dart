import 'package:crypto_wallet/core/services/websocket/wallet_balance_state.dart';
import 'package:crypto_wallet/presentation/screens/home/models/currency_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TokenList extends ConsumerWidget {
  final List<CurrencyModel> tokens;

  const TokenList({
    Key? key,
    required this.tokens,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.systemGrey5,
        ),
      ),
      child: Skeletonizer(
        enabled: ref.watch(currencyProvider).isLoading,
        child: Column(
          children: tokens.map((token) => TokenListItem(token: token)).toList(),
        ),
      ),
    );
  }
}

class TokenListItem extends ConsumerWidget {
  final CurrencyModel token;

  const TokenListItem({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.systemGrey5,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            child: Image.network(token.coinIcon),
          ),
          const SizedBox(width: 12),
          // Token Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  token.currency.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      formatMarketCap(token.marketCap),
                      // '\$${token.marketCap}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      // _calculateChange(),
                      '${token.priceChangePercentage.toString()}%',
                      style: TextStyle(
                        color: _getChangeColor(
                            token.priceChangePercentage.toString()),
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          // Token Value
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                token.currency.toUpperCase() == 'ETH'
                    ? '\$${(ref.watch(walletBalanceProvider).ethPrice * double.parse(ref.watch(walletBalanceProvider).balance)).toStringAsFixed(2)}' // Replace 2200 with actual rate
                    : '\$0.00',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                token.currency.toUpperCase() == 'ETH'
                    ? ref.watch(walletBalanceProvider).balance.toString()
                    : '0.0',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
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

  Color _getChangeColor(String context) {
    // This would normally check if the change is positive or negative
    // For now, returning green for demo
    if (context.contains('-')) {
      return CupertinoColors.destructiveRed;
    }
    return CupertinoColors.activeGreen;
  }
}
