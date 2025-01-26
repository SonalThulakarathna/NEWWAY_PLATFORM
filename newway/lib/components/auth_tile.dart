import 'package:flutter/material.dart';
import 'package:newway/components/colors.dart';

class Atile extends StatelessWidget {
  final String path;
  const Atile({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(16),
          border: Border.all(color: Colors.white),
          color: textfieldgrey),
      child: Image.asset(
        path,
        height: 40,
      ),
    );
  }
}
