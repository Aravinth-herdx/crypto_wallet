import 'package:crypto_wallet/core/services/websocket/wallet_balance_state.dart';
import 'package:crypto_wallet/presentation/screens/home/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/transaction_history.dart';
import '../widgets/transaction_details_sheet.dart';
import '../widgets/transaction_list_item.dart';

//
class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<TransactionHistory> _transactions = transactionsTestData;
  bool _isLoading = false;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadTransactions() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    // Implement pagination logic here
    // Fetch transactions for _currentPage
    setState(() {
      _isLoading = false;
      _currentPage++;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = ref.watch(walletBalanceProvider);
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Transaction History'),
      ),
      child: SafeArea(
        child: walletProvider.transaction.isEmpty
            ? Center(
                child: Text('No History'),
              )
            : ListView.builder(
                controller: _scrollController,
                itemCount: walletProvider.transaction.length,
                itemBuilder: (context, index) {
                  // if (index == _transactions.length) {
                  //   return const Center(
                  //     child: CupertinoActivityIndicator(),
                  //   );
                  // }

                  final transaction = walletProvider.transaction[index];
                  return TransactionListItem(
                    transaction: transaction,
                    onTap: () => _showTransactionDetails(transaction),
                  );
                },
              ),
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
