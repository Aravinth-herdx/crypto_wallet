import 'dart:async';
import 'dart:convert';
import 'package:crypto_wallet/core/constants/api_list.dart';
import 'package:crypto_wallet/core/services/websocket/wallet_balance_state.dart';
import 'package:crypto_wallet/presentation/screens/home/models/currency_model.dart';
import 'package:crypto_wallet/presentation/screens/home/models/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WalletBalanceProvider extends StateNotifier<WalletBalanceState> {
  WalletBalanceProvider()
      : super(WalletBalanceState(
            network: 'Sepolia', address: '', isLoading: false));

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  String? _currentAddress;
  IO.Socket? _socket;

  void ioConnect() {
    _socket = IO.io(ApiList.ioUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket!.connect();

    _socket!.onConnect((_) {
      print('Connected to Socket.IO');
    });

    _socket!.on('transaction', (data) {
      print('New transaction received: $data');
      _onMessage(data);
      state = state.copyWith(isLoading: false);
    });

    _socket!.onDisconnect((_) => print('Disconnected from Socket.IO'));

    _socket!.onError((error) {
      print('Socket error: $error');
    });
  }

  void sendTransaction(String privateKey, String toAddress, String amount) {
    state = state.copyWith(isLoading: true);
    _socket!.emit('transactionMsg', {
      "privateKey": privateKey,
      "toAddress": toAddress,
      "amountInEther": amount
    });
    print('Transaction emitted');
  }

  void ioDisconnect() {
    _socket?.disconnect();
    print('Socket manually disconnected');
  }

  /// Initialize the WebSocket connection
  void connect(String address) {
    if (_channel != null) {
      disconnect();
    }

    _currentAddress = address;

    final url = '${ApiList.wsUrl}?address=$address';

    _channel = WebSocketChannel.connect(Uri.parse(url));
    print("Connected to WebSocket for address: $address");

    _subscription = _channel!.stream.listen(
      (message) {
        // _onMessage(message);
      },
      onError: (error) {
        _onError(error);
      },
      onDone: () {
        print("WebSocket connection closed.");
      },
    );
  }

  void _onMessage(dynamic message) {
    print("Received: $message");
    try {
      final result = message is String ? jsonDecode(message) : message;
      if (result is Map<String, dynamic> &&
          state.address == result['transaction']['to']) {
        state = state.copyWith(transaction: [
          Transaction.fromJson(result['transaction']),
          ...state.transaction,
        ]);
        fetchBalanceHttpBackend(state.address);
      } else if (result is Map<String, dynamic> &&
          state.address == result['transaction']['from']) {
        // fetchBalanceHttpBackend(state.address);
        state = state.copyWith(transaction: [
          Transaction.fromJson(result['transaction']),
          ...state.transaction,
        ]);
        fetchBalanceHttpBackend(state.address);
      }
    } catch (e, stackTrace) {
      print("Error while processing message: $e");
      print(stackTrace);
    }
  }

  /// Handle WebSocket errors
  void _onError(dynamic error) {
    print("WebSocket error: $error");
    // Optionally attempt reconnection logic here
  }

  /// Disconnect the WebSocket connection
  void disconnect() {
    print("Disconnecting WebSocket...");
    _subscription?.cancel();
    _channel?.sink.close();
    _channel = null;
    _subscription = null;
  }

  /// Reconnect with a new address
  void reconnect(String newAddress) {
    if (newAddress != _currentAddress) {
      print("Reconnecting WebSocket for new address: $newAddress");
      connect(newAddress);
    }
  }

  /// Dispose resources when no longer needed
  void disposeSocket() {
    disconnect();
  }

  Future<void> setEthPrice() async {
    try {
      final url = Uri.parse(
          'https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        state = state.copyWith(ethPrice: data['ethereum']['usd']);
      }
    } catch (e) {}
  }

  Future<void> fetchBalanceHttp(String address) async {
    print('Adress1');
    print(address);
    if (address.isNotEmpty) {
      state = state.copyWith(isError: false, balance: '0.0');
      try {
        final url =
            'https://api.etherscan.io/v2/api?chainid=11155111&module=account&action=balance&address=$address&tag=latest&apikey=7VF9J4C4QBYKZPRV19G4374M3YPKJ2NAJT';
        final uri = Uri.parse(url);
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          // Check if the response is valid
          if (data['status'] == "1" && data['result'] != null) {
            // Parse the balance from the result
            final balanceInWei = BigInt.parse(data['result']);
            final balanceInEther =
                balanceInWei / BigInt.from(10).pow(18); // Convert Wei to Ether

            // Remove trailing zeros
            final formattedBalance =
                double.parse(balanceInEther.toStringAsFixed(4)).toString();
            print('formattedBalance');
            print(formattedBalance);
            // Update state with the fetched balance
            state = state.copyWith(
              // isLoading: false,
              isError: false,
              balance: formattedBalance, // Use the formatted balance
            );
          } else {
            // Handle error response
            state = state.copyWith(
              // isLoading: false,
              isError: true,
              balance: '0.0',
            );
          }
        } else {
          // Handle non-200 status code
          state = state.copyWith(
            // isLoading: false,
            isError: true,
            balance: '0.0',
          );
        }
      } catch (e) {
        // Handle exceptions
        print('Error fetching balance: $e');
        state = state.copyWith(
          // isLoading: false,
          isError: true,
          balance: '0.0',
        );
      }
    }
  }

  Future<void> fetchBalanceHttpBackend(String address) async {
    print('Adress1');
    print(address);
    if (address.isNotEmpty) {
      state = state.copyWith(isError: false);
      try {
        final url = '${ApiList.getBalance}/$address';
        final uri = Uri.parse(url);
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          // Check if the response is valid
          if (data['getBalance']['status'] == "1" &&
              data['getBalance']['result'] != null) {
            // Parse the balance from the result
            final balanceInWei = BigInt.parse(data['getBalance']['result']);
            final balanceInEther = balanceInWei / BigInt.from(10).pow(18);

            // Remove trailing zeros
            final formattedBalance =
                double.parse(balanceInEther.toStringAsFixed(4)).toString();
            print('formattedBalance');
            print(formattedBalance);
            // Update state with the fetched balance
            state = state.copyWith(
              // isLoading: false,
              isError: false,
              balance: formattedBalance, // Use the formatted balance
            );
          } else {
            // Handle error response
            state = state.copyWith(
              // isLoading: false,
              isError: true,
              balance: '0.0',
            );
          }
        } else {
          // Handle non-200 status code
          state = state.copyWith(
            // isLoading: false,
            isError: true,
            balance: '0.0',
          );
        }
      } catch (e) {
        // Handle exceptions
        print('Error fetching balance: $e');
        state = state.copyWith(
          // isLoading: false,
          isError: true,
          balance: '0.0',
        );
      }
    }
  }

  void setLoading() {
    state = state.copyWith(isLoading: true);
  }

  void setCurrency(List<CurrencyModel> currency) {
    state = state.copyWith(currency: currency, isLoading: false);
  }

  void fetchBalance(String address) {
    state = state.copyWith(isError: false, balance: '0.0');

    const String wsUrl =
        'wss://sepolia.infura.io/ws/v3/67048bd8b88444cbb4d0aee7adcbffd1';

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Define the JSON-RPC request
      final request = {
        "jsonrpc": "2.0",
        "method": "eth_getBalance",
        "params": [address, "latest"],
        "id": 1
      };

      // Send the request
      _channel?.sink.add(jsonEncode(request));

      // Listen for responses
      _channel?.stream.listen(
        (response) {
          final data = jsonDecode(response);
          if (data['id'] == 1 && data['result'] != null) {
            final balanceInWei =
                BigInt.parse(data['result'].substring(2), radix: 16);
            final balanceInEther = balanceInWei / BigInt.from(10).pow(18);

            print('Wlatte');
            print(balanceInEther);
            print(balanceInWei);
            // Update state with balance
            state = state.copyWith(
              // isLoading: false,
              balance: balanceInEther.toString(),
            );
          } else {
            // Handle error
            state = state.copyWith(isError: true);
          }
        },
        onError: (error) {
          state = state.copyWith(isError: true);
        },
        onDone: () {
          _channel?.sink.close();
        },
      );
    } catch (e) {
      state = state.copyWith(isError: true);
    }
  }

  Future<void> fetchTransactions(String address) async {
    print('Adress');
    print(address);
    if (address != '') {
      int page = 1;
      int offset = 10000;
      final url =
          'https://api-sepolia.etherscan.io/api?module=account&action=txlist&address=$address&startblock=0&endblock=99999999&page=$page&offset=$offset&sort=desc&apikey=7VF9J4C4QBYKZPRV19G4374M3YPKJ2NAJT';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == "1") {
          List<dynamic> results = data['result'];

          if (results.isNotEmpty) {
            final result =
                results.map((json) => Transaction.fromJson(json)).toList();
            print('Ada : ${result.length}');
            for (final a in result) {
              print(a.toJson());
            }
            state = state.copyWith(transaction: result);
          } else {
            state = state.copyWith(transaction: []);
          }
        } else {
          print(response.body);
          state = state.copyWith(transaction: []);
          // throw Exception("Error: ${data['message']}");
        }
      } else {
        print(response.body);
        state = state.copyWith(transaction: []);
        // throw Exception("Failed to fetch transactions: ${response.statusCode}");
      }
    }
  }

  Future<void> fetchTransactionsBackend(String address) async {
    print('Adress');
    print(address);
    if (address != '') {
      final url = '${ApiList.getTransactions}/$address';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['transactions']['status'] == "1") {
          List<dynamic> results = data['transactions']['result'];

          if (results.isNotEmpty) {
            final result =
                results.map((json) => Transaction.fromJson(json)).toList();
            print('Ada : ${result.length}');
            // for (final a in result) {
            //   print(a.toJson());
            // }
            state = state.copyWith(transaction: result);
          } else {
            state = state.copyWith(transaction: []);
          }
        } else {
          print(response.body);
          state = state.copyWith(transaction: []);
          // throw Exception("Error: ${data['message']}");
        }
      } else {
        print(response.body);
        state = state.copyWith(transaction: []);
        // throw Exception("Failed to fetch transactions: ${response.statusCode}");
      }
    }
  }

  void setAddress(String address) {
    state = state.copyWith(address: address);
  }

  Future<void> updateDeviceToken(String address) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.put(
        Uri.parse(ApiList.updateDeviceToken),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'address': address,
          'deviceToken': prefs.getString('fcmToken') ?? '',
        }),
      );
      if (response.statusCode == 200) {}
    } catch (e) {
      print("Error sending token: $e");
    }
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}
