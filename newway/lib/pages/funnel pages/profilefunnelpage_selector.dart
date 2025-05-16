import 'package:flutter/material.dart';
import 'package:newway/pages/funnel%20pages/funnelvideo_uploadpage.dart';
import 'package:newway/pages/funnel%20pages/profilefunnel_statuspage.dart';

class ProfilefunnelpageSelector extends StatefulWidget {
  const ProfilefunnelpageSelector({super.key});

  @override
  State<ProfilefunnelpageSelector> createState() =>
      _ProfilefunnelpageSelectorState();
}

class _ProfilefunnelpageSelectorState extends State<ProfilefunnelpageSelector> {
  // YouTube-inspired dark theme colors
  final Color ytBackground = const Color(0xFF0F0F0F);
  final Color ytSurface = const Color(0xFF212121);
  final Color ytPrimary = const Color(0xFFFF0000);
  final Color ytSecondary = const Color(0xFF909090);
  final Color ytTextPrimary = Colors.white;
  final Color ytTextSecondary = const Color(0xFFAAAAAA);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: ytBackground,
        appBar: AppBar(
          backgroundColor: ytBackground,
          elevation: 0,
          centerTitle: false,
          title: Text(
            'Channel Management',
            style: TextStyle(
              color: ytTextPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          iconTheme: IconThemeData(color: ytTextPrimary),
          bottom: TabBar(
            labelColor: ytTextPrimary,
            unselectedLabelColor: ytTextSecondary,
            indicatorColor: ytPrimary,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            tabs: [
              Tab(text: 'Earnings'),
              Tab(text: 'Upload'),
              Tab(text: 'Edit'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabContent(ProfilefunnelStatuspage()),
            _buildTabContent(FunnelvideoUploadpage()),
            _buildTabContent(_buildEditTab()),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(Widget content) {
    return Container(
      color: ytBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: content,
    );
  }

  Widget _buildEditTab() {
    // Placeholder for Edit tab content - replace with actual content
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.edit,
            color: ytTextSecondary,
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'Edit Channel Details',
            style: TextStyle(
              color: ytTextPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Customize your channel appearance and settings',
            style: TextStyle(
              color: ytTextSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
