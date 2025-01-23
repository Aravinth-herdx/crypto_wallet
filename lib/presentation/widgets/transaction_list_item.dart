import 'package:crypto_wallet/core/services/websocket/wallet_balance_state.dart';
import 'package:crypto_wallet/presentation/screens/home/models/transaction.dart';
import 'package:crypto_wallet/providers/accouns_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/transaction_history.dart';

class TransactionListItem extends ConsumerStatefulWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const TransactionListItem({
    Key? key,
    required this.transaction,
    required this.onTap,
  }) : super(key: key);

  @override
  ConsumerState<TransactionListItem> createState() =>
      _TransactionListItemState();
}

class _TransactionListItemState extends ConsumerState<TransactionListItem> {
  @override
  Widget build(BuildContext context) {
    final walletProvider = ref.watch(walletBalanceProvider);
    final account = ref.watch(accountProvider);
    return GestureDetector(
      onTap: widget.onTap,
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
              widget.transaction.to == account.selectedAccount?.address
                  ? CupertinoIcons.arrow_down_left
                  : CupertinoIcons.arrow_up_right,
              color: widget.transaction.to == account.selectedAccount?.address
                  ? CupertinoColors.activeGreen
                  : CupertinoColors.destructiveRed,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.transaction.to == account.selectedAccount?.address
                        ? 'Received ${widget.transaction.network}'
                        : 'Sent ${widget.transaction.network}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${widget.transaction.date.toString()}',
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
                  '${widget.transaction.amount} ${widget.transaction.network}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Fee: ${widget.transaction.fee.toStringAsFixed(7)} ${widget.transaction.network}',
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
