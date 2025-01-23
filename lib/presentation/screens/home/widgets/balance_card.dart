import 'package:flutter/cupertino.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            CupertinoColors.systemBlue,
            CupertinoColors.systemIndigo,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Total Balance',
            style: TextStyle(
              color: CupertinoColors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '\$13,700.00',
            style: TextStyle(
              color: CupertinoColors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TokenChange(
                direction: 'up',
                percentage: '2.5',
                timeFrame: '24h',
              ),
              TokenChange(
                direction: 'down',
                percentage: '0.8',
                timeFrame: '7d',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TokenChange extends StatelessWidget {
  final String direction;
  final String percentage;
  final String timeFrame;

  const TokenChange({
    Key? key,
    required this.direction,
    required this.percentage,
    required this.timeFrame,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            direction == 'up'
                ? CupertinoIcons.arrow_up_right
                : CupertinoIcons.arrow_down_right,
            color: CupertinoColors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '$percentage% ($timeFrame)',
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}