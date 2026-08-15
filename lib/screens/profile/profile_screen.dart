import 'package:flutter/material.dart';
import '../../providers/app_state.dart';

class ProfileScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback onOpenPaywall;

  const ProfileScreen({
    super.key,
    required this.appState,
    required this.onOpenPaywall,
  });

  @override
  Widget build(BuildContext context) {
    final profile = appState.userProfile;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1120),
        elevation: 0,
        title: const Text('Profil & Ayarlar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // User Hero Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E676).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_rounded, color: Color(0xFF00E676), size: 48),
                  ),
                  const SizedBox(height: 12),
                  const Text('Nora İrade Savaşçısı', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    'Motivasyon: "${profile.mainMotivation}"',
                    style: const TextStyle(color: Colors.white70, fontSize: 13, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Active Subscription Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF59E0B)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.workspace_premium_rounded, color: Color(0xFFF59E0B), size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Nora Premium Üye', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                              Text(
                                appState.activePlan == 'annual' ? 'Yıllık Paket (Aktif)' : 'Aylık Paket (Aktif)',
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: onOpenPaywall,
                          child: const Text('Yönet', style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Settings Options List
            Material(
              color: const Color(0xFF1E293B),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.white10),
              ),
              child: Column(
                children: [
                  // Screen Time Permission Status Card
                  ListTile(
                    leading: Icon(
                      appState.nativeAuthStatus == 'approved'
                          ? Icons.verified_user_rounded
                          : Icons.warning_amber_rounded,
                      color: appState.nativeAuthStatus == 'approved'
                          ? const Color(0xFF00E676)
                          : const Color(0xFFF59E0B),
                    ),
                    title: const Text(
                      'iOS Ekran Süresi İzni',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      appState.nativeAuthStatus == 'approved'
                          ? 'Sistem engelleme filtresi etkin ve onaylı'
                          : 'Web sitelerini Safari/Chrome üzerinde engellemek için gerekli',
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    trailing: appState.nativeAuthStatus == 'approved'
                        ? const Icon(Icons.check_circle, color: Color(0xFF00E676))
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              appState.requestNativePermissions();
                            },
                            child: const Text('İzin Ver', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                  ),
                  const Divider(color: Colors.white10, height: 1),

                  ListTile(
                    leading: const Icon(Icons.restart_alt_rounded, color: Color(0xFFF97316)),
                    title: const Text('Temizlik Tarihini Yenile', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Kriz anında kayma yaşandıysa sayacı sıfırla', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    onTap: () {
                      _showResetQuitDialog(context);
                    },
                  ),
                  const Divider(color: Colors.white10, height: 1),
                  ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF6366F1)),
                    title: const Text('Paywall & Paketleri Göster', style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Abonelik paketlerini tekrar inceleyin', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    onTap: onOpenPaywall,
                  ),
                  const Divider(color: Colors.white10, height: 1),
                  ListTile(
                    leading: const Icon(Icons.delete_forever_rounded, color: Color(0xFFEF4444)),
                    title: const Text('Tüm Uygulama Verilerini Sıfırla', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                    subtitle: const Text('Ankete ve ilk açılış ekranına geri döner', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    onTap: () {
                      _showResetFullDialog(context);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text('Nora Anti-Gambling Protection v1.0.0', style: TextStyle(color: Colors.white38, fontSize: 12)),
            const SizedBox(height: 6),
            const Text('Gizlilik Odaklı Yerel Engelleme Teknolojisi', style: TextStyle(color: Colors.white24, fontSize: 11)),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showResetQuitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Tarihi Sıfırla?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Bir kayma yaşamak pes ettiğiniz anlamına gelmez. Yeni bir sayfa açıp temiz gün sayacını bugünden başlatmak istiyor musunuz?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text('İptal', style: TextStyle(color: Colors.white54)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF97316)),
            child: const Text('Bugün Baştan Başla', style: TextStyle(color: Colors.white)),
            onPressed: () {
              appState.resetQuitDate();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sayacınız bugünden itibaren yeniden başlatıldı. Güçlü kalın! 💪')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showResetFullDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Tüm Verileri Sıfırla?', style: TextStyle(color: Color(0xFFEF4444))),
        content: const Text(
          'Bu işlem onboarding anketini ve abonelik durumunu sıfırlar.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text('İptal', style: TextStyle(color: Colors.white54)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('Tümünü Sıfırla', style: TextStyle(color: Colors.white)),
            onPressed: () {
              appState.resetFullApp();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
