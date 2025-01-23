import 'package:crypto_wallet/statemanagement/send/send_form_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'send_form_notifier.dart';

final sendFormProvider = StateNotifierProvider<SendFormNotifier, SendFormState>((ref) {
  return SendFormNotifier();
});
