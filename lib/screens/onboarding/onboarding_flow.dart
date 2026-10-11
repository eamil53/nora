import 'package:flutter/material.dart';
import '../../l10n/app_strings.dart';
import '../../models/user_profile.dart';
import '../../theme/app_colors.dart';

class OnboardingFlow extends StatefulWidget {
  final Function(UserProfile profile) onComplete;
  final String? languageCode;

  const OnboardingFlow({
    super.key,
    required this.onComplete,
    this.languageCode = 'tr',
  });

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  AppStrings get s => AppStrings.get(widget.languageCode);
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Form State
  late final List<String> _selectedAddictions;
  late double _monthlySpend;
  late final List<String> _selectedTriggers;
  late String _selectedMotivation;
  final double _hoursPerDay = 2.5;

  final TextEditingController _customSpendController = TextEditingController();

  List<String> get _addictionOptions => s.isTr
      ? [
          'Casino & Slot Siteleri',
          'Canlı Spor Bahisleri',
          'Kripto Kaldıraçlı İşlemler',
          'Sanal Bahis & Oyunlar',
          'Diğer Şans Oyunları',
        ]
      : [
          'Casino & Slots Online',
          'Live Sports Betting',
          'Crypto Leverage & Trading',
          'Virtual Bets & Games',
          'Other Games of Chance',
        ];

  List<double> get _presetSpends => s.isTr
      ? [1000, 2500, 5000, 10000, 20000, 50000]
      : [100, 250, 500, 1000, 2000, 5000];

  List<String> get _triggerOptions => s.isTr
      ? [
          'Stres / Can Sıkıntısı',
          'Maddi Kaybı Kurtarma İsteği (Chasing)',
          'Yalnızlık / Boş Zaman',
          'Sosyal Medya & Reklamlar',
          'Alkol / Gece Saatleri',
        ]
      : [
          'Stress & Boredom',
          'Loss Chasing Urge',
          'Loneliness & Free Time',
          'Social Media & Ads',
          'Late Nights & Alcohol',
        ];

  List<String> get _motivationOptions => s.isTr
      ? [
          'Finansal Özgürlük ve Birikim',
          'Aileme ve Sevdiklerime Karşı Sorumluluk',
          'Zihinsel Huzur ve Sıfır Stres',
          'Zamanımı Değerli Şeylere Harcamak',
          'Kendi İrademe Yeniden Güvenmek',
        ]
      : [
          'Financial Freedom & Wealth',
          'Responsibility to Loved Ones',
          'Peace of Mind & Zero Stress',
          'Reclaiming Wasted Time',
          'Restoring Self-Respect & Trust',
        ];

  String get _currency => s.isTr ? '₺' : '\$';

  @override
  void initState() {
    super.initState();
    final isTr = widget.languageCode != 'en';
    _monthlySpend = isTr ? 2500 : 250;
    _selectedAddictions = [isTr ? 'Casino & Slot Siteleri' : 'Casino & Slots Online'];
    _selectedTriggers = [isTr ? 'Stres / Can Sıkıntısı' : 'Stress & Boredom'];
    _selectedMotivation = isTr ? 'Finansal Özgürlük ve Birikim' : 'Financial Freedom & Wealth';
  }

  @override
  void dispose() {
    _pageController.dispose();
    _customSpendController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentStep < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _finishOnboarding() {
    final profile = UserProfile(
      monthlySpend: _monthlySpend,
      hoursPerDay: _hoursPerDay,
      selectedAddictions: _selectedAddictions,
      selectedTriggers: _selectedTriggers,
      mainMotivation: _selectedMotivation,
      quitDate: DateTime.now(),
      currencySymbol: _currency,
    );
    widget.onComplete(profile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surfaceCanvas,
      body: SafeArea(
        child: Column(
          children: [
            // Top Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, color: context.colors.textPrimary, size: 20),
                      onPressed: _previousPage,
                    )
                  else
                    const SizedBox(width: 40),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (_currentStep + 1) / 6,
                        backgroundColor: context.colors.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00E676)),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${_currentStep + 1}/6',
                    style: TextStyle(color: context.colors.textSecondary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                children: [
                  _buildWelcomeStep(),
                  _buildAddictionStep(),
                  _buildSpendStep(),
                  _buildTriggerStep(),
                  _buildMotivationStep(),
                  _buildAnalysisStep(),
                ],
              ),
            ),

            // Bottom Continue Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    foregroundColor: Colors.black,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _nextPage,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentStep == 0
                            ? (s.isTr ? 'Analize Başla' : 'Start Assessment')
                            : (_currentStep == 5
                                ? (s.isTr ? 'Planımı Oluştur & Devam Et' : 'Generate Plan & Continue')
                                : (s.isTr ? 'Devam Et' : 'Continue')),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // STEP 0: Welcome
  Widget _buildWelcomeStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00E676).withValues(alpha: 0.15),
              border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.4), width: 2),
            ),
            child: const Icon(
              Icons.shield_rounded,
              size: 72,
              color: Color(0xFF00E676),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            s.isTr ? 'Nora\'ya Hoş Geldiniz' : 'Welcome to Nora',
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            s.isTr
                ? 'Kumarı arkada bırakmanın, paranı ve hayatını kendi cebinde tutmanın en güçlü yolu.'
                : 'The proven way to leave gambling behind and reclaim your money and your life.',
            style: TextStyle(
              color: context.colors.textSecondary,
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.colors.border),
              boxShadow: context.colors.cardShadows,
            ),
            child: Column(
              children: [
                _FeatureRow(icon: Icons.block, text: s.isTr ? '7/24 Yasa Dışı Bahis & Casino Engelleme' : '24/7 Strict Gambling & Betting Shield'),
                const SizedBox(height: 12),
                _FeatureRow(icon: Icons.account_balance_wallet_outlined, text: s.isTr ? 'Canlı Para ve Zaman Tasarruf Sayacı' : 'Live Saved Cash & Time Tracker'),
                const SizedBox(height: 12),
                _FeatureRow(icon: Icons.sos, text: s.isTr ? 'Kriz Anları için İrade ve Nefes Desteği' : 'Urge Interventions & SOS Breathing Support'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // STEP 1: Addiction Types
  Widget _buildAddictionStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            s.isTr ? 'Hangi alanlar sizi en çok zorluyor?' : 'Which gambling areas challenge you most?',
            style: TextStyle(color: context.colors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            s.isTr
                ? 'Engelleme kalkanımızı sizin alışkanlıklarınıza göre özelleştireceğiz.'
                : 'We will customize your protection shield according to your habits.',
            style: TextStyle(color: context.colors.textSecondary, fontSize: 15),
          ),
          const SizedBox(height: 24),
          ..._addictionOptions.map((option) {
            final isSelected = _selectedAddictions.contains(option);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      if (_selectedAddictions.length > 1) _selectedAddictions.remove(option);
                    } else {
                      _selectedAddictions.add(option);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF00E676).withValues(alpha: 0.12) : context.colors.surfaceCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF00E676) : context.colors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected ? null : context.colors.cardShadows,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                        color: isSelected ? const Color(0xFF00E676) : context.colors.border,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            color: isSelected ? context.colors.textPrimary : context.colors.textSecondary,
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // STEP 2: Spend
  Widget _buildSpendStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            s.isTr ? 'Ayda ortalama ne kadar harcıyordunuz?' : 'How much did you spend monthly on average?',
            style: TextStyle(color: context.colors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            s.isTr
                ? 'Gerçek kayıplarınızı görmek kurtuluşun ilk adımıdır.'
                : 'Facing your true losses is the first step toward lasting recovery.',
            style: TextStyle(color: context.colors.textSecondary, fontSize: 15),
          ),
          const SizedBox(height: 28),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.colors.surfaceCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.3)),
              boxShadow: context.colors.cardShadows,
            ),
            child: Column(
              children: [
                Text(s.isTr ? 'Aylık Ortalama Kayıp' : 'Average Monthly Loss', style: TextStyle(color: context.colors.textSecondary, fontSize: 14)),
                const SizedBox(height: 8),
                Text(
                  '$_currency${_monthlySpend.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Color(0xFF00E676),
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _presetSpends.map((amount) {
              final isSelected = _monthlySpend == amount;
              return ChoiceChip(
                label: Text('$_currency${amount.toInt()}'),
                selected: isSelected,
                selectedColor: const Color(0xFF00E676),
                backgroundColor: context.colors.surfaceCardAlt,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.black : context.colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _monthlySpend = amount;
                      _customSpendController.text = amount.toInt().toString();
                    });
                  }
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          TextField(
            controller: _customSpendController,
            keyboardType: TextInputType.number,
            style: TextStyle(color: context.colors.textPrimary),
            decoration: InputDecoration(
              labelText: s.isTr ? 'Özel Tutar Girin (₺)' : 'Enter Custom Amount (\$_currency)',
              labelStyle: TextStyle(color: context.colors.textSecondary),
              filled: true,
              fillColor: context.colors.surfaceCardAlt,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF00E676), width: 2),
              ),
            ),
            onChanged: (val) {
              final parsed = double.tryParse(val);
              if (parsed != null && parsed > 0) {
                setState(() {
                  _monthlySpend = parsed;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  // STEP 3: Triggers
  Widget _buildTriggerStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            s.isTr ? 'Kumar oynama isteğinizi ne tetikliyor?' : 'What triggers your urge to gamble?',
            style: TextStyle(color: context.colors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            s.isTr
                ? 'Tetikleyicileri bilmek kriz anlarını yönetmeyi kolaylaştırır.'
                : 'Identifying triggers empowers you to prevent relapses.',
            style: TextStyle(color: context.colors.textSecondary, fontSize: 15),
          ),
          const SizedBox(height: 24),
          ..._triggerOptions.map((option) {
            final isSelected = _selectedTriggers.contains(option);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      if (_selectedTriggers.length > 1) _selectedTriggers.remove(option);
                    } else {
                      _selectedTriggers.add(option);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF6366F1).withValues(alpha: 0.15) : context.colors.surfaceCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF6366F1) : context.colors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected ? null : context.colors.cardShadows,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? const Color(0xFF6366F1) : context.colors.border,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            color: isSelected ? context.colors.textPrimary : context.colors.textSecondary,
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // STEP 4: Motivation
  Widget _buildMotivationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            s.isTr ? 'En büyük motivasyonunuz nedir?' : 'What is your primary motivation?',
            style: TextStyle(color: context.colors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            s.isTr
                ? 'Neden bu adımı attığınızı her gün size hatırlatacağız.'
                : 'We will remind you why you started every single day.',
            style: TextStyle(color: context.colors.textSecondary, fontSize: 15),
          ),
          const SizedBox(height: 24),
          ..._motivationOptions.map((option) {
            final isSelected = _selectedMotivation == option;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedMotivation = option;
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFF59E0B).withValues(alpha: 0.15) : context.colors.surfaceCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFF59E0B) : context.colors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected ? null : context.colors.cardShadows,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.stars_rounded : Icons.star_border_rounded,
                        color: isSelected ? const Color(0xFFF59E0B) : context.colors.border,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            color: isSelected ? context.colors.textPrimary : context.colors.textSecondary,
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // STEP 5: Analysis Projection
  Widget _buildAnalysisStep() {
    final yearlySaved = _monthlySpend * 12;
    final yearlyHours = _hoursPerDay * 365;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF00E676).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.analytics_rounded, color: Color(0xFF00E676), size: 48),
          ),
          const SizedBox(height: 16),
          Text(
            s.isTr ? 'Kişisel Analiziniz Hazır!' : 'Your Personal Assessment is Ready!',
            style: TextStyle(color: context.colors.textPrimary, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            s.isTr
                ? 'Nora ile 1 yılda elde edeceğiniz özgürlük tablosu:'
                : 'Your 1-year recovery and freedom projection with Nora:',
            style: TextStyle(color: context.colors.textSecondary, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF065F46), Color(0xFF10B981)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 5)),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 44),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.isTr ? '1 Yılda Cebinizde Kalacak Tutar' : 'Saved Cash in 1 Year', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(
                        '$_currency${yearlySaved.toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceCard,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: context.colors.border),
                    boxShadow: context.colors.cardShadows,
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.access_time_filled_rounded, color: Color(0xFF6366F1), size: 28),
                      const SizedBox(height: 8),
                      Text(
                        s.isTr ? '${yearlyHours.toInt()} Saat' : '${yearlyHours.toInt()} Hours',
                        style: TextStyle(color: context.colors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(s.isTr ? 'Kazanılan Zaman' : 'Recovered Time', style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceCard,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: context.colors.border),
                    boxShadow: context.colors.cardShadows,
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.shield_rounded, color: Color(0xFFEF4444), size: 28),
                      const SizedBox(height: 8),
                      Text(
                        '3,850+',
                        style: TextStyle(color: context.colors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(s.isTr ? 'Engellenen Site' : 'Blocked Websites', style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.surfaceCardAlt,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.colors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user_rounded, color: Color(0xFF00E676), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    s.isTr
                        ? 'Korumayı aktif etmek ve tüm özellikleri kullanmak için son adıma geçin.'
                        : 'Proceed to the final step to activate protection and unlock all features.',
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF00E676), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: context.colors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
