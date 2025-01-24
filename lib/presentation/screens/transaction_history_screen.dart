import 'package:crypto_wallet/core/services/websocket/wallet_balance_state.dart';
import 'package:crypto_wallet/presentation/screens/home/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/text_widget.dart';
import '../../core/models/transaction_history.dart';
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
  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  Future<void> getTransactions() async {
    await Future.delayed(Duration.zero);
    setState(() {
      _allTransactions = ref.read(walletBalanceProvider).transaction;
    });
  }

  List<Transaction> _allTransactions = [];
  final int _transactionsPerPage = 10;

  int _currentPage = 1;

  List<Transaction> get _paginatedTransactions {
    final startIndex = (_currentPage - 1) * _transactionsPerPage;
    final endIndex = startIndex + _transactionsPerPage;
    return _allTransactions.sublist(
      startIndex,
      endIndex > _allTransactions.length ? _allTransactions.length : endIndex,
    );
  }

  int get _totalPages =>
      (_allTransactions.length / _transactionsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    final walletProvider = ref.watch(walletBalanceProvider);
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
              child: _allTransactions.isEmpty
                  ? const Center(
                      child: TextWidget(
                      textKey: 'no_history',
                    ))
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
            if (_allTransactions.isNotEmpty) _buildPaginationControls(),
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
          // Previous button
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            onPressed: _currentPage > 1
                ? () {
                    setState(() => _currentPage--);
                  }
                : null, // Disable if it's the first page
            child: TextWidget(
              textKey: 'previous',
              style: TextStyle(
                color: _currentPage > 1
                    ? CupertinoColors.activeBlue
                    : CupertinoColors.systemGrey, // Grey out if disabled
              ),
            ),
          ),

          // Always show at least the "1" button
          if (_totalPages > 0)
            ...List.generate(_totalPages, (index) {
              final page = index + 1;
              final isSelected = page == _currentPage;
              return CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                onPressed: () {
                  setState(() => _currentPage = page);
                },
                child: Text(
                  '$page',
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? CupertinoColors.activeBlue
                        : CupertinoColors.systemGrey,
                  ),
                ),
              );
            }),

          // Next button
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            onPressed: _currentPage < _totalPages
                ? () {
                    setState(() => _currentPage++);
                  }
                : null, // Disable if it's the last page
            child: TextWidget(
              textKey: 'next',
              style: TextStyle(
                color: _currentPage > 1
                    ? CupertinoColors.activeBlue
                    : CupertinoColors.systemGrey, // Grey out if disabled
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetails(Transaction transaction) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => TransactionDetailsSheet(transaction: transaction),
    );
  }
}
