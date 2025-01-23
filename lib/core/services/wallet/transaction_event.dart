
class TransactionEvent {
  final String type;
  final String transactionHash;
  final bool status;
  final Map<String, dynamic>? additionalData;

  TransactionEvent({
    required this.type,
    required this.transactionHash,
    required this.status,
    this.additionalData,
  });

  factory TransactionEvent.fromJson(Map<String, dynamic> json) {
    return TransactionEvent(
      type: json['type'] ?? 'unknown',
      transactionHash: json['transactionHash'] ?? '',
      status: json['status'] ?? false,
      additionalData: json['additionalData'],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'transactionHash': transactionHash,
    'status': status,
    'additionalData': additionalData,
  };
}

class TransactionDetails {
  final String hash;
  final String from;
  final String to;
  final String value;
  final String timeStamp;
  final bool success;
  final int confirmations;
  final String gasUsed;
  final String gasPrice;

  TransactionDetails({
    required this.hash,
    required this.from,
    required this.to,
    required this.value,
    required this.timeStamp,
    required this.success,
    required this.confirmations,
    required this.gasUsed,
    required this.gasPrice,
  });

  factory TransactionDetails.fromJson(Map<String, dynamic> json) {
    return TransactionDetails(
      hash: json['hash'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      value: json['value'] ?? '0',
      timeStamp: json['timeStamp'] ?? '',
      success: json['isError'] == '0',
      confirmations: int.tryParse(json['confirmations'] ?? '0') ?? 0,
      gasUsed: json['gasUsed'] ?? '0',
      gasPrice: json['gasPrice'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() => {
    'hash': hash,
    'from': from,
    'to': to,
    'value': value,
    'timeStamp': timeStamp,
    'success': success,
    'confirmations': confirmations,
    'gasUsed': gasUsed,
    'gasPrice': gasPrice,
  };

  double get valueInEther => BigInt.parse(value) / BigInt.from(10).pow(18);

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp));

  double get gasPriceInGwei => BigInt.parse(gasPrice) / BigInt.from(10).pow(9);
}