class AppConstants {
  static const supportedNetworks = ['Ethereum', 'BNB', 'Polygon', 'Solana'];
  static const supportedTokens = ['ETH', 'BNB', 'MATIC', 'SOL', 'USDT', 'USDC'];
  static const defaultLanguages = ['English', 'Spanish', 'Chinese'];

  static String formatDateTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}  $hour.$minute $period';
  }
}