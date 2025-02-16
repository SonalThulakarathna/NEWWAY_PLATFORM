import 'package:flutter/material.dart';
import 'package:newway/classes/card_data.dart';
import 'package:newway/components/colors.dart';
import 'package:newway/pages/funnel%20pages/funnel_cources.dart';

class FunnelInsideTabbar extends StatelessWidget {
  final Cardcontent card;
  const FunnelInsideTabbar({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: primary,
        appBar: AppBar(
          backgroundColor: primary,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            '${card.author} funnel',
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.transparent,
            tabs: [
              Tab(
                child: Text(
                  'Courses', // ✅ Fixed spelling mistake
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  'Meetings',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  'Community',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  'Members',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        body: Expanded(
          child: TabBarView(
            children: [
              Center(
                  child: FunnelCources(
                card: card,
              )),
              Center(child: Text('Meetings Content')),
              Center(child: Text('Community Content')),
              Center(child: Text('Members Content')),
            ],
          ),
        ),
      ),
    );
  }
}
