class Account {
  final String name;
  final String address;
  final bool isImported;
  final double balance;
  final String currency;

  const Account({
    required this.name,
    required this.address,
    this.isImported = false,
    this.balance = 0.0,
    this.currency = 'USD'
  });
}


class AccountNew {
  final String name;
  final String address;
  final String privateKey;
  final bool isImported;
  final double balance;
  final String currency;

  const AccountNew({
    required this.name,
    required this.address,
    required this.privateKey,
    this.isImported = false,
    this.balance = 0.0,
    this.currency = 'USD',
  });
}
