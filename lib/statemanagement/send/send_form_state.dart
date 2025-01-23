class SendFormState {
  final String address;
  final String amount;
  final String selectedToken;
  final bool isFormValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;
  final double transactionFee;

  SendFormState({
    this.address = '',
    this.amount = '',
    this.selectedToken = 'ETH',
    this.isFormValid = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage = '',
    this.transactionFee = 0.0,
  });

  SendFormState copyWith({
    String? address,
    String? amount,
    String? selectedToken,
    bool? isFormValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    double? transactionFee,
  }) {
    return SendFormState(
      address: address ?? this.address,
      amount: amount ?? this.amount,
      selectedToken: selectedToken ?? this.selectedToken,
      isFormValid: isFormValid ?? this.isFormValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      transactionFee: transactionFee ?? this.transactionFee,
    );
  }

  factory SendFormState.empty() {
    return SendFormState();
  }
}