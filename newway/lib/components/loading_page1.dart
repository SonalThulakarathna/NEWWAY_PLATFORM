import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingPage1 extends StatefulWidget {
  const LoadingPage1({super.key});

  @override
  State<LoadingPage1> createState() => _LoadingPage1State();
}

class _LoadingPage1State extends State<LoadingPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          height: 250,
          child: Lottie.network(
              'https://lottie.host/9e699e21-2d29-4d93-94cb-0867f12f20b5/GZPeZAmYOz.json'),
        ),
      ),
    );
  }
}
