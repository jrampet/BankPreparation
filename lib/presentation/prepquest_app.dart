import 'package:flutter/material.dart';

import '../domain/progress_controller.dart';
import 'screens/onboarding_screen.dart';
import 'screens/shell_screen.dart';

class PrepQuestApp extends StatefulWidget {
  const PrepQuestApp({required this.controller, super.key});

  final ProgressController controller;

  @override
  State<PrepQuestApp> createState() => _PrepQuestAppState();
}

class _PrepQuestAppState extends State<PrepQuestApp> {
  bool _isDark = false;

  void _toggleTheme() => setState(() => _isDark = !_isDark);

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF5C58E8);
    final lightScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
      surface: const Color(0xFFF7F7FC),
    );
    final darkScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF9A97FF),
      brightness: Brightness.dark,
      surface: const Color(0xFF171827),
    );
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) => MaterialApp(
        title: 'PrepQuest',
        debugShowCheckedModeBanner: false,
        themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
        theme: _buildTheme(lightScheme),
        darkTheme: _buildTheme(darkScheme),
        home: widget.controller.progress.examId == null
            ? OnboardingScreen(controller: widget.controller)
            : PrepShell(
                controller: widget.controller,
                isDark: _isDark,
                onThemeToggle: _toggleTheme,
              ),
      ),
    );
  }

  ThemeData _buildTheme(ColorScheme scheme) => ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: scheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    ),
    cardTheme: CardThemeData(
      color: scheme.brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF222337),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: .5)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest.withValues(alpha: .55),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF222337),
      indicatorColor: scheme.primary.withValues(alpha: .13),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 11,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
  );
}
