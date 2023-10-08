import 'package:flutter/material.dart';
import 'package:testapp/Screen/SceneScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scene Scanner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF22323C)),
        useMaterial3: true,
      ),
      home: const SceneScreen(),
    );
  }
}
