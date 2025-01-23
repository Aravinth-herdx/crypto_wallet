import 'package:flutter/cupertino.dart';

class TokenList extends StatelessWidget {
  final List<Map<String, String>> tokens;

  const TokenList({
    Key? key,
    required this.tokens,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.systemGrey5,
        ),
      ),
      child: Column(
        children: tokens.map((token) => TokenListItem(token: token)).toList(),
      ),
    );
  }
}

class TokenListItem extends StatelessWidget {
  final Map<String, String> token;

  const TokenListItem({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.systemGrey5,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Token Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey5,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                token['symbol']?.substring(0, 1) ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Token Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  token['symbol'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${token['balance']} ${token['symbol']}',
                  style: const TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Token Value
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${token['value']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _calculateChange(),
                style: TextStyle(
                  color: _getChangeColor(context),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _calculateChange() {
    // In a real app, this would calculate the 24h change
    // For now, returning a dummy value
    return '+2.5%';
  }

  Color _getChangeColor(BuildContext context) {
    // This would normally check if the change is positive or negative
    // For now, returning green for demo
    return CupertinoColors.activeGreen;
  }
}