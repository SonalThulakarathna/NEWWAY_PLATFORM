import 'package:flutter/material.dart';
import 'package:newway/classes/authservice.dart';
import 'package:newway/classes/card_data.dart';
import 'package:newway/components/carousel.dart';
import 'package:newway/pages/funnel%20pages/funnel_inside_tabbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Moredetails extends StatefulWidget {
  final Cardcontent cc;
  const Moredetails({super.key, required this.cc});

  @override
  State<Moredetails> createState() => _MoredetailsState();
}

final supabase = Supabase.instance.client;
final auth = Authservicelog();

class _MoredetailsState extends State<Moredetails> {
  void funnelinside(Cardcontent card) async {
    final cuser = auth.getuserid(); // Get current user ID

    try {
      await supabase.from('funnelmembers').insert({
        'userid': cuser,
        'funnelid': card.id,
      });

      // If no exception, insert was successful, navigate
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FunnelInsideTabbar(card: card),
        ),
      );
    } catch (e) {
      // Handle error case
      print("Error joining funnel: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Modern dark theme colors
    final backgroundColor = const Color(0xFF121212);
    final cardColor = const Color(0xFF1E1E2E);
    final accentColor = const Color(0xFF3D5AFE);
    final secondaryColor = const Color(0xFF4CAF50);
    final textColor = Colors.white;
    final textSecondary = Colors.white70;
    final dividerColor = Colors.white12;

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Carousel section with overlay
          SizedBox(
            height: 240,
            child: Stack(
              children: [
                // Carousel
                Positioned.fill(
                  child: Carousel(),
                ),

                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          backgroundColor.withOpacity(0.1),
                          backgroundColor.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ),

                // Logo and LIVE badge
                Positioned(
                  bottom: 16,
                  left: 20,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.circle, size: 8, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.cc.condition == 'private')
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.lock, size: 12, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                'PRIVATE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content section
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // Title section
                const SizedBox(height: 16),
                Text(
                  widget.cc.author,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // Description
                Text(
                  widget.cc.subtitle,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 24),

                // Value proposition with emoji
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: dividerColor,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '\$${widget.cc.price} Value',
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '🔥 💰 📈 ⚡',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(color: dividerColor),
                      const SizedBox(height: 12),

                      // Stats grid
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem(
                            icon: widget.cc.condition == 'private'
                                ? Icons.lock
                                : Icons.public,
                            label: widget.cc.condition == 'private'
                                ? 'Private'
                                : 'Public',
                            textColor: textColor,
                          ),
                          _buildStatItem(
                            icon: Icons.people,
                            label: '${widget.cc.members} Members',
                            textColor: textColor,
                          ),
                          _buildStatItem(
                            icon: Icons.person,
                            label: 'By ${widget.cc.author}',
                            textColor: textColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Join section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: dividerColor,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage:
                                NetworkImage(widget.cc.profileimageurl),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.grey[800],
                            child: Icon(Icons.person,
                                size: 16, color: Colors.grey[400]),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.grey[800],
                            child: Icon(Icons.person,
                                size: 16, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Join 3 people',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            '5.0 (2 ratings)',
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Join button
                      InkWell(
                        onTap: () => funnelinside(widget.cc),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Join funnel / \$${widget.cc.price}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Additional details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: dividerColor,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About this funnel',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.cc.subtitle,
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required Color textColor,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: textColor,
          size: 22,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
