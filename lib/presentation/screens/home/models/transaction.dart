class Transaction {
  final String hash;
  final String from;
  final String to;
  final double amount;
  final String network;
  final double fee;
  final String status;
  final DateTime date;
  final double gasUsed;
  final double gasPrice;

  Transaction({
    required this.hash,
    required this.from,
    required this.to,
    required this.amount,
    required this.network,
    required this.fee,
    required this.status,
    required this.date,
    required this.gasUsed,
    required this.gasPrice,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    final gasUsed = double.parse(json['gasUsed']);
    final gasPrice = double.parse(json['gasPrice']);
    final fee = gasUsed * gasPrice / 1e18; // Convert fee to ETH

    return Transaction(
      hash: json['hash'],
      from: json['from'],
      to: json['to'],
      amount: double.parse(json['value']) / 1e18,
      // Convert Wei to ETH
      network: "Ethereum",
      // Replace with logic if needed for Polygon
      fee: fee,
      status: json['txreceipt_status'] == "1" ? "Success" : "Failed",
      date: DateTime.fromMillisecondsSinceEpoch(
          int.parse(json['timeStamp']) * 1000),
      gasUsed: gasUsed,
      gasPrice: gasPrice,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hash': hash,
      'from': from,
      'to': to,
      'value': (amount * 1e18).toStringAsFixed(0),
      // Convert ETH back to Wei
      'network': network,
      'gasUsed': gasUsed.toStringAsFixed(0),
      'gasPrice': gasPrice.toStringAsFixed(0),
      'txreceipt_status': status == "Success" ? "1" : "0",
      'timeStamp': (date.millisecondsSinceEpoch ~/ 1000).toString(),
      // Convert DateTime to seconds since epoch
    };
  }
}
