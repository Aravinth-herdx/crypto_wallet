class BalanceEvent {
  final String address;
  final Map<String, dynamic> balances;
  final DateTime timestamp;

  BalanceEvent({
    required this.address,
    required this.balances,
    required this.timestamp,
  });
}