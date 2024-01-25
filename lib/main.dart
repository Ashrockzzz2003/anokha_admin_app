import 'package:anokha_admin/auth/login_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AnokhaAdmin());
}

class AnokhaAdmin extends StatelessWidget {
  const AnokhaAdmin({super.key});

  static final _defaultLightColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.lightBlueAccent,
    brightness: Brightness.dark,
  );

  static final _defaultDarkColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.lightBlueAccent,
    brightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Anokha Admin",
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme ?? _defaultLightColorScheme,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
          ),
          themeMode: ThemeMode.system,
          home: const LoginScreen(),
        );
      },
    );
  }
}
