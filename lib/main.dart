import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/category_screen.dart';

void main() {
  runApp(const ProviderScope(child: AwardsApp()));
}

class AwardsApp extends StatelessWidget {
  const AwardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Presentación de Premios',
      theme: ThemeData.dark(),
      home: const CategoryScreen(),
    );
  }
}
