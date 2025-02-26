class ApiList {
  static const String dev = "http://122.165.18.7:2001/api";
  static const String wsUrl = "ws://122.165.18.7:2001";
  static const String ioUrl = "ws://122.165.18.7:2001";

  static const String current = dev;

  static const String getTransactions = '${ApiList.current}/getTransactions';
  static const String getBalance = '${ApiList.current}/getBalance';
  static const String transaction = '${ApiList.current}/transaction';
  static const String wallet = '${ApiList.current}/createWallet';
  static const String updateDeviceToken = '${ApiList.current}/updateDeviceToken';
}
