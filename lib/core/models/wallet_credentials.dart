class WalletCredentials {
  final String mnemonic;
  final String privateKey;
  final String publicKey;
  final String walletAddress;

  WalletCredentials({
    required this.mnemonic,
    required this.privateKey,
    required this.publicKey,
    required this.walletAddress,
  });

  Map<String, dynamic> toJson() => {
    'mnemonic': mnemonic,
    'privateKey': privateKey,
    'publicKey': publicKey,
    'walletAddress': walletAddress,
  };

  factory WalletCredentials.fromJson(Map<String, dynamic> json) {
    return WalletCredentials(
      mnemonic: json['mnemonic'],
      privateKey: json['privateKey'],
      publicKey: json['publicKey'],
      walletAddress: json['walletAddress'],
    );
  }
}