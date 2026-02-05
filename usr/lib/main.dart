import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Added for iOS optimization
import 'dart:io' show Platform; // Added for platform detection

import 'package:couldai_user_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // iOS optimization: Use CupertinoApp on iOS for native look and feel
    if (Platform.isIOS) {
      return CupertinoApp(
        title: 'Coffee Finder',
        debugShowCheckedModeBanner: false,
        theme: const CupertinoThemeData(
          primaryColor: CupertinoColors.systemBrown,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
        },
      );
    } else {
      // Android and other platforms use MaterialApp
      return MaterialApp(
        title: 'Coffee Finder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.brown,
            primary: Colors.brown[700],
            secondary: Colors.amber,
          ),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.brown[700],
            foregroundColor: Colors.white,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
        },
      );
    }
  }
}
