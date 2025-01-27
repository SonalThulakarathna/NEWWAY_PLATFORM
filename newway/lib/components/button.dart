import 'package:flutter/material.dart';
import 'package:newway/components/colors.dart';

class Button extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const Button({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: buttoncolor, borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(13),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
