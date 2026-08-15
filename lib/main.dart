import 'package:flutter/material.dart';
import 'providers/app_state.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_flow.dart';
import 'screens/paywall/paywall_screen.dart';
import 'screens/dashboard/main_dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NoraApp());
}

class NoraApp extends StatefulWidget {
  const NoraApp({super.key});

  @override
  State<NoraApp> createState() => _NoraAppState();
}

class _NoraAppState extends State<NoraApp> {
  late final AppState _appState;
  bool _forceShowPaywall = false;
  bool _isSplashFinished = false;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, child) {
        Widget content;

        if (!_isSplashFinished || _appState.isLoading) {
          content = SplashScreen(
            key: const ValueKey('splash'),
            onFinish: () {
              if (mounted) {
                setState(() {
                  _isSplashFinished = true;
                });
              }
            },
          );
        } else if (_forceShowPaywall) {
          content = PaywallScreen(
            key: const ValueKey('paywall_force'),
            onSubscribeSuccess: (plan) {
              _appState.activateSubscription(plan: plan);
              setState(() {
                _forceShowPaywall = false;
              });
            },
            onBack: () {
              setState(() {
                _forceShowPaywall = false;
              });
            },
          );
        } else if (!_appState.isOnboarded) {
          content = OnboardingFlow(
            key: const ValueKey('onboarding'),
            onComplete: (profile) async {
              await _appState.saveUserProfile(profile);
            },
          );
        } else if (!_appState.isSubscribed) {
          content = PaywallScreen(
            key: const ValueKey('paywall'),
            onSubscribeSuccess: (plan) {
              _appState.activateSubscription(plan: plan);
            },
          );
        } else {
          content = MainDashboard(
            key: const ValueKey('dashboard'),
            appState: _appState,
            onOpenPaywall: () {
              setState(() {
                _forceShowPaywall = true;
              });
            },
          );
        }

        return MaterialApp(
          title: 'Nora - Kumarı Bırak & Paran Sakla',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0B1120),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF00E676),
              secondary: Color(0xFF6366F1),
              surface: Color(0xFF1E293B),
              error: Color(0xFFEF4444),
            ),
            fontFamily: 'Roboto',
          ),
          home: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: content,
          ),
        );
      },
    );
  }
}

