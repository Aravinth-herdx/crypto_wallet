import 'package:crypto_wallet/core/constants/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/constants/chart.dart';
import '../../../core/services/websocket/wallet_balance_state.dart';
import '../home/models/currency_model.dart';
import 'currency_details_page.dart';

class CoinsPage extends ConsumerStatefulWidget {
  const CoinsPage({super.key});

  @override
  _CoinsPageState createState() => _CoinsPageState();
}

class _CoinsPageState extends ConsumerState<CoinsPage> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int itemsPerPage = 5;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreCurrencies();
    }
  }

  void _loadMoreCurrencies() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    // Simulated network delay
    await Future.delayed(const Duration(seconds: 2));

    final currencies = ref.watch(currencyProvider);
    int startIndex = currentPage * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;

    if (startIndex < currencies.currencyList.length) {
      setState(() {
        currentPage++;
        isLoading = false;
      });
    }
  }

  void _showCurrencyDetails(CurrencyModel currency) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(currency.currencyName),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              _buildWeeklyGraph(currency),
              _buildCurrencyDetails(currency),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyGraph(CurrencyModel currency) {
    return currency.weeklyGraphData != null
        ? AspectRatio(
            aspectRatio: 1.5,
            child: CryptoChart(dataPoints: currency.weeklyGraphData!.toList()),
          )
        : const SizedBox.shrink();
  }

  Widget _buildCurrencyDetails(CurrencyModel currency) {
    return CurrencyDetailsCard(
      currency: currency,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencies = ref.watch(currencyProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: TextWidget(textKey: 'currencies'),
      ),
      child: SafeArea(
          child: ref.watch(currencyProvider).isLoading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: CupertinoColors.systemGrey5,
                    ),
                  ),
                  child: Skeletonizer(
                    enabled: ref.watch(currencyProvider).isLoading,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          currencies.currencyList.length + (isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == currencies.currencyList.length) {
                          return const CupertinoActivityIndicator();
                        }

                        final currency = currencies.currencyList[index];
                        return GestureDetector(
                            onTap: () => _showCurrencyDetails(currency),
                            child: TokenListItems(token: currency));
                      },
                    ),
                  ),
                )),
    );
  }
}

class TokenListItems extends ConsumerWidget {
  final CurrencyModel token;

  const TokenListItems({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.systemGrey5,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            child: Image.network(token.coinIcon),
          ),
          const SizedBox(width: 12),
          // Token Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  token.currency.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      formatMarketCap(token.marketCap),
                      // '\$${token.marketCap}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      // _calculateChange(),
                      '${token.priceChangePercentage.toString()}%',
                      style: TextStyle(
                        color: _getChangeColor(
                            token.priceChangePercentage.toString()),
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          // Token Value
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                token.currency.toUpperCase() == 'ETH'
                    ? '\$${(ref.watch(walletBalanceProvider).ethPrice * double.parse(ref.watch(walletBalanceProvider).balance)).toStringAsFixed(2)}' // Replace 2200 with actual rate
                    : '\$0.00',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                token.currency.toUpperCase() == 'ETH'
                    ? ref.watch(walletBalanceProvider).balance.toString()
                    : '0.0',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatMarketCap(double value) {
    if (value >= 1e9) {
      return '\$${(value / 1e9).toStringAsFixed(2)} B'; // Billion
    } else if (value >= 1e6) {
      return '\$${(value / 1e6).toStringAsFixed(2)} M'; // Million
    } else {
      return '\$${value.toStringAsFixed(2)}'; // Standard formatting
    }
  }

  Color _getChangeColor(String context) {
    // This would normally check if the change is positive or negative
    // For now, returning green for demo
    if (context.contains('-')) {
      return CupertinoColors.destructiveRed;
    }
    return CupertinoColors.activeGreen;
  }
}
