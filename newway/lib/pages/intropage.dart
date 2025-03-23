import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:newway/classes/authservice.dart';
import 'package:newway/classes/card_data.dart';
import 'package:newway/classes/cardcontentDB.dart';
import 'package:newway/components/colors.dart';
import 'package:newway/components/content_card.dart';
import 'package:newway/components/filter_chip.dart';
import 'package:newway/components/main_appbar.dart';
import 'package:newway/pages/funnel%20pages/funnel_inside_tabbar.dart';
import 'package:newway/pages/moredetails.dart';
import 'package:newway/pages/sidebar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Intropage extends StatefulWidget {
  const Intropage({super.key});

  @override
  State<Intropage> createState() => _IntropageState();
}

class _IntropageState extends State<Intropage> {
  final carddb = Cardcontentdb();
  final SupabaseClient supabase = Supabase.instance.client;
  final auth = Authservicelog();

  void navigatetodetailspage(Cardcontent card) async {
    final cuserid = auth.getuserid().toString();
    try {
      final response = await supabase
          .from('funnelmembers')
          .select('id')
          .eq('funnelid', card.id)
          .eq('userid', cuserid)
          .maybeSingle();

      final response2 = await supabase
          .from('newwayfunnelinfo')
          .select('id')
          .eq('id', card.id)
          .eq('userid', cuserid)
          .maybeSingle();

      // ignore: unnecessary_null_comparison
      if (response != null || response2 != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FunnelInsideTabbar(card: card)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Moredetails(cc: card)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> handlerefresh() async {
    return await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      backgroundColor: primary,
      body: LiquidPullToRefresh(
        onRefresh: handlerefresh,
        color: Colors.grey,
        animSpeedFactor: 2,
        height: 200,
        backgroundColor: Colors.black,
        showChildOpacityTransition: false,
        child: Column(
          children: [
            MainAppbar(),
            const SizedBox(height: 16),

            // Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final List<String> chipLabels = [
                      "Leadership",
                      "Corporate",
                      "Fitness",
                      "Business",
                    ];
                    return Fchip(text: chipLabels[index]);
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            // FutureBuilder to Fetch Data
            Expanded(
              child: FutureBuilder<List<Cardcontent>>(
                future: carddb.getCardContents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: SizedBox(
                      height: 950,
                      child: Lottie.network(
                          'https://lottie.host/d4649615-85f7-4ef1-81e3-c5015ed851d7/83V9j7MnW7.json'),
                    ));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No cards found.'));
                  }

                  final cards = snapshot.data!;
                  return ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      return ContentCard(
                        card: cards[index],
                        onTap: () => navigatetodetailspage(cards[index]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
