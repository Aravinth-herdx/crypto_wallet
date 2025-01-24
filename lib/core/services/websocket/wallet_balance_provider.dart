import 'dart:async';
import 'dart:convert';
import 'package:crypto_wallet/core/services/websocket/wallet_balance_state.dart';
import 'package:crypto_wallet/presentation/screens/home/models/currency_model.dart';
import 'package:crypto_wallet/presentation/screens/home/models/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class WalletBalanceProvider extends StateNotifier<WalletBalanceState> {
  WalletBalanceProvider()
      : super(WalletBalanceState(
            network: 'Sepolia', address: '', isLoading: false));

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  String? _currentAddress;

  /// Initialize the WebSocket connection
  void connect(String address) {
    // Disconnect any existing connection
    if (_channel != null) {
      disconnect();
    }

    // Save the new address
    _currentAddress = address;

    // Build the WebSocket URL with the provided address
    final url =
        'wss://api-sepolia.etherscan.io/api?module=account&action=txlist&address=$address&startblock=0&endblock=99999999&page=1&offset=10&sort=desc&apikey=7VF9J4C4QBYKZPRV19G4374M3YPKJ2NAJT';

    // Establish the new WebSocket connection
    _channel = WebSocketChannel.connect(Uri.parse(url));
    print("Connected to WebSocket for address: $address");

    _subscription = _channel!.stream.listen(
      (message) {
        _onMessage(message);
      },
      onError: (error) {
        _onError(error);
      },
      onDone: () {
        print("WebSocket connection closed.");
      },
    );
  }

  /// Handle incoming messages
  void _onMessage(dynamic message) {
    print("Received: $message");
    state = state.copyWith(transaction: [...state.transaction]);
    // Process the WebSocket message here (e.g., decode JSON)
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
      final url =
          'https://api-sepolia.etherscan.io/api?module=account&action=txlist&address=$address&startblock=0&endblock=99999999&page=1&offset=10&sort=desc&apikey=7VF9J4C4QBYKZPRV19G4374M3YPKJ2NAJT';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == "1") {
          List<dynamic> results = data['result'];

          if (results.isNotEmpty) {
            final result =
                results.map((json) => Transaction.fromJson(json)).toList();
            for (final a in result) {
              print(a.toJson());
            }
            state = state.copyWith(transaction: result);
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

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}
