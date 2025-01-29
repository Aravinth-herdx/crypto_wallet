import 'package:crypto_wallet/core/services/websocket/wallet_balance_state.dart';
import 'package:crypto_wallet/presentation/screens/home/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/text_widget.dart';
import '../widgets/transaction_details_sheet.dart';
import '../widgets/transaction_list_item.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen> {
  final int _transactionsPerPage = 10;
  int _currentPage = 1;

  List<Transaction> get _paginatedTransactions {
    final transactions = ref.watch(walletBalanceProvider).transaction;
    final startIndex = (_currentPage - 1) * _transactionsPerPage;
    final endIndex = startIndex + _transactionsPerPage;
    return transactions.sublist(
      startIndex,
      endIndex > transactions.length ? transactions.length : endIndex,
    );
  }

  int get _totalPages => (ref.watch(walletBalanceProvider).transaction.length /
          _transactionsPerPage)
      .ceil();

  bool get _canGoNext => _currentPage < _totalPages;

  bool get _canGoPrevious => _currentPage > 1;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: TextWidget(
          textKey: 'transaction_history',
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ref.watch(walletBalanceProvider).transaction.isEmpty
                  ? const Center(
                      child: TextWidget(
                        textKey: 'no_history',
                      ),
                    )
                  : ListView.builder(
                      itemCount: _paginatedTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = _paginatedTransactions[index];
                        return TransactionListItem(
                          transaction: transaction,
                          onTap: () => _showTransactionDetails(transaction),
                        );
                      },
                    ),
            ),
            if (ref.watch(walletBalanceProvider).transaction.isNotEmpty)
              _buildPaginationControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            onPressed: _canGoPrevious
                ? () {
                    setState(() => _currentPage--);
                  }
                : null,
            child: TextWidget(
              textKey: 'previous',
              style: TextStyle(
                color: _canGoPrevious
                    ? CupertinoColors.activeBlue
                    : CupertinoColors.systemGrey,
              ),
            ),
          ),

          // Pagination numbers with ellipsis logic
          if (_totalPages > 0) ..._buildPageButtons(),

          // Next button
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            onPressed: _canGoNext
                ? () {
                    setState(() => _currentPage++);
                  }
                : null,
            child: TextWidget(
              textKey: 'next',
              style: TextStyle(
                color: _canGoNext
                    ? CupertinoColors.activeBlue
                    : CupertinoColors.systemGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageButtons() {
    List<Widget> buttons = [];

    void addPageButton(int page) {
      bool isSelected = page == _currentPage;
      buttons.add(
        GestureDetector(
          onTap: () {
            setState(() => _currentPage = page);
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$page',
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? CupertinoColors.activeBlue
                    : CupertinoColors.systemGrey,
              ),
            ),
          ),
        ),
      );
    }

    if (_totalPages <= 5) {
      // Show all pages if 5 or fewer pages exist
      for (int i = 1; i <= _totalPages; i++) {
        addPageButton(i);
      }
    } else {
      // Always show first page
      addPageButton(1);

      if (_currentPage > 3) {
        buttons.add(const Text("..."));
      }

      // Show middle pages dynamically
      int start = (_currentPage - 1).clamp(2, _totalPages - 2);
      int end = (_currentPage + 1).clamp(2, _totalPages - 1);

      for (int i = start; i <= end; i++) {
        addPageButton(i);
      }

      if (_currentPage < _totalPages - 2) {
        buttons.add(const Text("..."));
      }

      // Always show last page
      addPageButton(_totalPages);
    }

    return buttons;
  }

  void _showTransactionDetails(Transaction transaction) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => TransactionDetailsSheet(transaction: transaction),
    );
  }
}
