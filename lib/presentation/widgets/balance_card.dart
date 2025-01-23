import 'package:flutter/cupertino.dart';

class BalanceCard extends StatelessWidget {
  final String totalBalance;
  final String currency;

  const BalanceCard({
    Key? key,
    required this.totalBalance,
    required this.currency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(color: CupertinoColors.white),
          ),
          const SizedBox(height: 8),
          Text(
            '\$$totalBalance $currency',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.white,
            ),
          ),
        ],
      ),
    );
  }
}