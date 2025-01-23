import 'package:flutter/cupertino.dart';

import '../../core/models/transaction_history.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionHistory transaction;
  final VoidCallback onTap;

  const TransactionListItem({
    Key? key,
    required this.transaction,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CupertinoColors.separator,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              transaction.type == TransactionType.receive
                  ? CupertinoIcons.arrow_down_left
                  : CupertinoIcons.arrow_up_right,
              color: transaction.type == TransactionType.receive
                  ? CupertinoColors.activeGreen
                  : CupertinoColors.destructiveRed,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.type == TransactionType.receive
                        ? 'Received ${transaction.token}'
                        : 'Sent ${transaction.token}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${transaction.timestamp.toString().split('.')[0]}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${transaction.amount} ${transaction.token}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Fee: ${transaction.fee} ${transaction.token}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.systemGrey,
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