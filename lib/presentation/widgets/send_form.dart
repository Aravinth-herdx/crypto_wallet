import 'package:crypto_wallet/core/localization/localization_provider.dart';
import 'package:crypto_wallet/core/services/websocket/wallet_balance_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/text_widget.dart';
import '../../core/theme/theme_provider.dart';
import '../../providers/accouns_provider.dart';
import '../../statemanagement/send/providers.dart';

class EnhancedSendForm extends ConsumerStatefulWidget {
  const EnhancedSendForm({super.key});

  @override
  _EnhancedSendFormState createState() => _EnhancedSendFormState();
}

class _EnhancedSendFormState extends ConsumerState<EnhancedSendForm> {
  late TextEditingController _addressController;
  late TextEditingController _amountController;
  final MobileScannerController _scannerController = MobileScannerController();
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextWidget(
              textKey: 'confirm',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' ${sendFormState.selectedToken} ',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextWidget(
              textKey: 'transaction',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            _buildDetailCard(sendFormState),
            const SizedBox(height: 15),
            _buildWarningText(ref),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const TextWidget(
              textKey: 'cancel',
              style: TextStyle(color: CupertinoColors.systemRed),
            ),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              Navigator.pop(context);
              final result = await ref
                  .read(sendFormProvider.notifier)
                  .submitTransaction(currentAcc.selectedAccount?.address ?? '');
              print(result);
              if (result) {
                ref.read(walletBalanceProvider.notifier).fetchBalanceHttp(
                    currentAcc.selectedAccount?.address ?? '');
                ref.read(walletBalanceProvider.notifier).fetchTransactions(
                    currentAcc.selectedAccount?.address ?? '');
              }
            },
            child: const TextWidget(
              textKey: 'confirm',
            ),
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
          _buildTransactionRow('amount',
              '${sendFormState.amount} ${sendFormState.selectedToken}'),
          const Divider(height: 1, color: CupertinoColors.systemGrey4),
          _buildTransactionRow('to', _shortenAddress(_addressController.text)),
          const Divider(height: 1, color: CupertinoColors.systemGrey4),
          _buildTransactionRow('network_fee',
              '\$${sendFormState.transactionFee.toStringAsFixed(6)}'),
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: TextWidget(
                textKey: label,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildWarningText(WidgetRef ref) {
    return ref.watch(languageProvider) == 'en'
        ? const Text(
            'Transaction cannot be reversed once confirmed. Please verify all details carefully.',
            style: TextStyle(
              fontSize: 12,
              color: CupertinoColors.destructiveRed,
            ),
            textAlign: TextAlign.center,
          )
        : const Text(
            'பரிவர்த்தனை உறுதிப்படுத்தப்பட்டவுடன் திரும்பப் பெற முடியாது. தயவுசெய்து அனைத்து விவரங்களையும் கவனமாக சரிபார்க்கவும்.',
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
        title: const TextWidget(
          textKey: 'select_token',
        ),
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
          child: const TextWidget(
            textKey: 'cancel',
          ),
        ),
      ),
    );
  }

  void _showQRScanner() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black87,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.8,
        child: Column(
          children: [
            Expanded(
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.blueAccent,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutWidth: 250,
                  cutOutHeight: 250,
                ),
                onPermissionSet: (ctrl, p) => _onPermissionSet(context, p),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInvalidAddressAlert() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Invalid Address'),
        content:
            const Text('The scanned QR code does not contain a valid address.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      final barcodes = scanData.code;
      if (barcodes == null) {
        return;
      }
      if (barcodes.isNotEmpty) {
        final scannedAddress = barcodes;
        if (scannedAddress != '' &&
            AddressValidationUtils.isValidAddress(scannedAddress)) {
          _addressController.text = scannedAddress;
          _updateAddress(scannedAddress);
          controller.dispose();
          Navigator.of(context).pop();
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: CupertinoTextField(
                  maxLines: 2,
                  controller: _addressController,
                  placeholder: ref.watch(languageProvider) == 'en'
                      ? 'Recipient Address'
                      : 'பெறுநர் முகவரி',
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(CupertinoIcons.person,
                        color: CupertinoColors.systemGrey),
                  ),
                  padding: const EdgeInsets.all(12),
                  onChanged: _updateAddress,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? null
                        : CupertinoColors.extraLightBackgroundGray,
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
                  placeholder:
                      ref.watch(languageProvider) == 'en' ? 'Amount' : 'தொகை',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  padding: const EdgeInsets.all(12),
                  onChanged: _updateAmount,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? null
                        : CupertinoColors.extraLightBackgroundGray,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    ref.watch(languageProvider) == 'en'
                        ? 'Estimated Transaction Fee: '
                        : 'மதிப்பிடப்பட்ட பரிவர்த்தனை கட்டணம்: ',
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 12,
                    ),
                    // textAlign: TextAlign.right,
                  ),
                  Text(
                    '\$${sendFormState.transactionFee.toStringAsFixed(10)}',
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 12,
                    ),
                    // textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 15),
          if (sendFormState.isSubmitting)
            const Center(child: CupertinoActivityIndicator()),
          if (sendFormState.isSuccess) _buildSuccessDialog(),
          if (sendFormState.errorMessage.isNotEmpty)
            _buildErrorDialog(sendFormState.errorMessage),
          if (!sendFormState.isSubmitting)
            CupertinoButton.filled(
              onPressed: sendFormState.isFormValid ? _confirmTransaction : null,
              child: TextWidget(
                textKey: 'send',
                style: TextStyle(
                    color: ref.watch(themeProviderNotifier)
                        ? CupertinoColors.white
                        : CupertinoColors.black),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSuccessDialog() {
    return CupertinoAlertDialog(
      title: const TextWidget(
        textKey: 'success',
      ),
      content: const TextWidget(
        textKey: 'transaction_sent',
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          onPressed: () {
            _addressController.text = '';
            _amountController.text = '';
            ref.read(sendFormProvider.notifier).clearState();
          },
          child: const TextWidget(
            textKey: 'ok',
          ),
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
    return address.isNotEmpty && address.length >= 26;
  }
}
