import 'dart:async';
import 'package:flutter/material.dart';
import '../../providers/app_state.dart';
import '../blocker/blocker_screen.dart';
import '../sos/urge_surfing_screen.dart';
import '../journal/journal_screen.dart';
import '../profile/profile_screen.dart';

class MainDashboard extends StatefulWidget {
  final AppState appState;
  final VoidCallback onOpenPaywall;

  const MainDashboard({
    super.key,
    required this.appState,
    required this.onOpenPaywall,
  });

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  Timer? _liveTicker;
  bool _hasPromptedPermission = false;

  @override
  void initState() {
    super.initState();
    // Live update money saved every second
    _liveTicker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });

    _checkAndPromptPermission();
  }

  void _checkAndPromptPermission() {
    if (_hasPromptedPermission) return;
    _hasPromptedPermission = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      if (widget.appState.nativeAuthStatus != 'approved') {
        await widget.appState.requestNativePermissions();
        if (!mounted) return;
        if (widget.appState.nativeAuthStatus != 'approved') {
          _showPermissionWarningModal();
        }
      }
    });
  }

  void _showPermissionWarningModal() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield_outlined, color: Color(0xFFF59E0B), size: 48),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ekran Süresi İzni Verilmedi!',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Buna izin vermezseniz zararlı bahis ve casino siteleri engellenmez.\n\nNora Koruma Kalkanı\'nın Safari ve tarayıcılarda çalışabilmesi için iOS Ekran Süresi izni zorunludur.',
                style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    foregroundColor: const Color(0xFF0B1120),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.verified_user_rounded),
                  label: const Text('Şimdi İzin Ver', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    Navigator.pop(context);
                    await widget.appState.requestNativePermissions();
                    if (mounted && widget.appState.nativeAuthStatus != 'approved') {
                      _showPermissionWarningModal();
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Anladım, Riskleri Kabul Ediyorum', style: TextStyle(color: Colors.white38, fontSize: 13)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _liveTicker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.appState;

    final List<Widget> pages = [
      _buildHomeDashboard(state),
      BlockerScreen(appState: state),
      UrgeSurfingScreen(appState: state),
      JournalScreen(appState: state),
      ProfileScreen(appState: state, onOpenPaywall: widget.onOpenPaywall),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1E293B),
          border: Border(top: BorderSide(color: Colors.white10)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: const Color(0xFF1E293B),
          selectedItemColor: const Color(0xFF00E676),
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shield_rounded),
              label: 'Engelleme',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sos_rounded),
              label: 'Kriz SOS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_rounded),
              label: 'Günlük',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeDashboard(AppState state) {
    final profile = state.userProfile;
    final savedMoney = profile.calculateSavedMoney();
    final savedHours = profile.calculateSavedHours();
    final daysClean = profile.calculateDaysClean();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hoş Geldiniz 👋',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$daysClean Gün Temiz!',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),

                // Shield Badge
                GestureDetector(
                  onTap: () {
                    setState(() => _currentIndex = 1); // Go to blocker
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: state.isBlockerEnabled
                          ? const Color(0xFF00E676).withValues(alpha: 0.15)
                          : const Color(0xFFEF4444).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: state.isBlockerEnabled ? const Color(0xFF00E676) : const Color(0xFFEF4444),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          state.isBlockerEnabled ? Icons.shield_rounded : Icons.shield_outlined,
                          color: state.isBlockerEnabled ? const Color(0xFF00E676) : const Color(0xFFEF4444),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          state.isBlockerEnabled ? 'Koruma Aktif' : 'Koruma Pasif',
                          style: TextStyle(
                            color: state.isBlockerEnabled ? const Color(0xFF00E676) : const Color(0xFFEF4444),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Hero Financial Saved Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF065F46), Color(0xFF10B981)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CEBİNİZDE KALAN TOPLAM TUTAR',
                        style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                      Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 24),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '₺${savedMoney.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Yıllık Hedef: ₺${profile.yearlyProjectedSavings.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Secondary Stats Grid
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.access_time_filled_rounded, color: Color(0xFF6366F1), size: 28),
                        const SizedBox(height: 10),
                        Text(
                          '${savedHours.toStringAsFixed(1)} Saat',
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        const Text('Kazanılan Zaman', style: TextStyle(color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.military_tech_rounded, color: Color(0xFFF59E0B), size: 28),
                        const SizedBox(height: 10),
                        Text(
                          '$daysClean. Gün',
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        const Text('Kesintisiz İrade', style: TextStyle(color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Quick SOS Emergency Callout Banner
            GestureDetector(
              onTap: () {
                setState(() => _currentIndex = 2); // Go to SOS
              },
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7F1D1D), Color(0xFFEF4444)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sos_rounded, color: Colors.white, size: 36),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('KRİZ ANINDA MISINIZ?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text('Nefes egzersizi ve istek erteleme modunu açın', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 28),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Milestones & Badges
            const Text(
              'Kurtuluş Rozetleri',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildBadgeCard('1 Gün', 'İlk Adım', daysClean >= 1, Icons.bolt_rounded),
                  _buildBadgeCard('3 Gün', 'Kriz Aşıldı', daysClean >= 3, Icons.shield_rounded),
                  _buildBadgeCard('1 Hafta', 'İrade Kalkanı', daysClean >= 7, Icons.stars_rounded),
                  _buildBadgeCard('1 Ay', 'Özgür Zihin', daysClean >= 30, Icons.workspace_premium_rounded),
                  _buildBadgeCard('1 Yıl', 'Efsanevi Zafer', daysClean >= 365, Icons.emoji_events_rounded),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeCard(String daysText, String label, bool isUnlocked, IconData icon) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUnlocked ? const Color(0xFF1E293B) : const Color(0xFF1E293B).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isUnlocked ? const Color(0xFFF59E0B) : Colors.white10,
          width: isUnlocked ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isUnlocked ? const Color(0xFFF59E0B) : Colors.white24,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            daysText,
            style: TextStyle(
              color: isUnlocked ? Colors.white : Colors.white38,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isUnlocked ? Colors.white70 : Colors.white24,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
