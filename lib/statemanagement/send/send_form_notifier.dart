import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/wallet/wallet_service.dart';
import 'send_form_state.dart';

class SendFormNotifier extends StateNotifier<SendFormState> {
  final WalletService _walletService; // Assume you have a WalletService

  SendFormNotifier(this._walletService) : super(SendFormState());

  void updateToken(String token) {
    state = state.copyWith(selectedToken: token);
    _validateForm();
  }

  clearError(){
    state = state.copyWith(errorMessage:'' );
  }

  clearState(){
    state =SendFormState.empty();
  }

  void updateAddress(String address) {
    state = state.copyWith(address: address.trim());
    _validateForm();
  }

  void updateAmount(String amount) {
    state = state.copyWith(amount: amount);
    _validateForm();
  }

  Future<void> _calculateTransactionFee() async {
    try {
      final fee = await _walletService.estimateTransactionFee(
          state.selectedToken,
          state.address
      );
      state = state.copyWith(transactionFee: fee);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Fee calculation failed');
    }
  }

  void _validateForm() {
    final isValidAddress = _isValidEthereumAddress(state.address);
    final isValidAmount = _validateAmount(state.amount);

    final isFormValid = isValidAddress && isValidAmount;
    state = state.copyWith(isFormValid: isFormValid);

    if (isFormValid) {
      _calculateTransactionFee();
    }
  }

  bool _isValidEthereumAddress(String address) {
    return address.isNotEmpty &&
        address.startsWith('0x') &&
        address.length == 42;
  }

  bool _validateAmount(String amount) {
    final parsedAmount = double.tryParse(amount);
    return parsedAmount != null && parsedAmount > 0;
  }

  void submitTransaction(String fromAddress) async {
    if (!state.isFormValid) return;

    state = state.copyWith(isSubmitting: true, errorMessage: '');

    try {
      await _walletService.sendTransaction(
        fromAddress: fromAddress,
        toAddress: state.address,
        amount: BigInt.parse((double.parse(state.amount) * 1e18).toStringAsFixed(0)),
        // token: state.selectedToken,
      );

      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        errorMessage: '',
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      );
    }
  }
}