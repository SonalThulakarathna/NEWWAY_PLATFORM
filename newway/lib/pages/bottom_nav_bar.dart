import 'package:flutter/material.dart';

import 'package:newway/pages/favourite_page.dart';
import 'package:newway/pages/intropage.dart';
import 'package:newway/pages/profile_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedindex = 0;
  void navigate(int index) {
    setState(() {
      selectedindex = index;
    });
  }

  final List<Widget> pages = [Intropage(), FavouritePage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedindex,
        backgroundColor: Color(0xFF2D2D44),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 227, 129, 245),
        elevation: 0,
        onTap: navigate,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pages), label: 'Funnels'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Person')
        ],
      ),
    );
  }
}
