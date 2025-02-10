import 'package:flutter/material.dart';
import 'package:newway/classes/card_data.dart';
import 'package:newway/components/colors.dart';
import 'package:newway/components/funnel_coverpage.dart';

class FunnelCources extends StatefulWidget {
  final Cardcontent card;
  const FunnelCources({super.key, required this.card});

  @override
  State<FunnelCources> createState() => _FunnelCourcesState();
}

class _FunnelCourcesState extends State<FunnelCources> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Column(
        children: [
          FunnelCoverpage(
            card: widget.card,
          ),
          Expanded(
            child: Column(),
          ),
        ],
      ),
    );
  }
}
