class SendFormState {
  final String selectedToken;
  final String address;
  final String amount;
  final String errorMessage;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFormValid;

  SendFormState({
    this.selectedToken = 'ETH',
    this.address = '',
    this.amount = '',
    this.errorMessage = '',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isFormValid = false,
  });

  SendFormState copyWith({
    String? selectedToken,
    String? address,
    String? amount,
    String? errorMessage,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFormValid,
  }) {
    return SendFormState(
      selectedToken: selectedToken ?? this.selectedToken,
      address: address ?? this.address,
      amount: amount ?? this.amount,
      errorMessage: errorMessage ?? this.errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }
}
