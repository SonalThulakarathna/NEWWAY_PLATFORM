import 'package:flutter/material.dart';
import 'package:newway/components/colors.dart';

class Fchip extends StatefulWidget {
  final String text;
  const Fchip({super.key, required this.text});

  @override
  State<Fchip> createState() => _FchipState();
}

class _FchipState extends State<Fchip> {
  bool isselected = false;
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.text),
      selected: isselected,
      backgroundColor: buttoncolor,
      labelStyle: const TextStyle(color: Colors.white),
      onSelected: (bool value) {
        setState(() {
          isselected = !isselected;
        });
      },
    );
  }
}
