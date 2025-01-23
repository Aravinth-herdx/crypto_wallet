import 'dart:convert';

class Wallet {
  final String address;
  final String publicKey;
  final String privateKey;
  final String mnemonic;

  Wallet({
    required this.address,
    required this.publicKey,
    required this.privateKey,
    required this.mnemonic,
  });

  // Deserialize from JSON
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      address: json['address'] as String,
      publicKey: json['publicKey'] as String,
      privateKey: json['privateKey'] as String,
      mnemonic: json['mnemonic'] as String,
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'publicKey': publicKey,
      'privateKey': privateKey,
      'mnemonic': mnemonic,
    };
  }

  // Optionally, you can add a method for pretty printing or custom output
  @override
  String toString() {
    return 'Wallet(address: $address, publicKey: $publicKey, privateKey: $privateKey, mnemonic: $mnemonic)';
  }
}
