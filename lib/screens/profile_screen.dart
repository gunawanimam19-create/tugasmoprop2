import 'package:flutter/material.dart';
import '../state/canteen_state.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationEnabled = true;
  bool _smsEnabled = false;

  void _showTopUpDialog(BuildContext context, CanteenState state) {
    int selectedAmount = 50000;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.add_card_rounded, color: AppTheme.primaryOrange),
              SizedBox(width: 8),
              Text('Top Up Saldo Kantin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pilih nominal saldo yang ingin diisi:', style: TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [10000, 25000, 50000, 100000].map((nominal) {
                  final isSelected = selectedAmount == nominal;
                  return ChoiceChip(
                    label: Text(AppTheme.formatRupiah(nominal)),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryOrange,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (val) {
                      if (val) setDialogState(() => selectedAmount = nominal);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                state.topUpWallet(selectedAmount);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Top up ${AppTheme.formatRupiah(selectedAmount)} berhasil ditambahkan!'),
                    backgroundColor: AppTheme.secondaryGreen,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Konfirmasi Isi Saldo'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCanteenInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.storefront_rounded, color: AppTheme.primaryOrange),
            SizedBox(width: 8),
            Text('Info Kantin Bu Sari', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📍 Lokasi: Gedung Pujasera Kampus, Lantai 1, Stand No. 04', style: TextStyle(fontSize: 13)),
            SizedBox(height: 8),
            Text('⏰ Jam Buka: Senin - Sabtu (07:30 - 17:00 WIB)', style: TextStyle(fontSize: 13)),
            SizedBox(height: 8),
            Text('🍲 Ciri Khas: Masakan rumahan fresh, higienis, bumbu meresap, dan porsi ramah kantong mahasiswa!', style: TextStyle(fontSize: 13)),
            SizedBox(height: 8),
            Text('📞 Kontak Bu Sari: +62 812-3456-7890 (WhatsApp Pemesanan Acara Kampus)', style: TextStyle(fontSize: 13)),
          ],
        ),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
        ],
      ),
    );
  }

  void _showAboutAppDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Kantin Bu Sari Mobile',
      applicationVersion: 'v1.0.0 (Tugas Mobile Programming)',
      applicationLegalese: '© 2026 Kantin Bu Sari • Dikembangkan dengan Flutter',
      children: [
        const SizedBox(height: 12),
        const Text(
          'Aplikasi pemesanan makanan dan minuman Kantin Bu Sari dengan fitur eksplorasi menu, custom pesanan (level pedas & topping), keranjang belanja, checkout, dan pelacakan status pesanan dapur secara real-time.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = CanteenScope.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Pengaturan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Profile Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppTheme.primaryOrange.withOpacity(0.15),
                          child: const Text(
                            'IM',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryOrange,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppTheme.secondaryGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.userName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NIM: ${state.userNim} • Mahasiswa Aktif',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 14),
                    // Loyalty Progress
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[850] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.stars_rounded, color: Colors.amber, size: 20),
                                  SizedBox(width: 6),
                                  Text('Status Member Loyalitas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                ],
                              ),
                              Text(
                                '${state.userPoints} / 500 Pts',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.primaryOrange),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: (state.userPoints / 500).clamp(0.0, 1.0),
                              backgroundColor: Colors.grey.withOpacity(0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryOrange),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Kumpulkan 500 poin untuk voucher makan gratis Rp 25.000!',
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Saldo Kantin Card
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.account_balance_wallet, color: AppTheme.primaryOrange),
                ),
                title: const Text('Saldo Kantin Pay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text(AppTheme.formatRupiah(state.walletBalance), style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryOrange)),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: Size.zero,
                  ),
                  onPressed: () => _showTopUpDialog(context, state),
                  child: const Text('Top Up', style: TextStyle(fontSize: 12)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // App Settings Section
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.dark_mode_outlined, color: AppTheme.primaryOrange),
                    title: const Text('Mode Gelap (Dark Mode)', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Tampilan nyaman di malam hari', style: TextStyle(fontSize: 12)),
                    value: state.isDarkMode,
                    activeColor: AppTheme.primaryOrange,
                    onChanged: (val) => state.toggleDarkMode(),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications_active_outlined, color: AppTheme.primaryOrange),
                    title: const Text('Notifikasi Pesanan', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Dapatkan info saat masakan Bu Sari siap', style: TextStyle(fontSize: 12)),
                    value: _notificationEnabled,
                    activeColor: AppTheme.primaryOrange,
                    onChanged: (val) => setState(() => _notificationEnabled = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.sms_outlined, color: AppTheme.primaryOrange),
                    title: const Text('Notifikasi WhatsApp / SMS', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Kirim bukti nota ke nomor ponsel', style: TextStyle(fontSize: 12)),
                    value: _smsEnabled,
                    activeColor: AppTheme.primaryOrange,
                    onChanged: (val) => setState(() => _smsEnabled = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Canteen Information & Help
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.storefront_rounded, color: AppTheme.primaryOrange),
                    title: const Text('Tentang Kantin Bu Sari', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Jam buka, lokasi stan & kontak', style: TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showCanteenInfoDialog(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.headset_mic_rounded, color: AppTheme.primaryOrange),
                    title: const Text('Bantuan & Hubungi Bu Sari', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Pertanyaan seputar menu & pesanan', style: TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Menghubungkan ke layanan WhatsApp Bu Sari: +62 812-3456-7890'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded, color: AppTheme.primaryOrange),
                    title: const Text('Info Aplikasi Mobile', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Versi 1.0.0 • Mobile Programming', style: TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showAboutAppDialog(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout / Sign Out Button
            OutlinedButton.icon(
              icon: const Icon(Icons.logout_rounded, color: AppTheme.accentRed),
              label: const Text('Keluar dari Akun', style: TextStyle(color: AppTheme.accentRed)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.accentRed),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sesi akun tetap tersimpan di perangkat lokal.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
