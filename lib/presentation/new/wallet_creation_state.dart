class WalletCreationState {
  final bool isLoading;
  final bool isPassphraseEnabled;
  final String? error;
  final String? address;
  final List<String>? mnemonicWords;
  final String? mnemonic;

  WalletCreationState({
    this.isLoading = false,
    this.isPassphraseEnabled = false,
    this.error,
    this.address,
    this.mnemonicWords,
    this.mnemonic,
  });

  // fromJson method
  factory WalletCreationState.fromJson(Map<String, dynamic> json) {
    return WalletCreationState(
      isLoading: json['isLoading'] ?? false,
      isPassphraseEnabled: json['isPassphraseEnabled'] ?? false,
      error: json['error'],
      address: json['address'],
      mnemonicWords: json['mnemonicWords'] != null
          ? List<String>.from(json['mnemonicWords'])
          : null,
      mnemonic: json['mnemonic'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'isLoading': isLoading,
      'isPassphraseEnabled': isPassphraseEnabled,
      'error': error,
      'address': address,
      'mnemonicWords': mnemonicWords,
      'mnemonic': mnemonic,
    };
  }

  // copyWith method
  WalletCreationState copyWith({
    bool? isLoading,
    bool? isPassphraseEnabled,
    String? error,
    String? address,
    List<String>? mnemonicWords,
    String? mnemonic,
  }) {
    return WalletCreationState(
      isLoading: isLoading ?? this.isLoading,
      isPassphraseEnabled: isPassphraseEnabled ?? this.isPassphraseEnabled,
      error: error ?? this.error,
      address: address ?? this.address,
      mnemonicWords: mnemonicWords ?? this.mnemonicWords,
      mnemonic: mnemonic ?? this.mnemonic,
    );
  }

  // Override toString for easier debugging
  @override
  String toString() {
    return 'WalletCreationState(isLoading: $isLoading, isPassphraseEnabled: $isPassphraseEnabled, error: $error, address: $address, mnemonicWords: $mnemonicWords, mnemonic: $mnemonic)';
  }
}
