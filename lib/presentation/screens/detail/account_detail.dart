import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/text_widget.dart';
import '../../../providers/auth_provider.dart';
import '../home/models/account.dart';

class AccountDetailsScreen extends ConsumerStatefulWidget {
  final AccountNew account;

  const AccountDetailsScreen({super.key, required this.account});

  @override
  _AccountDetailsScreenState createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends ConsumerState<AccountDetailsScreen> {
  bool _showPrivateKey = false;

  Future<void> _authenticateAndRevealPrivateKey() async {
    final authService = ref.read(authServiceProvider);
    final result = await authService.authenticateBiometric();

    if (result == AuthResult.success) {
      setState(() {
        _showPrivateKey = true;
      });
    } else {
      _showAuthenticationFailedDialog();
    }
  }

  void _showAuthenticationFailedDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Authentication Failed'),
        content:
            const Text('Unable to verify your identity. Please try again.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    _showCopiedSnackBar();
  }

  void _showCopiedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          children: [
            const TextWidget(
              textKey: 'account_details',
            ),
            Text(widget.account.name),
          ],
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildAccountInfoCard(),
            const SizedBox(height: 20),
            _buildQRCodeSection(),
            const SizedBox(height: 20),
            _buildAddressSection(),
            const SizedBox(height: 20),
            _buildPrivateKeySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.account.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // const SizedBox(height: 8),
          // Text(
          //   'Balance: \$${widget.account.balance.toStringAsFixed(2)}',
          //   style: const TextStyle(
          //     fontSize: 16,
          //     color: CupertinoColors.systemGreen,
          //   ),
          // ),
          const SizedBox(height: 8),
          TextWidget(
            textKey: widget.account.isImported
                ? 'imported_wallet'
                : 'created_wallet',
            style: TextStyle(
              color: widget.account.isImported
                  ? CupertinoColors.systemOrange
                  : CupertinoColors.activeBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeSection() {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey4),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const TextWidget(
            textKey: 'wallet_address_qr',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          QrImageView(
            data: widget.account.address,
            version: QrVersions.auto,
            size: 200,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    final formattedAddress =
        '${widget.account.address.substring(0, 6)}...${widget.account.address.substring(widget.account.address.length - 4)}';

    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            textKey: 'wallet_address',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  formattedAddress,
                  style: const TextStyle(color: CupertinoColors.systemGrey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.doc_on_doc),
                onPressed: () => _copyToClipboard(widget.account.address),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const TextWidget(
                textKey: 'full_address',
                style: const TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 12,
                ),
              ),
              Expanded(
                child: Text(
                  ': ${widget.account.address}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrivateKeySection() {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            textKey: 'private_key',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.destructiveRed,
            ),
          ),
          const SizedBox(height: 8),
          const TextWidget(
            textKey: 'caution',
            style: TextStyle(
              color: CupertinoColors.destructiveRed,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          CupertinoButton(
            color: CupertinoColors.systemRed,
            onPressed: _showPrivateKey
                ? () => setState(() => _showPrivateKey = false)
                : _authenticateAndRevealPrivateKey,
            child: TextWidget(
              textKey:
                  _showPrivateKey ? 'hide_private_key' : 'reveal_private_key',
            ),
          ),
          if (_showPrivateKey)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.account.privateKey ?? 'No private key available',
                      style: const TextStyle(
                          color: CupertinoColors.destructiveRed),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.doc_on_doc,
                        color: CupertinoColors.destructiveRed),
                    onPressed: () =>
                        _copyToClipboard(widget.account.privateKey ?? ''),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
