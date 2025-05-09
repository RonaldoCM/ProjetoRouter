import 'package:flutter/material.dart';
import 'package:routerapp/screens/rota_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RouterApp',
      theme: appTheme, //ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: RotaScreen(),
    );
  }
}

ThemeData appTheme = ThemeData(
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.indigo,
    ),
    bodyMedium: TextStyle(fontSize: 18.0, color: Colors.black87),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.indigo,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueGrey,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      textStyle: const TextStyle(fontSize: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  ),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blueGrey,
  ).copyWith(secondary: Colors.pinkAccent),
);
