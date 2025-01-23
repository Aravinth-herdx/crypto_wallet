import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';

import '../../statemanagement/send/providers.dart';

class SendForm extends ConsumerWidget {
  const SendForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendFormState = ref.watch(sendFormProvider);
    final sendFormNotifier = ref.read(sendFormProvider.notifier);

    final addressController = TextEditingController(text: sendFormState.address);
    final amountController = TextEditingController(text: sendFormState.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CupertinoTextField(
          controller: addressController,
          placeholder: 'Recipient Address',
          prefix: const Icon(CupertinoIcons.person),
          padding: const EdgeInsets.all(12),
          onChanged: (value) {
            sendFormNotifier.updateAddress(value);
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CupertinoTextField(
                controller: amountController,
                placeholder: 'Amount',
                keyboardType: TextInputType.number,
                padding: const EdgeInsets.all(12),
                onChanged: (value) {
                  sendFormNotifier.updateAmount(value);
                },
              ),
            ),
            const SizedBox(width: 16),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text(sendFormState.selectedToken),
              onPressed: () => _showTokenPicker(context, ref),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (sendFormState.isSubmitting)
          const CupertinoActivityIndicator(),
        if (sendFormState.isSuccess)
          _showSuccessDialog(context),
        if (sendFormState.errorMessage.isNotEmpty)
          _showErrorDialog(context, sendFormState.errorMessage),
        CupertinoButton.filled(
          onPressed: sendFormState.isFormValid
              ? () {
            sendFormNotifier.submitTransaction(
              addressController.text,
              amountController.text,
            );
          }
              : null,
          child: const Text('Send'),
        ),
      ],
    );
  }

  void _showTokenPicker(BuildContext context, WidgetRef ref) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Select Token'),
        actions: AppConstants.supportedTokens.map((token) {
          return CupertinoActionSheetAction(
            onPressed: () {
              ref.read(sendFormProvider.notifier).updateToken(token);
              Navigator.pop(context);
            },
            child: Text(token),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          isDestructiveAction: true,
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  _showErrorDialog(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }


  Widget _showSuccessDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Success'),
      content: const Text('Transaction Sent Successfully'),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
