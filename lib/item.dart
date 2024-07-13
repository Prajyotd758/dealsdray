import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final String source, details;
  const ProductDetails(
      {super.key, required this.source, required this.details});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: ColoredBox(
        color: Colors.blue,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.network(
            source,
            fit: BoxFit.contain,
            height: 300,
          ),
          Text(details)
        ]),
      ),
    );
  }
}
