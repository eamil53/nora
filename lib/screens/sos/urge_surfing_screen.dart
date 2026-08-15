import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/app_state.dart';

class UrgeSurfingScreen extends StatefulWidget {
  final AppState appState;

  const UrgeSurfingScreen({super.key, required this.appState});

  @override
  State<UrgeSurfingScreen> createState() => _UrgeSurfingScreenState();
}

class _UrgeSurfingScreenState extends State<UrgeSurfingScreen> with TickerProviderStateMixin {
  // Breathing animation states
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  String _breathPhaseText = 'Nefes Al (4 sn)';
  bool _isBreathingActive = false;
  Timer? _breathTimer;

  // Impulse 15-min Timer
  static const int _initialSeconds = 15 * 60;
  int _remainingSeconds = _initialSeconds;
  Timer? _impulseTimer;
  bool _isImpulseTimerRunning = false;

  @override
  void initState() {
    super.initState();

    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.45).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
  }

  void _startBreathing() {
    setState(() {
      _isBreathingActive = true;
    });

    _cycleBreathingPhase();
  }

  void _cycleBreathingPhase() {
    if (!_isBreathingActive) return;

    // Phase 1: Inhale (4s)
    setState(() => _breathPhaseText = 'Nefes Al (4 saniye)');
    _breathingController.forward(from: 0.0);

    _breathTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted || !_isBreathingActive) return;

      // Phase 2: Hold (7s)
      setState(() => _breathPhaseText = 'Nefesini Tut (7 saniye)');

      _breathTimer = Timer(const Duration(seconds: 7), () {
        if (!mounted || !_isBreathingActive) return;

        // Phase 3: Exhale (8s)
        setState(() => _breathPhaseText = 'Yavaşça Ver (8 saniye)');
        _breathingController.reverse();

        _breathTimer = Timer(const Duration(seconds: 8), () {
          if (!mounted || !_isBreathingActive) return;
          _cycleBreathingPhase();
        });
      });
    });
  }

  void _stopBreathing() {
    _breathTimer?.cancel();
    _breathingController.stop();
    setState(() {
      _isBreathingActive = false;
      _breathPhaseText = 'Hazır olduğunuzda başlatın';
    });
  }

  void _toggleImpulseTimer() {
    if (_isImpulseTimerRunning) {
      _impulseTimer?.cancel();
      setState(() {
        _isImpulseTimerRunning = false;
      });
    } else {
      setState(() {
        _isImpulseTimerRunning = true;
      });
      _impulseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          timer.cancel();
          setState(() {
            _isImpulseTimerRunning = false;
          });
          _showVictoryDialog();
        }
      });
    }
  }

  void _resetImpulseTimer() {
    _impulseTimer?.cancel();
    setState(() {
      _remainingSeconds = _initialSeconds;
      _isImpulseTimerRunning = false;
    });
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('🎉 KRİZİ AŞTINIZ!', style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold)),
        content: const Text(
          'Tebrikler! 15 dakikalık istek dalgasını başarıyla atlattınız. İradeniz cebinizdeki parayı korudu.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text('Harika!', style: TextStyle(color: Color(0xFF00E676))),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(scheme: 'tel', path: '115');
    try {
      final launched = await launchUrl(launchUri);
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Arama başlatılamadı. Lütfen 115 numaralı YEDAM hattını doğrudan telefonunuzdan tuşlayın.'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Arama başlatılamadı. Lütfen 115 numaralı YEDAM hattını doğrudan telefonunuzdan tuşlayın.'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _showCallDialog() {
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
                  color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone_in_talk_rounded, color: Color(0xFFEF4444), size: 48),
              ),
              const SizedBox(height: 16),
              const Text(
                'YEDAM Ücretsiz Destek Hattı',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Yeşilay Danışmanlık Merkezi (115) 7/24 ücretsiz ve tamamen gizli kumar bağımlılığı uzman desteği sunar.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.call),
                  label: const Text('115\'i Şimdi Ara (Ücretsiz)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.pop(context);
                    _makePhoneCall();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _breathTimer?.cancel();
    _impulseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.appState.userProfile;
    final savedMoney = profile.calculateSavedMoney();

    final minutes = (_remainingSeconds / 60).floor();
    final seconds = _remainingSeconds % 60;
    final formattedTime = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1120),
        elevation: 0,
        title: const Text('🚨 Kriz & SOS Modu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Top Emergency Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7F1D1D), Color(0xFFEF4444)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 40),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Oynama İsteği mi Geldi?', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        Text('Sakin olun. Kumar dürtüsü dalga gibidir; 15 dakikada geçer.', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4-7-8 Breathing Guidance Visualizer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  const Text(
                    '4-7-8 Sakinleşme Nefesi',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _breathPhaseText,
                    style: const TextStyle(color: Color(0xFF6366F1), fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 28),

                  // Animated Circle
                  ScaleTransition(
                    scale: _breathingAnimation,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF6366F1).withValues(alpha: 0.8),
                            const Color(0xFF00E676).withValues(alpha: 0.4),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                            blurRadius: 25,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.air_rounded, color: Colors.white, size: 50),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isBreathingActive ? const Color(0xFFEF4444) : const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: Icon(_isBreathingActive ? Icons.stop : Icons.play_arrow_rounded),
                    label: Text(_isBreathingActive ? 'Egzersizi Durdur' : 'Nefes Egzersizini Başlat'),
                    onPressed: () {
                      if (_isBreathingActive) {
                        _stopBreathing();
                      } else {
                        _startBreathing();
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 15-Minute Impulse Counter Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  const Text('15 Dakikalık İstek Erteleme Sayacı', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('İstek anında 15 dakika hiçbir şey yapmadan bekleyin.', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 16),
                  Text(
                    formattedTime,
                    style: const TextStyle(color: Color(0xFF00E676), fontSize: 44, fontWeight: FontWeight.w800, letterSpacing: 2),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00E676),
                          foregroundColor: const Color(0xFF0B1120),
                        ),
                        icon: Icon(_isImpulseTimerRunning ? Icons.pause : Icons.play_arrow),
                        label: Text(_isImpulseTimerRunning ? 'Duraklat' : 'Sayacı Başlat'),
                        onPressed: _toggleImpulseTimer,
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white70),
                        onPressed: _resetImpulseTimer,
                        child: const Text('Sıfırla'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Financial Reality Check Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.psychology_rounded, color: Color(0xFFF59E0B)),
                      SizedBox(width: 10),
                      Text('Finansal Gerçeklik Kontrolü', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Şu ana kadar başardığınız korunan miktar: ₺${savedMoney.toStringAsFixed(0)}',
                    style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Hedef Motivasyonunuz: "${profile.mainMotivation}"',
                    style: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Emergency Call Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
                icon: const Icon(Icons.phone_rounded, size: 24),
                label: const Text('YEDAM 115 Ücretsiz Destek Hattını Ara', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: _makePhoneCall,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
