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
  bool _isRefreshing = false;

  // YouTube-style dark theme colors
  final Color backgroundColor = const Color(0xFF0F0F0F);
  final Color surfaceColor = const Color(0xFF1F1F1F);
  final Color cardColor = const Color(0xFF282828);
  final Color accentColor = const Color(0xFFFF0000); // YouTube red
  final Color textColor = Colors.white;
  final Color textSecondary = const Color(0xFFAAAAAA);
  final Color dividerColor = const Color(0xFF303030);

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
        SnackBar(
          content: Text("An error occurred. Please try again."),
          backgroundColor: accentColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> handlerefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      backgroundColor: backgroundColor,
      body: LiquidPullToRefresh(
        onRefresh: handlerefresh,
        color: cardColor,
        animSpeedFactor: 2,
        height: 200,
        backgroundColor: accentColor.withOpacity(0.8),
        showChildOpacityTransition: false,
        child: CustomScrollView(
          slivers: [
            // AppBar as a SliverAppBar
            SliverToBoxAdapter(
              child: MainAppbar(),
            ),

            // Category section
            SliverToBoxAdapter(
              child: _buildCategorySection(),
            ),

            // Divider
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(color: dividerColor, height: 1),
              ),
            ),

            // Content section header
            SliverToBoxAdapter(
              child: _buildContentSectionHeader(),
            ),

            // Content cards
            _buildContentSectionBody(),
          ],
        ),
      ),
    );
  }

  // Category section with chips
  Widget _buildCategorySection() {
    final List<String> chipLabels = [
      "All",
      "Leadership",
      "Corporate",
      "Fitness",
      "Business",
    ];

    final List<IconData> chipIcons = [
      Icons.apps,
      Icons.trending_up_rounded,
      Icons.business_center_rounded,
      Icons.fitness_center_rounded,
      Icons.storefront_rounded,
    ];

    return Container(
      color: surfaceColor,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: Text(
              "Categories",
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: chipLabels.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedChipIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedChipIndex == index
                          ? cardColor
                          : backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _selectedChipIndex == index
                            ? accentColor
                            : dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          chipIcons[index],
                          color: _selectedChipIndex == index
                              ? accentColor
                              : textSecondary,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          chipLabels[index],
                          style: TextStyle(
                            color: _selectedChipIndex == index
                                ? textColor
                                : textSecondary,
                            fontWeight: _selectedChipIndex == index
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Content section header
  Widget _buildContentSectionHeader() {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
        children: [
          Text(
            "Recommended Content",
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          TextButton(
            onPressed: () {
              // Sort functionality
              showModalBottomSheet(
                context: context,
                backgroundColor: surfaceColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => _buildSortOptions(),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: textSecondary,
              padding: EdgeInsets.symmetric(horizontal: 8),
            ),
            child: Row(
              children: [
                Text("Sort", style: TextStyle(fontSize: 14)),
                SizedBox(width: 4),
                Icon(Icons.sort, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Content section body - now as a sliver to enable scrolling
  Widget _buildContentSectionBody() {
    return FutureBuilder<List<Cardcontent>>(
      future: carddb.getCardContents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            _isRefreshing) {
          return SliverFillRemaining(
            child: _buildLoadingState(),
          );
        }
        if (snapshot.hasError) {
          return SliverFillRemaining(
            child: _buildErrorState(snapshot.error),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SliverFillRemaining(
            child: _buildEmptyState(),
          );
        }

        final cards = snapshot.data!;
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              // Return a widget for each card with a divider
              if (index == cards.length * 2 - 1) {
                // Last item doesn't need a divider
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ContentCard(
                    card: cards[index ~/ 2],
                    onTap: () => navigatetodetailspage(cards[index ~/ 2]),
                  ),
                );
              } else if (index % 2 == 0) {
                // Card
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ContentCard(
                    card: cards[index ~/ 2],
                    onTap: () => navigatetodetailspage(cards[index ~/ 2]),
                  ),
                );
              } else {
                // Divider
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    color: dividerColor,
                    height: 32,
                    thickness: 1,
                  ),
                );
              }
            },
            childCount:
                cards.length * 2 - 1, // Cards with dividers between them
          ),
        );
      },
    );
  }

  // Sort options bottom sheet
  Widget _buildSortOptions() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          _buildSortOption(
            title: "Newest First",
            isSelected: true,
            onTap: () => Navigator.pop(context),
          ),
          _buildSortOption(
            title: "Oldest First",
            isSelected: false,
            onTap: () => Navigator.pop(context),
          ),
          _buildSortOption(
            title: "Most Popular",
            isSelected: false,
            onTap: () => Navigator.pop(context),
          ),
          _buildSortOption(
            title: "Price: Low to High",
            isSelected: false,
            onTap: () => Navigator.pop(context),
          ),
          _buildSortOption(
            title: "Price: High to Low",
            isSelected: false,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // Sort option item
  Widget _buildSortOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? accentColor : textColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      leading: isSelected
          ? Icon(Icons.radio_button_checked, color: accentColor)
          : Icon(Icons.radio_button_unchecked, color: textSecondary),
      onTap: onTap,
    );
  }

  // Loading state widget
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: Lottie.network(
              'https://lottie.host/d4649615-85f7-4ef1-81e3-c5015ed851d7/83V9j7MnW7.json',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Loading content...",
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Error state widget
  Widget _buildErrorState(dynamic error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: accentColor,
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'Error loading content',
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: textColor,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Try Again"),
          ),
        ],
      ),
    );
  }

  // Empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.content_paste_off,
            color: textSecondary,
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'No content found',
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Try selecting a different category',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
