import 'package:flutter/material.dart';
import 'package:newway/classes/card_data.dart';
import 'package:newway/pages/funnel%20pages/funnel_cources.dart';
import 'package:newway/pages/funnel%20pages/funnel_members.dart';
import 'package:newway/pages/funnel%20pages/funnelcommunity.dart';

class FunnelInsideTabbar extends StatelessWidget {
  final Cardcontent card;
  const FunnelInsideTabbar({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xFF1E1E2E),
        appBar: AppBar(
          backgroundColor: Color(0xFF1E1E2E),
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
              Center(
                  child: Funnelcommunity(
                channelId: card.id.toString(),
              )),
              Center(
                  child: FunnelMembers(
                card: card,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
