// lib/theme/dark_theme.dart
import 'package:flutter/material.dart';

ThemeData dark({
  Color primaryColor   = const Color(0xFF107A2B), // Forest Green
  Color secondaryColor = const Color(0xFFD4A124), // Yellow
}) {
  return ThemeData(
    fontFamily: 'TitilliumWeb',
    primaryColor: primaryColor,
    brightness: Brightness.dark,
    highlightColor: const Color(0xFF252525),
    hintColor: const Color(0xFFc7c7c7),
    cardColor: const Color(0xFF242424),
    scaffoldBackgroundColor: const Color(0xFF000000),
    splashColor: Colors.transparent,

    textTheme: const TextTheme(
      bodyLarge:  TextStyle(color: Color(0xFFE9EEF4)),
      bodyMedium: TextStyle(color: Color(0xFFE9EEF4)),
      bodySmall:  TextStyle(color: Color(0xFFE9EEF4)),
    ),

    colorScheme: ColorScheme.dark(
      primary: primaryColor,               // <-- brand primary
      secondary: secondaryColor,           // <-- brand secondary
      tertiary: const Color(0xFFFFBB38),   // Warning
      tertiaryContainer: const Color(0xFF6C7A8E),
      surface: const Color(0xFF2D2D2D),
      onPrimary: const Color(0xFFB7D7FE),
      onTertiaryContainer: const Color(0xFF04BB7B), // Success
      primaryContainer: const Color(0xFF208458),
      onSecondaryContainer: const Color(0x912A2A2A),
      outline: const Color(0xff5C8FFC),    // Info
      onTertiary: const Color(0xFF545252),
      secondaryContainer: const Color(0xFFE9EEF4),
      surfaceContainer: const Color(0xFFFB6C4C),
      error: const Color(0xFFFF4040),      // Danger
      shadow: const Color(0xFFF4F7FC),
    ),

    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
    }),
  );
}
