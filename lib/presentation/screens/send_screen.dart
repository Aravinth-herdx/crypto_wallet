import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/send_form.dart';
import 'package:crypto_wallet/presentation/widgets/qr_scanner_widget.dart';

class SendScreen extends ConsumerWidget {
  const SendScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Send'),
        // trailing: IconButton(
        //   icon: const Icon(Icons.qr_code_scanner),
        //   onPressed: () => _scanQRCode(context),
        // ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: EnhancedSendForm(),
        ),
      ),
    );
  }

  Future<void> _scanQRCode(BuildContext context) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const QRScannerScreen()),
    );

    if (result != null && context.mounted) {
      Clipboard.setData(ClipboardData(text: result));
    }
  }

// Future<void> _shareQRCode(BuildContext context, String address) async {
//   final qrPainter = QrPainter(
//     data: address,
//     version: QrVersions.auto,
//     color: Colors.black,
//     emptyColor: Colors.white,
//   );
//
//   final directory = await getApplicationDocumentsDirectory();
//   final path = '${directory.path}/qr_code.png';
//   final file = File(path);
//
//   final qrImage = await qrPainter.toImage(200);
//   final byteData = await qrImage.toByteData(format: ImageByteFormat.png);
//   await file.writeAsBytes(byteData!.buffer.asUint8List());
//
//   final xFile = XFile(path);
//   await Share.shareXFiles([xFile], text: AppLocalizations.of(context).shareAddressMessage);
// }
}
