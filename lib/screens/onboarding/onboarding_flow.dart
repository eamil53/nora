import 'package:flutter/material.dart';
import '../../models/user_profile.dart';

class OnboardingFlow extends StatefulWidget {
  final Function(UserProfile profile) onComplete;

  const OnboardingFlow({super.key, required this.onComplete});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Answers State
  final List<String> _selectedAddictions = ['Yasa Dışı Bahis', 'Online Casino & Slot'];
  double _monthlySpend = 7500.0;
  final double _hoursPerDay = 2.5;
  final List<String> _selectedTriggers = ['Finansal Stres', 'Sosyal Medya Reklamları'];
  String _selectedMotivation = 'Borçsuz Bir Hayat ve Aile Huzuru';

  final TextEditingController _customSpendController = TextEditingController(text: '7500');

  final List<String> _addictionOptions = [
    'Yasa Dışı Bahis (İllegal İddaa)',
    'Online Casino & Slot (Bonanza vb.)',
    'Riskli Forex & Kaldıraçlı İşlemler',
    'Kripto Kumar / İkili Opsiyon',
    'Canlı Poker & Blackjack',
  ];

  final List<double> _presetSpends = [3000, 5000, 7500, 15000, 30000, 50000];

  final List<String> _triggerOptions = [
    'Finansal Stres ve Borç Baskısı',
    'Sosyal Medya Reklamları & Pop-uplar',
    'Gece Saatleri ve Can Sıkıntısı',
    'Kaybedileni Geri Kazanma Hırsı',
    'Alkollü Anlar / Duygusal Çöküş',
  ];

  final List<String> _motivationOptions = [
    'Borçsuz Bir Hayat ve Aile Huzuru',
    'Gelecek Birikimi ve Finansal Özgürlük',
    'Zamanı Değerli ve Verimli Kullanmak',
    'Zihinsel Rahatlama ve Temiz Bir Beyin',
  ];

  void _nextPage() {
    if (_currentStep < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
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
      currencySymbol: '₺',
    );
    widget.onComplete(profile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
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
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: 20),
                      onPressed: _previousPage,
                    )
                  else
                    const SizedBox(width: 40),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (_currentStep + 1) / 6,
                        backgroundColor: Colors.white10,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00E676)),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${_currentStep + 1}/6',
                    style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
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
                    foregroundColor: const Color(0xFF0B1120),
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
                            ? 'Analize Başla'
                            : (_currentStep == 5 ? 'Planımı Oluştur & Devam Et' : 'Devam Et'),
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
          const Text(
            'Nora\'ya Hoş Geldiniz',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Kumarı arkada bırakmanın, paranı ve hayatını kendi cebinde tutmanın en güçlü yolu.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: const Column(
              children: [
                _FeatureRow(icon: Icons.block, text: '7/24 Yasa Dışı Bahis & Casino Engelleme'),
                SizedBox(height: 12),
                _FeatureRow(icon: Icons.account_balance_wallet_outlined, text: 'Canlı Para ve Zaman Tasarruf Sayacı'),
                SizedBox(height: 12),
                _FeatureRow(icon: Icons.sos, text: 'Kriz Anları için İrade ve Nefes Desteği'),
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
          const Text(
            'Hangi alanlar sizi en çok zorluyor?',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Engelleme kalkanımızı sizin alışkanlıklarınıza göre özelleştireceğiz.',
            style: TextStyle(color: Colors.white60, fontSize: 15),
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
                    color: isSelected ? const Color(0xFF00E676).withValues(alpha: 0.12) : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF00E676) : Colors.white10,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                        color: isSelected ? const Color(0xFF00E676) : Colors.white38,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
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
          const Text(
            'Ayda ortalama ne kadar harcıyordunuz?',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Gerçek kayıplarınızı görmek kurtuluşun ilk adımıdır.',
            style: TextStyle(color: Colors.white60, fontSize: 15),
          ),
          const SizedBox(height: 28),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                const Text('Aylık Ortalama Kayıp', style: TextStyle(color: Colors.white54, fontSize: 14)),
                const SizedBox(height: 8),
                Text(
                  '₺${_monthlySpend.toStringAsFixed(0)}',
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
                label: Text('₺${amount.toInt()}'),
                selected: isSelected,
                selectedColor: const Color(0xFF00E676),
                backgroundColor: const Color(0xFF1E293B),
                labelStyle: TextStyle(
                  color: isSelected ? const Color(0xFF0B1120) : Colors.white,
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
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Özel Tutar Girin (₺)',
              labelStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF1E293B),
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
          const Text(
            'Kumar oynama isteğinizi ne tetikliyor?',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tetikleyicileri bilmek kriz anlarını yönetmeyi kolaylaştırır.',
            style: TextStyle(color: Colors.white60, fontSize: 15),
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
                    color: isSelected ? const Color(0xFF6366F1).withValues(alpha: 0.15) : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF6366F1) : Colors.white10,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? const Color(0xFF6366F1) : Colors.white38,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
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
          const Text(
            'En büyük motivasyonunuz nedir?',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Neden bu adımı attığınızı her gün size hatırlatacağız.',
            style: TextStyle(color: Colors.white60, fontSize: 15),
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
                    color: isSelected ? const Color(0xFFF59E0B).withValues(alpha: 0.15) : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFF59E0B) : Colors.white10,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.stars_rounded : Icons.star_border_rounded,
                        color: isSelected ? const Color(0xFFF59E0B) : Colors.white38,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
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
          const Text(
            'Kişisel Analiziniz Hazır!',
            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nora ile 1 yılda elde edeceğiniz özgürlük tablosu:',
            style: TextStyle(color: Colors.white60, fontSize: 15),
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
                      const Text('1 Yılda Cebinizde Kalacak Tutar', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(
                        '₺${yearlySaved.toStringAsFixed(0)}',
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
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.access_time_filled_rounded, color: Color(0xFF6366F1), size: 28),
                      const SizedBox(height: 8),
                      Text(
                        '${yearlyHours.toInt()} Saat',
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Text('Kazanılan Zaman', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.shield_rounded, color: Color(0xFFEF4444), size: 28),
                      const SizedBox(height: 8),
                      const Text(
                        '3,850+',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Text('Engellenen Site', style: TextStyle(color: Colors.white54, fontSize: 12)),
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
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user_rounded, color: Color(0xFF00E676), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Korumayı aktif etmek ve tüm özellikleri kullanmak için son adıma geçin.',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
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
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
