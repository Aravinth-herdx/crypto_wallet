import 'package:flutter/cupertino.dart';
import '../widgets/balance_card.dart';
import '../widgets/token_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Wallet'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            BalanceCard(
              totalBalance: '123,456.78',
              currency: 'USD',
            ),
            SizedBox(height: 20),
            TokenList(
              tokens: [
                {'symbol': 'ETH', 'balance': '2.5', 'value': '4,500.00'},
                {'symbol': 'BNB', 'balance': '10.0', 'value': '3,000.00'},
                {'symbol': 'MATIC', 'balance': '1000.0', 'value': '1,200.00'},
                {'symbol': 'SOL', 'balance': '50.0', 'value': '5,000.00'},
              ],
            ),
          ],
        ),
      ),
    );
  }
}