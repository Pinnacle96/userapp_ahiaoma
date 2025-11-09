import 'package:flutter/material.dart';

const Color _kDefaultPrimary = Color(0xFF107A2B); // Forest Green
const Color _kDefaultSecondary = Color(0xFFD4A124); // Yellow

ThemeData light({Color? primaryColor, Color? secondaryColor}) {
  final Color primary = primaryColor ?? _kDefaultPrimary;
  final Color secondary = secondaryColor ?? _kDefaultSecondary;

  return ThemeData(
    fontFamily: 'TitilliumWeb',
    primaryColor: primary,
    brightness: Brightness.light,
    highlightColor: Colors.white,
    hintColor: const Color(0xFFA7A7A7), // Border Color
    splashColor: Colors.transparent,
    cardColor: Colors.white,
    scaffoldBackgroundColor: const Color(0xFFF7F8FA),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF222324)),     // primary text
      bodyMedium: TextStyle(color: Color(0xFF222324)),    // secondary text
      bodySmall: TextStyle(color: Color(0xFFA7A7A7)),     // light grey
      titleMedium: TextStyle(color: Color(0xFF656566)),
    ),

    colorScheme: ColorScheme.light(
      primary: primary,                     // Primary Color
      secondary: secondary,                 // Secondary Color
      tertiary: const Color(0xFFFFBB38),    // Warning
      tertiaryContainer: const Color(0xFFADC9F3),
      onTertiaryContainer: const Color(0xFF04BB7B), // Success
      onPrimary: const Color(0xFF7FBBFF),
      surface: const Color(0xFFF4F8FF),
      onSecondary: secondary,
      error: const Color(0xFFFF4040), // Danger
      onSecondaryContainer: const Color(0xFFF3F9FF),
      outline: const Color(0xff5C8FFC), // Info
      onTertiary: const Color(0xFFE9F3FF),
      shadow: const Color(0xFF66717C),
      primaryContainer: const Color(0xFF9AECC6),
      secondaryContainer: const Color(0xFFE9EEF4),
    ),

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
        TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
      },
    ),
  );
}
