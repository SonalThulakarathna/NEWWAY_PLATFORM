import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:newway/classes/authservice.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({
    super.key,
  });

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final supabase = Supabase.instance.client;
  final auth = Authservicelog();
  List<Map<String, dynamic>> funnelDetails = [];
  bool isLoading = true;

  // YouTube-style dark theme colors
  final Color backgroundColor = const Color(0xFF0F0F0F);
  final Color surfaceColor = const Color(0xFF1F1F1F);
  final Color cardColor = const Color(0xFF282828);
  final Color accentColor = const Color(0xFFFF0000); // YouTube red
  final Color textColor = Colors.white;
  final Color textSecondary = const Color(0xFFAAAAAA);
  final Color dividerColor = const Color(0xFF303030);

  @override
  void initState() {
    super.initState();
    fetchUserFunnels();
  }

  void fetchUserFunnels() async {
    final cuser = auth.getuserid();

    if (cuser == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await supabase
          .from('funnelmembers')
          .select('funnelid')
          .eq('userid', cuser);

      if (response.isNotEmpty) {
        List<String> funnelIds = response
            .map<String>((item) => item['funnelid'].toString())
            .toList();

        if (funnelIds.isNotEmpty) {
          final funnelsResponse = await supabase
              .from('newwayfunnelinfo')
              .select('*')
              .inFilter('id', funnelIds);

          setState(() {
            funnelDetails = List<Map<String, dynamic>>.from(funnelsResponse);
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching user funnels: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'My Funnels',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: textColor),
            onPressed: () {
              // Search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Search funnels"),
                  backgroundColor: cardColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header section with stats
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  // Stats row
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(
                          count: funnelDetails.length.toString(),
                          label: 'Joined',
                          icon: Icons.group,
                        ),
                        _buildVerticalDivider(),
                        _buildStatItem(
                          count: '0',
                          label: 'Completed',
                          icon: Icons.check_circle_outline,
                        ),
                        _buildVerticalDivider(),
                        _buildStatItem(
                          count: '0',
                          label: 'Favorites',
                          icon: Icons.favorite_border,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Filter chips
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFilterChip(
                          label: 'All',
                          isSelected: true,
                        ),
                        _buildFilterChip(
                          label: 'Recent',
                          isSelected: false,
                        ),
                        _buildFilterChip(
                          label: 'Paid',
                          isSelected: false,
                        ),
                        _buildFilterChip(
                          label: 'Free',
                          isSelected: false,
                        ),
                        _buildFilterChip(
                          label: 'Completed',
                          isSelected: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Section header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.subscriptions,
                              color: accentColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Joined Funnels',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.sort,
                                    color: textSecondary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Sort',
                                    style: TextStyle(
                                      color: textSecondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Divider
                      Divider(color: dividerColor, height: 1),

                      // Content
                      Expanded(
                        child: isLoading
                            ? _buildLoadingState()
                            : funnelDetails.isEmpty
                                ? _buildEmptyState()
                                : _buildFunnelList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Discover new funnels
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Discover new funnels"),
              backgroundColor: cardColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        backgroundColor: accentColor,
        child: Icon(Icons.add, color: textColor),
      ),
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
          const SizedBox(height: 20),
          Text(
            'Loading your funnels...',
            style: TextStyle(
              color: textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.subscriptions_outlined,
              size: 64,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No joined funnels found",
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Discover and join funnels to see them here",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textSecondary,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Discover funnels action
            },
            icon: Icon(Icons.explore),
            label: Text("Discover Funnels"),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: textColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Funnel list widget
  Widget _buildFunnelList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: funnelDetails.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final funnel = funnelDetails[index];

        // Generate a color based on the funnel name for the avatar
        final avatarColor = Colors.primaries[
            (funnel['name'] ?? 'Unnamed').toString().length %
                Colors.primaries.length];

        return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with avatar and title
                    Row(
                      children: [
                        // Avatar or initial letter
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: avatarColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              (funnel['name'] ?? 'U')
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: TextStyle(
                                color: avatarColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Title and metadata
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                funnel['name'] ?? 'Unnamed Funnel',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Joined recently',
                                    style: TextStyle(
                                      color: textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Options menu
                        IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: textSecondary,
                          ),
                          onPressed: () {
                            // Show options menu
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Description
                    Text(
                      funnel['summaray'] ?? 'No description available',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 16),

                    // Tags and action row
                    Row(
                      children: [
                        // Condition tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: dividerColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            funnel['condition'] ?? 'Public',
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // Price tag (if applicable)
                        if (funnel['price'] != null &&
                            double.tryParse(funnel['price'].toString()) !=
                                null &&
                            double.parse(funnel['price'].toString()) > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '\$${funnel['price']}',
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                        const Spacer(),

                        // Continue button
                        ElevatedButton(
                          onPressed: () {
                            // Continue to funnel
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: textColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper method to build stat items
  Widget _buildStatItem({
    required String count,
    required String label,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: textColor,
            size: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Helper method to build vertical divider
  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: dividerColor,
    );
  }

  // Helper method to build filter chips
  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // Handle filter selection
        },
        backgroundColor: cardColor,
        selectedColor: accentColor.withOpacity(0.2),
        checkmarkColor: accentColor,
        labelStyle: TextStyle(
          color: isSelected ? accentColor : textSecondary,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? accentColor : dividerColor,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
