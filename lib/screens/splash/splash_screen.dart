import 'dart:async';
import 'package:flutter/material.dart';
import '../../l10n/app_strings.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback? onFinish;
  final Duration minDuration;
  final String? languageCode;

  const SplashScreen({
    super.key,
    this.onFinish,
    this.minDuration = const Duration(milliseconds: 1400),
    this.languageCode,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.4, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.75), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    // Ensure minimum display time then proceed
    Timer(widget.minDuration, () {
      if (mounted && widget.onFinish != null) {
        widget.onFinish!();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF010A0E),
      body: Stack(
        children: [
          // Ambient deep radial background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.1),
                  radius: 1.2,
                  colors: [
                    Color(0xFF062025),
                    Color(0xFF010A0E),
                    Colors.black,
                  ],
                  stops: [0.0, 0.65, 1.0],
                ),
              ),
            ),
          ),

          // Center Content: Logo Emblem with Soft Vignetted Edge & Neon Ambience
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    final glowFactor = _glowAnimation.value;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Soft radial backlight behind the logo emblem
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF00E676).withValues(alpha: 0.30 * glowFactor),
                                    blurRadius: 55 * glowFactor,
                                    spreadRadius: 15 * glowFactor,
                                  ),
                                  BoxShadow(
                                    color: const Color(0xFF3BD6B4).withValues(alpha: 0.22 * glowFactor),
                                    blurRadius: 30 * glowFactor,
                                    spreadRadius: 5 * glowFactor,
                                  ),
                                ],
                              ),
                            ),

                            // Logo with soft edge feathering to seamlessly blend with background
                            ShaderMask(
                              shaderCallback: (rect) {
                                return const RadialGradient(
                                  center: Alignment.center,
                                  radius: 0.85,
                                  colors: [
                                    Colors.white,
                                    Colors.white,
                                    Colors.transparent,
                                  ],
                                  stops: [0.0, 0.72, 1.0],
                                ).createShader(rect);
                              },
                              blendMode: BlendMode.dstIn,
                              child: Image.asset(
                                'assets/images/app_logo.png',
                                width: 190,
                                height: 190,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.shield_rounded,
                                    size: 90,
                                    color: Color(0xFF00E676),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Nora Brand Typography
                        Text(
                          'N O R A',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 8.0,
                            shadows: [
                              Shadow(
                                color: const Color(0xFF00E676).withValues(alpha: 0.45 * glowFactor),
                                blurRadius: 12 * glowFactor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // "YENİ BİR SEN" Tagline & Tiny Loader at the Bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 48,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.get(widget.languageCode).isTr ? 'YENİ BİR SEN' : 'A NEW YOU',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.75),
                      letterSpacing: 3.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: const Color(0xFF00E676).withValues(alpha: 0.85),
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
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
}
