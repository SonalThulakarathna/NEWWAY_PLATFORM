import 'package:flutter/material.dart';
import 'package:newway/classes/card_data.dart';
import 'package:newway/pages/funnel%20pages/funnel_cources.dart';
import 'package:newway/pages/funnel%20pages/funnel_members.dart';
import 'package:newway/pages/funnel%20pages/funnelcommunity.dart';

class FunnelInsideTabbar extends StatefulWidget {
  final Cardcontent card;
  const FunnelInsideTabbar({super.key, required this.card});

  @override
  State<FunnelInsideTabbar> createState() => _FunnelInsideTabbarState();
}

class _FunnelInsideTabbarState extends State<FunnelInsideTabbar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          '${widget.card.author} Funnel',
          style: TextStyle(
            fontSize: 20,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: textColor),
            onPressed: () {
              _showOptionsMenu(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Custom tab bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _buildCustomTabBar(),
          ),

          // Divider below tabs
          Divider(color: dividerColor, height: 1),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [
                FunnelCources(card: widget.card),
                Funnelcommunity(channelId: widget.card.id.toString()),
                FunnelMembers(card: widget.card),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // Custom tab bar with YouTube style
  Widget _buildCustomTabBar() {
    return TabBar(
      controller: _tabController,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: accentColor, width: 3),
        insets: const EdgeInsets.symmetric(horizontal: 16),
      ),
      labelColor: textColor,
      unselectedLabelColor: textSecondary,
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      tabs: [
        Tab(
          icon: Icon(
            Icons.school_rounded,
            color: _tabController.index == 0 ? accentColor : textSecondary,
            size: 24,
          ),
          text: 'Courses',
          iconMargin: const EdgeInsets.only(bottom: 4),
        ),
        Tab(
          icon: Icon(
            Icons.forum_rounded,
            color: _tabController.index == 1 ? accentColor : textSecondary,
            size: 24,
          ),
          text: 'Community',
          iconMargin: const EdgeInsets.only(bottom: 4),
        ),
        Tab(
          icon: Icon(
            Icons.people_rounded,
            color: _tabController.index == 2 ? accentColor : textSecondary,
            size: 24,
          ),
          text: 'Members',
          iconMargin: const EdgeInsets.only(bottom: 4),
        ),
      ],
    );
  }

  // Floating action button that changes based on active tab
  Widget? _buildFloatingActionButton() {
    if (_tabController.index == 0) {
      return FloatingActionButton(
        onPressed: () {
          // Add new course action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Add new course"),
              backgroundColor: cardColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        backgroundColor: accentColor,
        child: Icon(Icons.add, color: textColor),
      );
    } else if (_tabController.index == 1) {
      return FloatingActionButton(
        onPressed: () {
          // New post action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Create new post"),
              backgroundColor: cardColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        backgroundColor: accentColor,
        child: Icon(Icons.post_add, color: textColor),
      );
    } else if (_tabController.index == 2) {
      return FloatingActionButton(
        onPressed: () {
          // Invite members action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Invite new members"),
              backgroundColor: cardColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        backgroundColor: accentColor,
        child: Icon(Icons.person_add, color: textColor),
      );
    }
    return null;
  }

  // Options menu
  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildOptionItem(
                icon: Icons.share_outlined,
                text: 'Share Funnel',
                onTap: () {
                  Navigator.pop(context);
                  // Share functionality
                },
              ),
              _buildOptionItem(
                icon: Icons.bookmark_border_outlined,
                text: 'Save Funnel',
                onTap: () {
                  Navigator.pop(context);
                  // Save functionality
                },
              ),
              _buildOptionItem(
                icon: Icons.notifications_outlined,
                text: 'Notification Settings',
                onTap: () {
                  Navigator.pop(context);
                  // Notification settings
                },
              ),
              _buildOptionItem(
                icon: Icons.report_outlined,
                text: 'Report Issue',
                onTap: () {
                  Navigator.pop(context);
                  // Report functionality
                },
              ),
              _buildOptionItem(
                icon: Icons.exit_to_app,
                text: 'Leave Funnel',
                textColor: accentColor,
                onTap: () {
                  Navigator.pop(context);
                  // Leave funnel functionality
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to build option items for bottom sheet
  Widget _buildOptionItem({
    required IconData icon,
    required String text,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? this.textColor,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: textColor ?? this.textColor,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}
