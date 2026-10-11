import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_strings.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';

class UrgeSurfingScreen extends StatefulWidget {
  final AppState appState;

  const UrgeSurfingScreen({super.key, required this.appState});

  @override
  State<UrgeSurfingScreen> createState() => _UrgeSurfingScreenState();
}

class _UrgeSurfingScreenState extends State<UrgeSurfingScreen> with TickerProviderStateMixin {
  // Selected SOS Tool: 0 = 4-7-8 Breathing, 1 = Urge Surfing (15 min), 2 = Reality Anchor
  int _selectedToolIndex = 0;

  AppStrings get s => widget.appState.strings;

  // Breathing animation states
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  int _currentPhase = 0; // 0: Inhale (4s), 1: Hold (7s), 2: Exhale (8s)
  bool _isBreathingActive = false;
  Timer? _breathTimer;

  String get _breathPhaseTitle {
    if (!_isBreathingActive) return s.breathReady;
    switch (_currentPhase) {
      case 0:
        return s.breathInhale;
      case 1:
        return s.breathHold;
      case 2:
      default:
        return s.breathExhale;
    }
  }

  String get _breathPhaseSubtitle {
    if (!_isBreathingActive) return s.breathReadyDesc;
    switch (_currentPhase) {
      case 0:
        return s.breathInhaleDesc;
      case 1:
        return s.breathHoldDesc;
      case 2:
      default:
        return s.breathExhaleDesc;
    }
  }

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

    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOutCubic),
    );
  }

  void _startBreathing() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isBreathingActive = true;
    });

    _cycleBreathingPhase();
  }

  void _cycleBreathingPhase() {
    if (!_isBreathingActive) return;

    // Phase 1: Inhale (4s)
    HapticFeedback.selectionClick();
    setState(() {
      _currentPhase = 0;
    });
    _breathingController.duration = const Duration(seconds: 4);
    _breathingController.forward(from: 0.0);

    _breathTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted || !_isBreathingActive) return;

      // Phase 2: Hold (7s)
      HapticFeedback.selectionClick();
      setState(() {
        _currentPhase = 1;
      });

      _breathTimer = Timer(const Duration(seconds: 7), () {
        if (!mounted || !_isBreathingActive) return;

        // Phase 3: Exhale (8s)
        HapticFeedback.selectionClick();
        setState(() {
          _currentPhase = 2;
        });
        _breathingController.duration = const Duration(seconds: 8);
        _breathingController.reverse();

        _breathTimer = Timer(const Duration(seconds: 8), () {
          if (!mounted || !_isBreathingActive) return;
          _cycleBreathingPhase();
        });
      });
    });
  }

  void _stopBreathing() {
    HapticFeedback.lightImpact();
    _breathTimer?.cancel();
    _breathingController.stop();
    setState(() {
      _isBreathingActive = false;
      _currentPhase = 0;
    });
  }

  void _toggleImpulseTimer() {
    HapticFeedback.mediumImpact();
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
    HapticFeedback.selectionClick();
    _impulseTimer?.cancel();
    setState(() {
      _remainingSeconds = _initialSeconds;
      _isImpulseTimerRunning = false;
    });
  }

  void _showVictoryDialog() {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: const Color(0xFF00E676).withValues(alpha: 0.4), width: 1.5),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF00E676).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(CupertinoIcons.checkmark_seal_fill, color: Color(0xFF00E676), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                s.urgeVictoryTitle,
                style: GoogleFonts.outfit(color: context.colors.textPrimary, fontWeight: FontWeight.w800, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.urgeVictoryBody,
              style: GoogleFonts.plusJakartaSans(color: context.colors.textSecondary, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF00E676).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.shield_lefthalf_fill, color: Color(0xFF00E676), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      s.urgeVictoryShield,
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF00E676),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E676),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(s.urgeVictoryButton, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
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
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            backgroundColor: const Color(0xFFEF4444),
            content: Text(
              s.callError,
              style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            backgroundColor: const Color(0xFFEF4444),
            content: Text(
              s.callError,
              style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        );
      }
    }
  }

  void _showCallDialog() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.surfaceCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Grabber handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // Icon
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                  ),
                  child: const Icon(CupertinoIcons.phone_fill, color: Color(0xFFEF4444), size: 36),
                ),
                const SizedBox(height: 16),

                Text(
                  s.callModalTitle,
                  style: GoogleFonts.outfit(color: context.colors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  s.callModalDesc,
                  style: GoogleFonts.plusJakartaSans(color: context.colors.textSecondary, fontSize: 13, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Features list
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceCardAlt,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: Column(
                    children: [
                      _buildCallInfoRow(CupertinoIcons.lock_shield_fill, s.callModalFeat1),
                      const SizedBox(height: 8),
                      _buildCallInfoRow(CupertinoIcons.clock_fill, s.callModalFeat2),
                      const SizedBox(height: 8),
                      _buildCallInfoRow(CupertinoIcons.checkmark_alt_circle_fill, s.callModalFeat3),
                    ],
                  ),
                ),

                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                    ),
                    icon: const Icon(CupertinoIcons.phone_fill, size: 20),
                    label: Text(
                      s.callModalBtn,
                      style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _makePhoneCall();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCallInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF00E676), size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(color: context.colors.textPrimary, fontSize: 12),
          ),
        ),
      ],
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
    final daysClean = profile.calculateDaysClean();

    return Scaffold(
      backgroundColor: context.colors.surfaceCanvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Header Bar
            _buildTopHeader(),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                child: Column(
                  children: [
                    // Emergency Crisis Hero Banner
                    _buildEmergencyHeroCard(),

                    const SizedBox(height: 18),

                    // Tool Selector Tabs
                    _buildToolSelector(),

                    const SizedBox(height: 20),

                    // Active Tool Card
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(anim),
                          child: child,
                        ),
                      ),
                      child: _buildCurrentTool(profile, savedMoney, daysClean),
                    ),

                    const SizedBox(height: 20),

                    // Persistent 115 Hotline Banner
                    _buildHotlineCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TOP HEADER ---
  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: context.colors.surfaceCanvas,
        border: Border(bottom: BorderSide(color: context.colors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                  ),
                  child: const Icon(CupertinoIcons.shield_fill, color: Color(0xFFEF4444), size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.sosHeaderTitle,
                        style: GoogleFonts.outfit(
                          color: context.colors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        s.sosHeaderSub,
                        style: GoogleFonts.plusJakartaSans(
                          color: context.colors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Emergency Call Quick Button
          GestureDetector(
            onTap: _showCallDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(CupertinoIcons.phone_fill, color: Colors.white, size: 12),
                  const SizedBox(width: 6),
                  Text(
                    s.sosCallQuick,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HERO CARD ---
  Widget _buildEmergencyHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFEF4444).withValues(alpha: 0.15),
            const Color(0xFF6366F1).withValues(alpha: 0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(CupertinoIcons.exclamationmark_shield_fill, color: Color(0xFFEF4444), size: 26)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.15, 1.15), duration: 900.ms),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.sosEmergencyTitle,
                  style: GoogleFonts.outfit(
                    color: context.colors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  s.sosEmergencySubtitle,
                  style: GoogleFonts.plusJakartaSans(
                    color: context.colors.textSecondary,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TOOL SELECTOR SEGMENT ---
  Widget _buildToolSelector() {
    final tools = [
      {'title': s.toolBreathing, 'icon': CupertinoIcons.wind},
      {'title': s.toolUrgeSurfing, 'icon': CupertinoIcons.waveform_path},
      {'title': s.toolGrounding, 'icon': Icons.anchor_rounded},
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.colors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: List.generate(tools.length, (index) {
          final isSelected = _selectedToolIndex == index;
          final tool = tools[index];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => _selectedToolIndex = index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? context.colors.surfaceCardAlt : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.4))
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: context.colors.isDark ? 0.3 : 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tool['icon'] as IconData,
                      color: isSelected ? const Color(0xFF00E676) : context.colors.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tool['title'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        color: isSelected ? context.colors.textPrimary : context.colors.textSecondary,
                        fontSize: 10.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // --- CURRENT TOOL BUILDER ---
  Widget _buildCurrentTool(dynamic profile, double savedMoney, int daysClean) {
    switch (_selectedToolIndex) {
      case 0:
        return _buildBreathingTool();
      case 1:
        return _buildImpulseSurfingTool();
      case 2:
      default:
        return _buildRealityAnchorTool(profile, savedMoney, daysClean);
    }
  }

  // --- TOOL 1: 4-7-8 BREATHING ENGINE ---
  Widget _buildBreathingTool() {
    Color phaseColor;
    switch (_currentPhase) {
      case 0:
        phaseColor = const Color(0xFF6366F1); // Inhale
        break;
      case 1:
        phaseColor = const Color(0xFFF59E0B); // Hold
        break;
      case 2:
      default:
        phaseColor = const Color(0xFF00E676); // Exhale
        break;
    }

    return Container(
      key: const ValueKey(0),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: context.colors.surfaceCard,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: context.colors.border),
        boxShadow: context.colors.cardShadows,
      ),
      child: Column(
        children: [
          // Phase Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: phaseColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: phaseColor.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: phaseColor, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(
                  _breathPhaseTitle,
                  style: GoogleFonts.outfit(
                    color: phaseColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Text(
            _breathPhaseSubtitle,
            style: GoogleFonts.plusJakartaSans(
              color: context.colors.textSecondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Central Pulsing Orb
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer Halo
              ScaleTransition(
                scale: _breathingAnimation,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        phaseColor.withValues(alpha: 0.25),
                        phaseColor.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              // Main Orb
              ScaleTransition(
                scale: _breathingAnimation,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        phaseColor.withValues(alpha: 0.9),
                        phaseColor.withValues(alpha: 0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: phaseColor.withValues(alpha: 0.5),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _isBreathingActive ? CupertinoIcons.wind : CupertinoIcons.play_arrow_solid,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Step timeline indicators (4s - 7s - 8s)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPhasePill(s.breathPillInhale, 0, _currentPhase == 0 && _isBreathingActive),
              _buildPhasePill(s.breathPillHold, 1, _currentPhase == 1 && _isBreathingActive),
              _buildPhasePill(s.breathPillExhale, 2, _currentPhase == 2 && _isBreathingActive),
            ],
          ),

          const SizedBox(height: 24),

          // Start / Stop Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isBreathingActive ? const Color(0xFFEF4444) : const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
              ),
              icon: Icon(_isBreathingActive ? CupertinoIcons.stop_fill : CupertinoIcons.play_fill, size: 18),
              label: Text(
                _isBreathingActive ? s.breathStop : s.breathStart,
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 14),
              ),
              onPressed: () {
                if (_isBreathingActive) {
                  _stopBreathing();
                } else {
                  _startBreathing();
                }
              },
            ),
          ),

          const SizedBox(height: 14),
          Text(
            s.breathScience,
            style: GoogleFonts.plusJakartaSans(color: context.colors.textSecondary, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPhasePill(String title, int phaseIndex, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? (context.colors.isDark ? Colors.white.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.08))
            : (context.colors.isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03)),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? context.colors.textPrimary : context.colors.border,
          width: isActive ? 1.5 : 1.0,
        ),
      ),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          color: isActive ? context.colors.textPrimary : context.colors.textSecondary,
          fontSize: 11,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }

  // --- TOOL 2: 15-MINUTE IMPULSE SURFING ---
  Widget _buildImpulseSurfingTool() {
    final minutes = (_remainingSeconds / 60).floor();
    final seconds = _remainingSeconds % 60;
    final formattedTime = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    final progress = (_initialSeconds - _remainingSeconds) / _initialSeconds;

    // Stage calculation
    String stageName;
    String stageDescription;
    Color stageColor;
    if (_remainingSeconds > 10 * 60) {
      stageName = s.urgeStage1Title;
      stageDescription = s.urgeStage1Desc;
      stageColor = const Color(0xFFF59E0B);
    } else if (_remainingSeconds > 5 * 60) {
      stageName = s.urgeStage2Title;
      stageDescription = s.urgeStage2Desc;
      stageColor = const Color(0xFFEF4444);
    } else {
      stageName = s.urgeStage3Title;
      stageDescription = s.urgeStage3Desc;
      stageColor = const Color(0xFF00E676);
    }

    return Container(
      key: const ValueKey(1),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: context.colors.surfaceCard,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: context.colors.border),
        boxShadow: context.colors.cardShadows,
      ),
      child: Column(
        children: [
          Text(
            s.urgeSurfingTitle,
            style: GoogleFonts.outfit(color: context.colors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            s.urgeSurfingSub,
            style: GoogleFonts.plusJakartaSans(color: context.colors.textSecondary, fontSize: 11.5),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 28),

          // Circular Progress Clock
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 170,
                height: 170,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 10,
                  backgroundColor: context.colors.isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
                  valueColor: AlwaysStoppedAnimation<Color>(stageColor),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formattedTime,
                    style: GoogleFonts.outfit(
                      color: context.colors.textPrimary,
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    s.urgePercentCompleted((progress * 100).toInt()),
                    style: GoogleFonts.plusJakartaSans(
                      color: stageColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Stage Info Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: stageColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: stageColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(CupertinoIcons.waveform_path, color: stageColor, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stageName,
                        style: GoogleFonts.plusJakartaSans(
                          color: stageColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        stageDescription,
                        style: GoogleFonts.plusJakartaSans(color: context.colors.textSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // Controls
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isImpulseTimerRunning ? const Color(0xFFF59E0B) : const Color(0xFF00E676),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                    ),
                    icon: Icon(
                      _isImpulseTimerRunning ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                      size: 18,
                    ),
                    label: Text(
                      _isImpulseTimerRunning ? s.pauseTimer : s.startTimer,
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                    onPressed: _toggleImpulseTimer,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.colors.textSecondary,
                      side: BorderSide(color: context.colors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _resetImpulseTimer,
                    child: Text(
                      s.resetTimer,
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TOOL 3: REALITY ANCHOR ---
  Widget _buildRealityAnchorTool(dynamic profile, double savedMoney, int daysClean) {
    return Container(
      key: const ValueKey(2),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: context.colors.surfaceCard,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: context.colors.border),
        boxShadow: context.colors.cardShadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.anchor_rounded, color: Color(0xFFF59E0B), size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                s.realityAnchorTitle,
                style: GoogleFonts.outfit(color: context.colors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            s.realityAnchorSub,
            style: GoogleFonts.plusJakartaSans(color: context.colors.textSecondary, fontSize: 11.5),
          ),

          const SizedBox(height: 18),

          // 2 Stats Grid
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E676).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(CupertinoIcons.money_dollar_circle_fill, color: Color(0xFF00E676), size: 16),
                          const SizedBox(width: 6),
                          Text(
                            s.anchorSavedMoney,
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF00E676),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '₺${savedMoney.toStringAsFixed(0)}',
                        style: GoogleFonts.outfit(
                          color: context.colors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(CupertinoIcons.calendar, color: Color(0xFF6366F1), size: 16),
                          const SizedBox(width: 6),
                          Text(
                            s.anchorDaysClean,
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF6366F1),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        s.cleanDaysCount(daysClean),
                        style: GoogleFonts.outfit(
                          color: context.colors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Motivation Quote Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.surfaceCardAlt,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(CupertinoIcons.quote_bubble_fill, color: Color(0xFFF59E0B), size: 16),
                    const SizedBox(width: 8),
                    Text(
                      s.anchorStartingPromise,
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFFF59E0B),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  profile.mainMotivation.toString().isNotEmpty
                      ? '"${profile.mainMotivation}"'
                      : s.profileDefaultMotivation,
                  style: GoogleFonts.plusJakartaSans(
                    color: context.colors.textPrimary,
                    fontSize: 13.5,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Grounding 5-4-3-2-1 Quick Checklist
          Text(
            s.groundingChecklistTitle,
            style: GoogleFonts.plusJakartaSans(color: context.colors.textSecondary, fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          _buildGroundingItem('5', s.grounding5),
          _buildGroundingItem('4', s.grounding4),
          _buildGroundingItem('3', s.grounding3),
          _buildGroundingItem('2', s.grounding2),
          _buildGroundingItem('1', s.grounding1),
        ],
      ),
    );
  }

  Widget _buildGroundingItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: context.colors.surfaceCardAlt,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.outfit(color: context.colors.textPrimary, fontSize: 10, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(color: context.colors.textSecondary, fontSize: 11.5),
            ),
          ),
        ],
      ),
    );
  }

  // --- PERSISTENT YEDAM 115 BANNER ---
  Widget _buildHotlineCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colors.surfaceCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.25)),
        boxShadow: context.colors.cardShadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(CupertinoIcons.phone_badge_plus, color: Color(0xFFEF4444), size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s.hotlineBannerTitle,
                        style: GoogleFonts.outfit(color: context.colors.textPrimary, fontSize: 15, fontWeight: FontWeight.w800),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF00E676).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  s.hotline247,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF00E676),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            s.hotlineBannerDesc,
            style: GoogleFonts.plusJakartaSans(color: context.colors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 3,
              ),
              icon: const Icon(CupertinoIcons.phone_fill, size: 18),
              label: Text(
                s.hotlineBannerBtn,
                style: GoogleFonts.plusJakartaSans(fontSize: 13.5, fontWeight: FontWeight.w800),
              ),
              onPressed: _showCallDialog,
            ),
          ),
        ],
      ),
    );
  }
}
