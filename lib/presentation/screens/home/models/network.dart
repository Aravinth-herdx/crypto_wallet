import 'package:flutter/material.dart';

class Network {
  final String name;
  final String icon;
  final String chainId;
  final bool isTestnet;
  final Color? iconBgColor;

  const Network({
    required this.name,
    required this.icon,
    required this.chainId,
    this.isTestnet = false,
    this.iconBgColor,
  });
}