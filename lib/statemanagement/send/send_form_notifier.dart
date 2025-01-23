import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'send_form_state.dart';

class SendFormNotifier extends StateNotifier<SendFormState> {
  SendFormNotifier() : super(SendFormState());

  void updateToken(String token) {
    state = state.copyWith(selectedToken: token);
    _validateForm();
  }

  void updateAddress(String address) {
    state = state.copyWith(address: address);
    _validateForm();
  }

  void updateAmount(String amount) {
    state = state.copyWith(amount: amount);
    _validateForm();
  }

  void submitTransaction(String address, String amount) async {
    if (state.isFormValid) {
      state = state.copyWith(isSubmitting: true);

      // Simulate sending transaction logic
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(isSubmitting: false, isSuccess: true);
    } else {
      state = state.copyWith(errorMessage: 'Please fill all the fields correctly');
    }
  }

  void _validateForm() {
    final isValidAddress = state.address.isNotEmpty;
    final isValidAmount = state.amount.isNotEmpty && double.tryParse(state.amount) != null;

    state = state.copyWith(isFormValid: isValidAddress && isValidAmount);
  }
}
