class WalletAccount {
  final String address;
  final String mnemonic;
  final String privateKey;
  final String? passphrase;
  final String aliasName;

  WalletAccount({
    required this.address,
    required this.mnemonic,
    required this.privateKey,
    this.passphrase,
    required this.aliasName,
  });

  factory WalletAccount.fromJson(Map<String, dynamic> json) {
    return WalletAccount(
      address: json['address'] as String,
      mnemonic: json['mnemonic'] as String,
      privateKey: json['privateKey'] as String,
      passphrase: json['passphrase'] as String?,
      aliasName: json['aliasName'] as String? ?? 'Wallet',
    );
  }

  String get shortAddress {
    if (address.length > 10) {
      return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
    }
    return address;
  }
}