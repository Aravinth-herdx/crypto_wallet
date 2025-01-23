import 'package:flutter/cupertino.dart';

import '../models/network.dart';

class NetworkSelector extends StatefulWidget {
  const NetworkSelector({Key? key}) : super(key: key);

  @override
  State<NetworkSelector> createState() => _NetworkSelectorState();
}

class _NetworkSelectorState extends State<NetworkSelector> {
  final List<Network> networks = [
    Network(
      name: 'Ethereum Mainnet',
      icon: '🌐',
      chainId: '1',
      iconBgColor: const Color(0xFF627EEA).withOpacity(0.2),
    ),
    Network(
      name: 'BNB Smart Chain',
      icon: '💎',
      chainId: '56',
      iconBgColor: const Color(0xFFF3BA2F).withOpacity(0.2),
    ),
    Network(
      name: 'Polygon',
      icon: '⚡',
      chainId: '137',
      iconBgColor: const Color(0xFF8247E5).withOpacity(0.2),
    ),
    Network(
      name: 'Solana',
      icon: '☀️',
      chainId: '1399811149',
      iconBgColor: const Color(0xFF00FFA3).withOpacity(0.2),
    ),
    Network(
      name: 'Sepolia Test Network',
      icon: '🔧',
      chainId: '11155111',
      isTestnet: true,
      iconBgColor: const Color(0xFF4F6DE6).withOpacity(0.2),
    ),
  ];

  int selectedNetworkIndex = 4;

  void _showNetworkPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Network',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text('Done'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'MAINNET NETWORKS',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                    ...networks.where((n) => !n.isTestnet).map((network) =>
                        _buildNetworkItem(networks.indexOf(network), network)),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'TEST NETWORKS',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                    ...networks.where((n) => n.isTestnet).map((network) =>
                        _buildNetworkItem(networks.indexOf(network), network)),
                    // const SizedBox(height: 16),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   child: CupertinoButton(
                    //     padding: const EdgeInsets.symmetric(vertical: 12),
                    //     color: CupertinoColors.systemGrey6,
                    //     borderRadius: BorderRadius.circular(8),
                    //     child: const Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Icon(
                    //           CupertinoIcons.plus_circle_fill,
                    //           color: CupertinoColors.activeBlue,
                    //         ),
                    //         SizedBox(width: 8),
                    //         Text(
                    //           'Add Custom Network',
                    //           style: TextStyle(
                    //             color: CupertinoColors.activeBlue,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     onPressed: () {
                    //       // Handle add custom network
                    //       Navigator.pop(context);
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkItem(int index, Network network) {
    final bool isSelected = index == selectedNetworkIndex;
    final bool isImplemented = network.isTestnet
        ? true
        : false; // Assuming non-testnet networks are implemented.

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: isImplemented
          ? () {
              setState(() {
                selectedNetworkIndex = index;
              });
              Navigator.pop(context);
            }
          : null, // Disable selection if not implemented
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? CupertinoColors.systemGrey6 : null,
          border: const Border(
            bottom: BorderSide(
              color: CupertinoColors.separator,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: network.iconBgColor ?? CupertinoColors.systemGrey5,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  network.icon,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    network.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (!isImplemented)
                    Text(
                      'Not Implemented',
                      style: const TextStyle(
                        color: CupertinoColors.systemRed,
                        fontSize: 13,
                      ),
                    )
                  else
                    Text(
                      'Chain ID: ${network.chainId}',
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                CupertinoIcons.checkmark_circle_fill,
                color: CupertinoColors.activeBlue,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            'CURRENT NETWORK',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _showNetworkPicker,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: CupertinoColors.systemGrey4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: networks[selectedNetworkIndex].iconBgColor ??
                            CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          networks[selectedNetworkIndex].icon,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          networks[selectedNetworkIndex].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Chain ID: ${networks[selectedNetworkIndex].chainId}',
                          style: const TextStyle(
                            color: CupertinoColors.systemGrey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(CupertinoIcons.chevron_down),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
