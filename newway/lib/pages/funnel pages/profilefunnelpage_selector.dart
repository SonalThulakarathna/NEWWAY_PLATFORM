import 'package:flutter/material.dart';
import 'package:newway/components/colors.dart';
import 'package:newway/pages/funnel%20pages/funnelvideo_uploadpage.dart';
import 'package:newway/pages/funnel%20pages/profilefunnel_statuspage.dart';

class ProfilefunnelpageSelector extends StatefulWidget {
  const ProfilefunnelpageSelector({super.key});

  @override
  State<ProfilefunnelpageSelector> createState() =>
      _ProfilefunnelpageSelectorState();
}

class _ProfilefunnelpageSelectorState extends State<ProfilefunnelpageSelector> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: primary,
        appBar: AppBar(
          backgroundColor: primary,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(fontSize: 18),
              tabs: [
                Tab(
                  text: 'Earnings',
                ),
                Tab(
                  text: 'Upload',
                ),
                Tab(
                  text: 'Edit',
                ),
              ]),
        ),
        body: TabBarView(children: [
          ProfilefunnelStatuspage(),
          FunnelvideoUploadpage(),
          Text('home'),
        ]),
      ),
    );
  }
}
