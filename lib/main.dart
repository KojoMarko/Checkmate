import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'auth_service.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'dashboard_screen.dart';
import 'forgot_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final bool loggedIn = authService.user != null;
        final bool loggingIn = state.matchedLocation == '/';
        final bool signingUp = state.matchedLocation == '/signup';
        final bool resettingPassword = state.matchedLocation == '/forgot-password';

        if (!loggedIn && !loggingIn && !signingUp && !resettingPassword) {
          return '/';
        }

        if (loggedIn && (loggingIn || signingUp)) {
          return '/dashboard';
        }

        return null;
      },
      refreshListenable: authService,
    );

    return MaterialApp.router(
      title: 'CheckMate',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final baseTheme = ThemeData(brightness: brightness);
    final isDark = brightness == Brightness.dark;

    final primaryColor = isDark ? Colors.white : const Color(0xFF424242);
    const accentColor = Color(0xFFD32F2F);
    final backgroundColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);

    final textTheme = GoogleFonts.ralewayTextTheme(baseTheme.textTheme).apply(
      bodyColor: primaryColor,
      displayColor: primaryColor,
    );

    return baseTheme.copyWith(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: textTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: brightness,
        primary: primaryColor,
        secondary: accentColor,
        error: accentColor,
        surface: backgroundColor, // Fixed: Replaced background with surface
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: primaryColor.withAlpha(77)), // Fixed: withOpacity(0.3)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: primaryColor.withAlpha(77)), // Fixed: withOpacity(0.3)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
        labelStyle: TextStyle(color: primaryColor.withAlpha(179)), // Fixed: withOpacity(0.7)
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: isDark ? Colors.black : Colors.white,
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          textStyle: GoogleFonts.raleway(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: GoogleFonts.raleway(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
