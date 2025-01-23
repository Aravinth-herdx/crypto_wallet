import 'package:crypto_wallet/presentation/new/account_model.dart';
import 'package:crypto_wallet/presentation/new/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_wallet/presentation/new/wallet_creation.dart';

class WalletSetupScreen extends ConsumerWidget {
  const WalletSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsAsyncValue = ref.watch(walletsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFF),
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text(
                    'Wallets',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      ref.refresh(walletsProvider);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {
                      // Add settings navigation
                    },
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF037DD6),
                onRefresh: () async {
                  await ref.refresh(walletsProvider.future);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Wallets Section
                        walletsAsyncValue.when(
                          loading: () => const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(
                                color: Color(0xFF037DD6),
                              ),
                            ),
                          ),
                          error: (error, stack) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Error loading wallets: $error',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    ref.refresh(walletsProvider);
                                  },
                                  child: const Text('Try Again'),
                                ),
                              ],
                            ),
                          ),
                          data: (wallets) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (wallets.isNotEmpty) ...[
                                const Text(
                                  'My Wallets',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF24272A),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ...wallets.map((wallet) => _buildWalletCard(wallet)),
                                const SizedBox(height: 24),
                                const Divider(),
                                const SizedBox(height: 24),
                              ],

                              // Actions Section
                              const Text(
                                'Add or Import Wallet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF24272A),
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildActionCard(
                                context,
                                title: 'Create New Wallet',
                                subtitle: 'Create a new wallet to store your crypto',
                                icon: Icons.add_circle_outline,
                                color: const Color(0xFF037DD6),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const NewWalletScreen(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildActionCard(
                                context,
                                title: 'Import Existing Wallet',
                                subtitle: 'Import using Secret Recovery Phrase',
                                icon: Icons.file_download_outlined,
                                color: const Color(0xFF28A745),
                                onTap: () {
                                  // Add restore wallet navigation
                                },
                              ),
                              // Add extra padding at the bottom for better scroll experience
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard(WalletAccount wallet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Add wallet detail navigation
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF037DD6).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: Color(0xFF037DD6),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wallet.aliasName.isEmpty ? 'Wallet' : wallet.aliasName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF24272A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        wallet.shortAddress,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Color(0xFF24272A),
                  ),
                  onPressed: () {
                    // Add wallet options menu
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF24272A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}