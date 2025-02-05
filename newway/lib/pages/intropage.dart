import 'package:flutter/material.dart';
import 'package:newway/classes/card_data.dart';
import 'package:newway/classes/cardcontentDB.dart';
import 'package:newway/components/colors.dart';
import 'package:newway/components/content_card.dart';
import 'package:newway/components/filter_chip.dart';
import 'package:newway/components/main_appbar.dart';
import 'package:newway/pages/moredetails.dart';
import 'package:newway/pages/sidebar.dart';

class Intropage extends StatefulWidget {
  const Intropage({super.key});

  @override
  State<Intropage> createState() => _IntropageState();
}

class _IntropageState extends State<Intropage> {
  final carddb = Cardcontentdb();

  void navigatetodetailspage(Cardcontent card) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Moredetails(cc: card)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      backgroundColor: primary,
      body: Column(
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
                separatorBuilder: (context, index) => const SizedBox(width: 8),
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
                  return const Center(child: CircularProgressIndicator());
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
    );
  }
}
