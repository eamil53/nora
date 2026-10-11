import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/app_state.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_flow.dart';
import 'screens/paywall/paywall_screen.dart';
import 'screens/dashboard/main_dashboard.dart';
import 'services/firebase_service.dart';
import 'services/purchase_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  await PurchaseService.instance.initialize();
  runApp(const NoraApp());
}

class NoraApp extends StatefulWidget {
  const NoraApp({super.key});

  @override
  State<NoraApp> createState() => _NoraAppState();
}

class _NoraAppState extends State<NoraApp> with WidgetsBindingObserver {
  late final AppState _appState;
  bool _forceShowPaywall = false;
  bool _isSplashFinished = false;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
    WidgetsBinding.instance.addObserver(this);

    // Deep link routing when user clicks a notification targeting paywall
    FirebaseService.onNotificationAction = (data) {
      final screen = data['screen'];
      if (screen == 'paywall') {
        if (!_appState.isSubscribed) {
          // If user drops off during onboarding, direct them to paywall on click
          if (!_appState.isOnboarded && mounted) {
            setState(() {
              _forceShowPaywall = true;
            });
          }
        } else if (_appState.isOnboarded && _appState.isSubscribed) {
          if (mounted) {
            setState(() {
              _forceShowPaywall = true;
            });
          }
        }
      }
    };

    // Check if app was launched directly by tapping a notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseService.checkInitialNotification();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      // If user exits/backgrounds app without starting a trial, schedule persuasive notification for 5 mins later
      if (!_appState.isSubscribed) {
        FirebaseService.scheduleAbandonedTrialNotification(
          languageCode: _appState.languageCode,
          delayMinutes: 5,
        );
      }
    } else if (state == AppLifecycleState.resumed) {
      // While user is actively using the app in foreground, cancel pending notification
      if (!_appState.isSubscribed) {
        FirebaseService.cancelAbandonedTrialNotification();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _appState.dispose();
    super.dispose();
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
            languageCode: _appState.languageCode,
            onFinish: () {
              if (mounted) {
                setState(() {
                  _isSplashFinished = true;
                });
                // Request notification permission after splash screen finishes and first screen renders
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  FirebaseService.requestNotificationPermissions();
                  if (!_appState.isSubscribed) {
                    FirebaseService.scheduleAbandonedTrialNotification(
                      languageCode: _appState.languageCode,
                      delayMinutes: 5,
                    );
                  }
                });
              }
            },
          );
        } else if (!_appState.isOnboarded) {
          content = OnboardingFlow(
            key: const ValueKey('onboarding'),
            languageCode: _appState.languageCode,
            onComplete: (profile) async {
              await _appState.saveUserProfile(profile);
            },
          );
        } else if (!_appState.isSubscribed) {
          content = PaywallScreen(
            key: const ValueKey('paywall'),
            languageCode: _appState.languageCode,
            monthlySpend: _appState.userProfile.monthlySpend,
            currencySymbol: _appState.userProfile.currencySymbol,
            onSubscribeSuccess: (plan) {
              _appState.activateSubscription(plan: plan);
            },
          );
        } else if (_forceShowPaywall) {
          content = PaywallScreen(
            key: const ValueKey('paywall_force'),
            languageCode: _appState.languageCode,
            monthlySpend: _appState.userProfile.monthlySpend,
            currencySymbol: _appState.userProfile.currencySymbol,
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
          title: _appState.strings.isTr
              ? 'Nora - Kumarı Bırak & Paran Sakla'
              : 'Nora - Quit Gambling & Save Money',
          debugShowCheckedModeBanner: false,
          locale: _appState.locale,
          supportedLocales: const [
            Locale('tr'),
            Locale('en'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _appState.themeMode,
          builder: (context, child) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final overlayStyle = SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              // On iOS:
              // Brightness.light means dark icons (black clock, battery, wifi)
              // Brightness.dark means light icons (white clock, battery, wifi)
              statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
              // On Android:
              // Brightness.dark means dark icons
              // Brightness.light means light icons
              statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
              systemNavigationBarColor: isDark ? const Color(0xFF070A12) : const Color(0xFFF4F6F9),
              systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
              systemNavigationBarDividerColor: Colors.transparent,
            );

            // Also synchronize immediately with SystemChrome
            SystemChrome.setSystemUIOverlayStyle(overlayStyle);

            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: overlayStyle,
              child: child ?? const SizedBox.shrink(),
            );
          },
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

