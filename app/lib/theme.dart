import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme() {
  ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.lightBlue, brightness: Brightness.light);

  ThemeData tmp = _baseTheme().copyWith(colorScheme: colorScheme);

  return tmp.copyWith(
    scaffoldBackgroundColor: colorScheme.surface,
    textTheme: tmp.textTheme.apply(
      bodyColor: colorScheme.onSurface,
    ),
    iconTheme: tmp.iconTheme.copyWith(color: colorScheme.onSurface),
    dialogTheme: tmp.dialogTheme.copyWith(
      backgroundColor: colorScheme.surface,
      titleTextStyle: tmp.dialogTheme.titleTextStyle
          ?.copyWith(color: colorScheme.onSurface),
    ),
  );
}

ThemeData darkTheme() {
  ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.lightBlue, brightness: Brightness.dark);

  ThemeData tmp = _baseTheme().copyWith(colorScheme: colorScheme);

  return tmp.copyWith(
    scaffoldBackgroundColor: colorScheme.surface,
    textTheme: tmp.textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    iconTheme: tmp.iconTheme.copyWith(color: colorScheme.onSurface),
    dialogTheme: tmp.dialogTheme.copyWith(
      backgroundColor: colorScheme.surface,
      titleTextStyle: tmp.dialogTheme.titleTextStyle
          ?.copyWith(color: colorScheme.onSurface),
    ),
  );
}

ThemeData _baseTheme() {
  ThemeData tmp = ThemeData.from(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(),
    textTheme: GoogleFonts.notoSansJpTextTheme(),
  );

  TextStyle notoSansJp = GoogleFonts.notoSansJp();

  return tmp.copyWith(
    textTheme: tmp.textTheme.copyWith(
      bodyLarge: notoSansJp.copyWith(fontSize: 22),
      bodyMedium: notoSansJp.copyWith(fontSize: 20),
      bodySmall: notoSansJp.copyWith(fontSize: 18),
      displayLarge: notoSansJp.copyWith(fontSize: 26),
      displayMedium: notoSansJp.copyWith(fontSize: 22),
      displaySmall: notoSansJp.copyWith(fontSize: 18),
      headlineLarge: notoSansJp.copyWith(fontSize: 26),
      headlineMedium: notoSansJp.copyWith(fontSize: 22),
      headlineSmall: notoSansJp.copyWith(fontSize: 18),
      labelLarge: notoSansJp.copyWith(fontSize: 26),
      labelMedium: notoSansJp.copyWith(fontSize: 22),
      labelSmall: notoSansJp.copyWith(fontSize: 18),
      titleLarge: notoSansJp.copyWith(fontSize: 26),
      titleMedium: notoSansJp.copyWith(fontSize: 24),
      titleSmall: notoSansJp.copyWith(fontSize: 22),
    ),
    dialogTheme: tmp.dialogTheme.copyWith(
      titleTextStyle: notoSansJp.copyWith(fontSize: 26),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        minimumSize: const Size(65, 65),
        textStyle: notoSansJp.copyWith(fontSize: 20),
      ),
    ),
    iconTheme: tmp.iconTheme.copyWith(size: 30),
  );
}
