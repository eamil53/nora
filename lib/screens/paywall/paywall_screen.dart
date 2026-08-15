import 'package:flutter/material.dart';

class PaywallScreen extends StatefulWidget {
  final Function(String selectedPlan) onSubscribeSuccess;
  final VoidCallback? onBack;

  const PaywallScreen({
    super.key,
    required this.onSubscribeSuccess,
    this.onBack,
  });

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  String _selectedPlan = 'annual'; // 'annual' or 'monthly'
  bool _isProcessing = false;

  void _handlePayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate Apple Pay / Google Pay network authorization
    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    // Show success modal sheet
    showModalBottomSheet(
      context: context,
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
                  color: const Color(0xFF00E676).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: Color(0xFF00E676), size: 60),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ödeme Başarıyla Tamamlandı!',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nora Koruma Kalkanı aktif edildi. Özgürlük yolculuğunuz başlıyor!',
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    foregroundColor: const Color(0xFF0B1120),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onSubscribeSuccess(_selectedPlan);
                  },
                  child: const Text('Uygulamaya Giriş Yap', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060913),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final h = constraints.maxHeight;
            final isVeryShort = h < 660;
            final isShort = h < 740;

            final double vSpace = isVeryShort ? 5 : (isShort ? 9 : 13);
            final double cardPad = isVeryShort ? 8 : (isShort ? 10 : 12);
            final double titleSize = isVeryShort ? 22 : (isShort ? 26 : 30);

            return Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: isVeryShort ? 2 : 12),

                              // Headline: Paranı ve Geleceğini Güvenceye Al
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: titleSize,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    height: 1.15,
                                  ),
                                  children: const [
                                    TextSpan(text: 'Paranı ve Geleceğini\n'),
                                    TextSpan(
                                      text: 'Güvenceye Al',
                                      style: TextStyle(color: Color(0xFF00E676)),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                'Zayıf anlarında seni koruyan ve bağımlılığı sonlandıran 1 numaralı kalkan.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isVeryShort ? 12 : 13.5,
                                  color: Colors.white.withValues(alpha: 0.65),
                                  height: 1.3,
                                ),
                              ),

                              SizedBox(height: vSpace * 1.2),

                              // 4 Core Nora Premium Value Pillars (Not a copy of reference app, unique to Nora)
                              _buildNoraPillarCard(
                                icon: Icons.shield_rounded,
                                iconColor: const Color(0xFF00E676),
                                iconBg: const Color(0xFF00E676).withValues(alpha: 0.15),
                                title: 'Bypass Edilemez Katı Kalkan',
                                description: '3,850+ bahis ve casino sitesini cihaz düzeyinde 7/24 kilitler.',
                                padding: cardPad,
                              ),
                              SizedBox(height: isVeryShort ? 5 : 7),

                              _buildNoraPillarCard(
                                icon: Icons.trending_up_rounded,
                                iconColor: const Color(0xFF6366F1),
                                iconBg: const Color(0xFF6366F1).withValues(alpha: 0.15),
                                title: 'Canlı Tasarruf & Zaman Sayacı',
                                description: 'Oynamadığın her gün cebinde kalan net parayı ve zamanı anlık gör.',
                                padding: cardPad,
                              ),
                              SizedBox(height: isVeryShort ? 5 : 7),

                              _buildNoraPillarCard(
                                icon: Icons.psychology_rounded,
                                iconColor: const Color(0xFFF59E0B),
                                iconBg: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                                title: 'SOS Kriz & Urge Surfing Modu',
                                description: 'Şiddetli dürtü anlarında bilime dayalı nefes seansı ile krizi söndür.',
                                padding: cardPad,
                              ),
                              SizedBox(height: isVeryShort ? 5 : 7),

                              _buildNoraPillarCard(
                                icon: Icons.menu_book_rounded,
                                iconColor: const Color(0xFF06B6D4),
                                iconBg: const Color(0xFF06B6D4).withValues(alpha: 0.15),
                                title: 'Duygu & Tetikleyici Günlüğü',
                                description: 'Hangi anlarda istek geldiğini keşfet, relaps krizlerini önceden engelle.',
                                padding: cardPad,
                              ),

                              SizedBox(height: vSpace * 1.1),

                              // Nora Impact Stats Bar
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: isVeryShort ? 6 : 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF131B2E),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildStatItem('⭐ 4.9/5', 'Kullanıcı Puanı'),
                                    Container(width: 1, height: 24, color: Colors.white10),
                                    _buildStatItem('🛡️ 10.000+', 'Kurtarılan Hayat'),
                                    Container(width: 1, height: 24, color: Colors.white10),
                                    _buildStatItem('💰 ₺4.2M+', 'Cepte Kalan Para'),
                                  ],
                                ),
                              ),

                              const Spacer(),

                              SizedBox(height: vSpace),

                              // Interactive Subscription Plan Box
                              _buildSubscriptionSelector(isShort: isVeryShort),

                              SizedBox(height: isVeryShort ? 8 : 12),

                              // Action Button (Nora Premium'u Başlat)
                              SizedBox(
                                width: double.infinity,
                                height: isVeryShort ? 48 : 54,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00E676),
                                    foregroundColor: const Color(0xFF0B1120),
                                    elevation: 8,
                                    shadowColor: const Color(0xFF00E676).withValues(alpha: 0.4),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  onPressed: _isProcessing ? null : _handlePayment,
                                  child: _isProcessing
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(color: Color(0xFF0B1120), strokeWidth: 2.5),
                                        )
                                      : FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.shield_outlined, size: 22),
                                              SizedBox(width: 8),
                                              Text(
                                                'Devam Et',
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ),

                              SizedBox(height: isVeryShort ? 6 : 10),

                              // Footer Links
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildFooterLink('Satın Almayı Geri Yükle'),
                                    Text(' • ', style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 11)),
                                    _buildFooterLink('Kullanım Koşulları'),
                                    Text(' • ', style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 11)),
                                    _buildFooterLink('Gizlilik Politikası'),
                                  ],
                                ),
                              ),

                              SizedBox(height: isVeryShort ? 2 : 6),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Optional Close / Back Button Overlay
                if (widget.onBack != null)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white60, size: 24),
                      onPressed: widget.onBack,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoraPillarCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String description,
    required double padding,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: padding),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildSubscriptionSelector({required bool isShort}) {
    final isAnnual = _selectedPlan == 'annual';

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF00E676),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Option 1: Annual Plan
          InkWell(
            onTap: () {
              setState(() {
                _selectedPlan = 'annual';
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isAnnual ? const Color(0xFF00E676).withValues(alpha: 0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isAnnual ? const Color(0xFF00E676) : Colors.transparent,
                      border: Border.all(
                        color: isAnnual ? const Color(0xFF00E676) : Colors.white38,
                        width: 2,
                      ),
                    ),
                    child: isAnnual ? const Icon(Icons.check, color: Color(0xFF0B1120), size: 14) : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              const Text(
                                'YILLIK KORUMA',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00E676).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '%40 İNDİRİM',
                                  style: TextStyle(color: Color(0xFF00E676), fontSize: 9.5, fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Sadece ₺291,66 /aylık',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    '₺3.500',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    ' /yıl',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          const Divider(color: Colors.white10, height: 10),

          // Option 2: Monthly Plan
          InkWell(
            onTap: () {
              setState(() {
                _selectedPlan = 'monthly';
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: !isAnnual ? const Color(0xFF00E676).withValues(alpha: 0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: !isAnnual ? const Color(0xFF00E676) : Colors.transparent,
                      border: Border.all(
                        color: !isAnnual ? const Color(0xFF00E676) : Colors.white38,
                        width: 2,
                      ),
                    ),
                    child: !isAnnual ? const Icon(Icons.check, color: Color(0xFF0B1120), size: 14) : null,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'AYLIK KORUMA',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const Text(
                    '₺500',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    ' /aylık',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return InkWell(
      onTap: () {},
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.45),
          fontSize: 11,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
