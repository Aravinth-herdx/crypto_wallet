import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/theme_provider.dart';
import '../../providers/accouns_provider.dart';
import '../../statemanagement/send/providers.dart';

class EnhancedSendForm extends ConsumerStatefulWidget {
  const EnhancedSendForm({Key? key}) : super(key: key);

  @override
  _EnhancedSendFormState createState() => _EnhancedSendFormState();
}

class _EnhancedSendFormState extends ConsumerState<EnhancedSendForm> {
  late TextEditingController _addressController;
  late TextEditingController _amountController;
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    final sendFormState = ref.read(sendFormProvider);
    _addressController = TextEditingController(text: sendFormState.address);
    _amountController = TextEditingController(text: sendFormState.amount);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  void _updateAddress(String value) {
    ref.read(sendFormProvider.notifier).updateAddress(value);
  }

  void _updateAmount(String value) {
    ref.read(sendFormProvider.notifier).updateAmount(value);
  }

  void _confirmTransaction() {
    final currentAcc = ref.read(accountProvider);
    final sendFormState = ref.read(sendFormProvider);

    // if (!AddressValidationUtils.isValidAddress(_addressController.text)) {
    //   _showInvalidAddressAlert();
    //   return;
    // }

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          'Confirm ${sendFormState.selectedToken} Transaction',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            _buildDetailCard(sendFormState),
            const SizedBox(height: 15),
            _buildWarningText(),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: CupertinoColors.systemRed),
            ),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              ref.read(sendFormProvider.notifier).submitTransaction(
                  currentAcc.selectedAccount?.address ?? '');
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(dynamic sendFormState) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildTransactionRow(
              'Amount',
              '${sendFormState.amount} ${sendFormState.selectedToken}'
          ),
          const Divider(height: 1, color: CupertinoColors.systemGrey4),
          _buildTransactionRow(
              'To',
              _shortenAddress(_addressController.text)
          ),
          const Divider(height: 1, color: CupertinoColors.systemGrey4),
          _buildTransactionRow(
              'Network Fee',
              '\$${sendFormState.transactionFee.toStringAsFixed(6)}'
          ),
        ],
      ),
    );
  }
  String _shortenAddress(String address) {
    if (address.length <= 12) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 6)}';
  }

  Widget _buildTransactionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600)
          ),
          Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500)
          ),
        ],
      ),
    );
  }

  Widget _buildWarningText() {
    return const Text(
      'Transaction cannot be reversed once confirmed. Please verify all details carefully.',
      style: TextStyle(
        fontSize: 12,
        color: CupertinoColors.destructiveRed,
      ),
      textAlign: TextAlign.center,
    );
  }


  void _showTokenPicker() {
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
          onPressed: () => Navigator.pop(context),
          isDestructiveAction: true,
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showQRScanner() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 400,
        child: MobileScanner(
          controller: _scannerController,
          onDetect: (capture) {
            final barcodes = capture.barcodes;
            if (barcodes.isNotEmpty) {
              final scannedAddress = barcodes.first.rawValue;
              if (scannedAddress != null &&
                  AddressValidationUtils.isValidAddress(scannedAddress)) {
                _addressController.text = scannedAddress;
                _updateAddress(scannedAddress);
                Navigator.pop(context);
              } else {
                _showInvalidAddressAlert();
              }
            }
          },
        ),
      ),
    );
  }

  void _showInvalidAddressAlert() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Invalid Address'),
        content: const Text('The scanned QR code does not contain a valid address.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  Widget _buildTransactionDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sendFormState = ref.watch(sendFormProvider);
    final isDarkMode = ref.watch(themeProviderNotifier);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: CupertinoTextField(
                  maxLines: 2,
                  controller: _addressController,
                  placeholder: 'Recipient Address',
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(CupertinoIcons.person, color: CupertinoColors.systemGrey),
                  ),
                  padding: const EdgeInsets.all(12),
                  onChanged: _updateAddress,
                  decoration: BoxDecoration(
                    color: isDarkMode?null:CupertinoColors.extraLightBackgroundGray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _showQRScanner,
                child: const Icon(CupertinoIcons.qrcode_viewfinder, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Expanded(
                child: CupertinoTextField(
                  controller: _amountController,
                  placeholder: 'Amount',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  padding: const EdgeInsets.all(12),
                  onChanged: _updateAmount,
                  decoration: BoxDecoration(
                    color: isDarkMode?null:CupertinoColors.extraLightBackgroundGray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _showTokenPicker,
                child: Text(
                  sendFormState.selectedToken,
                  style: const TextStyle(color: CupertinoColors.activeBlue),
                ),
              ),
            ],
          ),
          if (sendFormState.isFormValid)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'Estimated Transaction Fee: \$${sendFormState.transactionFee.toStringAsFixed(10)}',
                style: const TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          const SizedBox(height: 24),
          if (sendFormState.isSubmitting)
            const Center(child: CupertinoActivityIndicator()),
          if (sendFormState.isSuccess)
            _buildSuccessDialog(),
          if (sendFormState.errorMessage.isNotEmpty)
            _buildErrorDialog(sendFormState.errorMessage),
          if(!sendFormState.isSubmitting)
          CupertinoButton.filled(
            onPressed: sendFormState.isFormValid ? _confirmTransaction : null,
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessDialog() {
    return CupertinoAlertDialog(
      title: const Text('Success'),
      content: const Text('Transaction Sent Successfully'),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          onPressed: () {
            _addressController.text = '';
            _amountController.text = '';
            ref.read(sendFormProvider.notifier).clearState();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  Widget _buildErrorDialog(String errorMessage) {
    return CupertinoAlertDialog(
      title: const Text(
        'Error',
        style: TextStyle(color: CupertinoColors.destructiveRed),
      ),
      content: Text(errorMessage),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          onPressed: () {
            ref.read(sendFormProvider.notifier).clearError();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

}

// Utility class for address validation
class AddressValidationUtils {
  static bool isValidAddress(String address) {
    // Implement your specific address validation logic here
    // Example: Check length, prefix, checksum, etc.
    return address.isNotEmpty && address.length >= 26 && address.length <= 35;
  }
}