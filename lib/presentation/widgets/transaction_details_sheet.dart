import 'package:flutter/cupertino.dart';

import '../../core/constants/text_widget.dart';
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
      title: const TextWidget(
        textKey: 'transaction_details',
      ),
      message: Column(
        children: [
          _buildDetailRow('hash', transaction.hash),
          _buildDetailRow('from', transaction.from),
          _buildDetailRow('to', transaction.to),
          _buildDetailRow(
              'amount', '${transaction.amount} ${transaction.network}'),
          _buildDetailRow('network', transaction.network),
          _buildDetailRow('fee',
              '${transaction.fee.toStringAsFixed(7)} ${transaction.network}'),
          _buildDetailRow('status', transaction.status.toString()),
          _buildDetailRow('date', transaction.date.toString()),
        ],
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const TextWidget(
            textKey: 'close',
          ),
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
          TextWidget(
            textKey: label,
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
