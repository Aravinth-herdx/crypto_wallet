import 'dart:async';

import '../../models/transaction_history.dart';

class WebSocketService {
  final StreamController<TransactionHistory> _transactionController =
  StreamController<TransactionHistory>.broadcast();
  final StreamController<Map<String, double>> _balanceController =
  StreamController<Map<String, double>>.broadcast();

  Stream<TransactionHistory> get transactionStream => _transactionController.stream;
  Stream<Map<String, double>> get balanceStream => _balanceController.stream;

  void connect(String walletAddress) {
    // Implement WebSocket connection logic for each network
    // Listen for real-time updates
  }

  void disconnect() {
    _transactionController.close();
    _balanceController.close();
  }
}