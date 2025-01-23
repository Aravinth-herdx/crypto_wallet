import 'package:flutter/cupertino.dart';

import '../models/token.dart';

class TokenList extends StatelessWidget {
  const TokenList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Token> tokens = [
      Token(
        symbol: 'ETH',
        name: 'Ethereum',
        balance: '2.5',
        value: '4,500.00',
        change: '+2.5%',
        icon: '🌐',
      ),
      Token(
        symbol: 'BNB',
        name: 'Binance Coin',
        balance: '10.0',
        value: '3,000.00',
        change: '-1.2%',
        icon: '💎',
      ),
      Token(
        symbol: 'MATIC',
        name: 'Polygon',
        balance: '1000.0',
        value: '1,200.00',
        change: '+5.7%',
        icon: '⚡',
      ),
      Token(
        symbol: 'SOL',
        name: 'Solana',
        balance: '50.0',
        value: '5,000.00',
        change: '-0.8%',
        icon: '☀️',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Tokens',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...tokens.map((token) => TokenListItem(token: token)).toList(),
      ],
    );
  }
}

class TokenListItem extends StatelessWidget {
  final Token token;

  const TokenListItem({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        // Navigate to token details
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CupertinoColors.systemGrey5,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                token.icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    token.symbol,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    token.name,
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${token.value}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${token.balance} ${token.symbol}',
                  style: const TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}