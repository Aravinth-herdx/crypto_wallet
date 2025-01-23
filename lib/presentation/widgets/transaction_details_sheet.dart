import 'package:flutter/cupertino.dart';

import '../../core/models/transaction_history.dart';
import '../screens/home/models/transaction.dart';

class TransactionDetailsSheet extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailsSheet({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: const Text('Transaction Details'),
      message: Column(
        children: [
          _buildDetailRow('Hash', transaction.hash),
          _buildDetailRow('From', transaction.from),
          _buildDetailRow('To', transaction.to),
          _buildDetailRow(
              'Amount', '${transaction.amount} ${transaction.network}'),
          _buildDetailRow('Network', transaction.network),
          _buildDetailRow('Fee',
              '${transaction.fee.toStringAsFixed(7)} ${transaction.network}'),
          _buildDetailRow('Status', transaction.status.toString()),
          _buildDetailRow('Date', transaction.date.toString()),
        ],
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(
            width: 25,
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
