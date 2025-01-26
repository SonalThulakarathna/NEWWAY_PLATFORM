import 'package:flutter/material.dart';
import 'package:newway/components/colors.dart';

class Textfield extends StatelessWidget {
  final controller;
  final String hinttext;
  final bool obscuretext;
  const Textfield(
      {super.key,
      required this.controller,
      required this.hinttext,
      required this.obscuretext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        child: TextField(
          controller: controller,
          obscureText: obscuretext,
          decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
              fillColor: textfieldgrey,
              filled: true,
              hintText: hinttext,
              hintStyle: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }
}
