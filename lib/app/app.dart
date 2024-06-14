import 'package:flutter/material.dart';
import 'package:personal_expenses/app/screens/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData();
    return MaterialApp(
      title: 'Personal Expenses',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: const Color(0xFF2D9E64),
          secondary: Colors.redAccent,
        ),
        textTheme: theme.textTheme.copyWith(
          titleLarge: const TextStyle(
            fontSize: 23,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: const TextStyle(
            fontSize: 22,
            color: Colors.black,
          ),
          labelLarge: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          labelMedium: const TextStyle(
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          labelSmall: const TextStyle(
            fontSize: 17,
            color: Color(0xFF656066),
            // fontWeight: FontWeight.bold,
          ),
          titleSmall: const TextStyle(
            color: Color(0xFF656066),
          ),
        ),
        appBarTheme: theme.appBarTheme.copyWith(
          backgroundColor: const Color(0xFFE9E9E9),
        ),
        scaffoldBackgroundColor: const Color(0xFFE9E9E9),
      ),
      home: const Home(),
    );
  }
}
