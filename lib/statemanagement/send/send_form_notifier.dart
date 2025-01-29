import 'dart:convert';

import 'package:crypto_wallet/core/services/websocket/wallet_balance_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web3dart/web3dart.dart';
import '../../core/constants/api_list.dart';
import '../../core/services/wallet/wallet_service.dart';
import 'send_form_state.dart';
import 'package:http/http.dart' as http;

class SendFormNotifier extends StateNotifier<SendFormState> {
  final WalletService _walletService;
  final Ref ref;

  SendFormNotifier(this._walletService, this.ref) : super(SendFormState());

  void updateToken(String token, String address, double amount) {
    state = state.copyWith(selectedToken: token);
    _validateForm(address, amount);
  }

  clearError() {
    state = state.copyWith(errorMessage: '');
  }

  clearState() {
    state = SendFormState.empty();
  }

  void updateAddress(String address, String fromAddress, double amount) {
    state = state.copyWith(address: address.trim());
    _validateForm(fromAddress, amount);
  }

  void updateAmount(String amount, String address, double amount1) {
    state = state.copyWith(amount: amount);
    _validateForm(address, amount1);
  }

  Future<void> _calculateTransactionFee() async {
    try {
      final fee = await _walletService.estimateTransactionFee(
          state.selectedToken, state.address);
      state = state.copyWith(transactionFee: fee);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Fee calculation failed');
    }
  }

  void _validateForm(String address, double amount) {
    final isValidAddress = _isValidEthereumAddress(state.address, address);
    final isValidAmount = _validateAmount(state.amount, amount);

    final isFormValid = isValidAddress && isValidAmount;
    state = state.copyWith(isFormValid: isFormValid);

    if (isFormValid) {
      _calculateTransactionFee();
    }
  }

  bool _isValidEthereumAddress(String address, String fromAddress) {
    return address.isNotEmpty &&
        address != fromAddress &&
        address.startsWith('0x') &&
        address.length == 42;
  }

  bool _validateAmount(String amount, double balance) {
    final parsedAmount = double.tryParse(amount);
    return parsedAmount != null && parsedAmount > 0 && balance >= parsedAmount;
  }

  Future<bool> submitTransaction(String fromAddress) async {
    if (!state.isFormValid) return false;

    state = state.copyWith(isSubmitting: true, errorMessage: '');

    try {
      // final txHash = await _walletService.sendTransaction(
      //   fromAddress: fromAddress,
      //   toAddress: state.address,
      //   amountEth: state.amount,
      //   amount: BigInt.parse(
      //       (double.parse(state.amount) * 1e18).toStringAsFixed(0)),
      //   // token: state.selectedToken,
      // );
      final wallet = await _walletService.getPrivateKey(
        toAddress: state.address,
        fromAddress: fromAddress,
        amountEth: state.amount,
        amount: BigInt.parse(
            (double.parse(state.amount) * 1e18).toStringAsFixed(0)),
      );
      ref
          .read(walletBalanceProvider.notifier)
          .sendTransaction(wallet, state.address, state.amount);

      // await monitorTransaction(
      //     Web3Client(
      //         'https://sepolia.infura.io/v3/67048bd8b88444cbb4d0aee7adcbffd1',
      //         http.Client()),
      //     txHash,
      //     EthereumAddress.fromHex(fromAddress));
      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        errorMessage: '',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<void> monitorTransaction(
      Web3Client client, String txHash, EthereumAddress address) async {
    print("Monitoring transaction: $txHash");

    while (true) {
      try {
        final receipt = await client.getTransactionReceipt(txHash);

        if (receipt != null) {
          print("Transaction confirmed! Receipt: $receipt");

          final balance = await client.getBalance(address);
          print(
              "Updated Balance: ${balance.getValueInUnit(EtherUnit.ether)} ETH");
          break;
        } else {
          print("Transaction not confirmed yet. Retrying...");
        }
      } catch (e) {
        print("Error while checking transaction receipt: $e");
      }

      await Future.delayed(const Duration(seconds: 5));
    }
  }
}
