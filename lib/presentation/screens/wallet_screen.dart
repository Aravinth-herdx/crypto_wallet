// import 'dart:io';
// import 'dart:ui';
//
// import 'package:crypto_wallet/presentation/screens/wallet_import/screen/wallet_import_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:share_plus/share_plus.dart';
// import '../../core/localization/app_localizations.dart';
// import '../../statemanagement/wallet/wallet_provider.dart';
// import '../widgets/qr_scanner_widget.dart';
//
// class WalletScreen extends ConsumerWidget {
//   const WalletScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final walletState = ref.watch(walletProvider);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context).wallet),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.qr_code_scanner),
//             onPressed: () => _scanQRCode(context),
//           ),
//         ],
//       ),
//       body: walletState.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : walletState.error != null
//           ? Center(
//         child: Text(
//           '${AppLocalizations.of(context).error}: ${walletState.error}',
//           style: const TextStyle(color: Colors.red),
//         ),
//       )
//           : true
//           // : walletState.address == null
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () => ref.read(walletProvider.notifier).createWallet(),
//               child: Text(AppLocalizations.of(context).createWallet),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => const WalletImportScreen(),
//                 ),
//               ),
//               child: Text(AppLocalizations.of(context).importWallet),
//             ),
//           ],
//         ),
//       )
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           AppLocalizations.of(context).address,
//                           style: Theme.of(context).textTheme.titleMedium,
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.copy),
//                           onPressed: () {
//                             Clipboard.setData(ClipboardData(text: walletState.address ?? ''));
//                           },
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(walletState.address ?? ''),
//                     const SizedBox(height: 16),
//                     Center(
//                       child: QrImageView(
//                         data: walletState.address ?? '',
//                         size: 200,
//                         backgroundColor: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton.icon(
//                       onPressed: () => _shareQRCode(context, walletState.address!),
//                       icon: const Icon(Icons.share),
//                       label: Text(AppLocalizations.of(context).shareAddress),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               AppLocalizations.of(context).securityWarning,
//               style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                 color: Colors.red,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _scanQRCode(BuildContext context) async {
//     final result = await Navigator.push<String>(
//       context,
//       MaterialPageRoute(builder: (_) => const QRScannerScreen()),
//     );
//
//     if (result != null && context.mounted) {
//       Clipboard.setData(ClipboardData(text: result));
//     }
//   }
//
//   Future<void> _shareQRCode(BuildContext context, String address) async {
//     final qrPainter = QrPainter(
//       data: address,
//       version: QrVersions.auto,
//       color: Colors.black,
//       emptyColor: Colors.white,
//     );
//
//     final directory = await getApplicationDocumentsDirectory();
//     final path = '${directory.path}/qr_code.png';
//     final file = File(path);
//
//     final qrImage = await qrPainter.toImage(200);
//     final byteData = await qrImage.toByteData(format: ImageByteFormat.png);
//     await file.writeAsBytes(byteData!.buffer.asUint8List());
//
//     final xFile = XFile(path);
//     await Share.shareXFiles([xFile], text: AppLocalizations.of(context).shareAddressMessage);
//   }
// }
