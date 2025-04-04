import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:newway/classes/authservice.dart';
import 'package:newway/classes/card_data.dart';
import 'package:newway/classes/cardcontentDB.dart';

import 'package:newway/components/content_card.dart';

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
  int _selectedChipIndex = 0; // Track selected chip for UI purposes

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
      // Use a Container with gradient instead of just a background color
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E1E2E), // Dark blue-purple
              Color(0xFF2D2D44), // Slightly lighter blue-purple
            ],
          ),
        ),
        child: LiquidPullToRefresh(
          onRefresh: handlerefresh,
          color: Colors.grey.shade800,
          animSpeedFactor: 2,
          height: 200,
          backgroundColor: Colors.black.withOpacity(0.7),
          showChildOpacityTransition: false,
          child: Column(
            children: [
              // Keep the MainAppbar component
              MainAppbar(),
              const SizedBox(height: 20),

              // Enhanced section title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Spacer(),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Enhanced Filter Chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final List<String> chipLabels = [
                        "Leadership",
                        "Corporate",
                        "Fitness",
                        "Business",
                      ];

                      final List<IconData> chipIcons = [
                        Icons.trending_up_rounded,
                        Icons.business_center_rounded,
                        Icons.fitness_center_rounded,
                        Icons.storefront_rounded,
                      ];

                      // Instead of using the Fchip component, we create a modern chip directly
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedChipIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _selectedChipIndex == index
                                ? Color(0xFF6366F1) // Indigo when selected
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: _selectedChipIndex == index
                                ? [
                                    BoxShadow(
                                      color: Color(0xFF6366F1).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                chipIcons[index],
                                color: _selectedChipIndex == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.7),
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                chipLabels[index],
                                style: TextStyle(
                                  color: _selectedChipIndex == index
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.7),
                                  fontWeight: _selectedChipIndex == index
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Enhanced section title for content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Spacer(),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // FutureBuilder to Fetch Data - same logic, enhanced UI
              Expanded(
                child: FutureBuilder<List<Cardcontent>>(
                  future: carddb.getCardContents(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: Lottie.network(
                                'https://lottie.host/d4649615-85f7-4ef1-81e3-c5015ed851d7/83V9j7MnW7.json',
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Loading content...",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              color: Colors.red.shade300,
                              size: 60,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF6366F1),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text("Try Again"),
                            ),
                          ],
                        ),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              color: Colors.white.withOpacity(0.5),
                              size: 60,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No content found',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Try a different category or check back later',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final cards = snapshot.data!;
                    // We're still using the ContentCard component, but with padding for better spacing
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        // Add a Container wrapper around ContentCard for enhanced styling
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ContentCard(
                            card: cards[index],
                            onTap: () => navigatetodetailspage(cards[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
