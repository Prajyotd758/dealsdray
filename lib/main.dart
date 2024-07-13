import 'package:dealsdray_assignment/product_screen.dart';
import 'package:dealsdray_assignment/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const homePage());
}

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const splashScreen(),
        '/products': (context) => const ProductScreen(),
      },
    );
  }
}
