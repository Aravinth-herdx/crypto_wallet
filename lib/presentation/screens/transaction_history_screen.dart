import 'package:flutter/cupertino.dart';
import '../../core/models/transaction_history.dart';
import '../widgets/transaction_details_sheet.dart';
import '../widgets/transaction_list_item.dart';
//
class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
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
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Transaction History'),
      ),
      child: SafeArea(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _transactions.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _transactions.length) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }

            final transaction = _transactions[index];
            return TransactionListItem(
              transaction: transaction,
              onTap: () => _showTransactionDetails(transaction),
            );
          },
        ),
      ),
    );
  }

  void _showTransactionDetails(TransactionHistory transaction) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => TransactionDetailsSheet(transaction: transaction),
    );
  }
}