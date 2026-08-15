import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback? onFinish;
  final Duration minDuration;

  const SplashScreen({
    super.key,
    this.onFinish,
    this.minDuration = const Duration(milliseconds: 1400),
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
      backgroundColor: Colors.black, // Pure pitch-black background
      body: Stack(
        children: [
          // Center Content: Logo Artwork Glow (Alpha-masked directly from PNG, no rectangular box glow)
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    final glowFactor = _glowAnimation.value;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Soft outer neon glow following exact PNG logo pixels
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: 24 * glowFactor,
                            sigmaY: 24 * glowFactor,
                          ),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              const Color(0xFF00E676).withValues(alpha: 0.75 * glowFactor),
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              'assets/images/app_logo.png',
                              width: 175,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        // Sharper inner glow for extra neon radiance
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: 8 * glowFactor,
                            sigmaY: 8 * glowFactor,
                          ),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.white.withValues(alpha: 0.4 * glowFactor),
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              'assets/images/app_logo.png',
                              width: 175,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        // Crisp original logo image on top
                        Image.asset(
                          'assets/images/app_logo.png',
                          width: 175,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.shield_rounded,
                              size: 80,
                              color: Color(0xFF00E676),
                            );
                          },
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
                    'YENİ BİR SEN',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.75),
                      letterSpacing: 3.0,
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
