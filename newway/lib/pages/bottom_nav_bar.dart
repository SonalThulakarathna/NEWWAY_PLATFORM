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

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late AnimationController _controller;

  // Colors based on YouTube dark theme
  final Color _backgroundColor = const Color(0xFF121212);
  final Color _selectedItemColor = const Color(0xFFFF0000); // YouTube red
  final Color _unselectedItemColor = const Color(0xFFAAAAAA); // Light gray

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void navigate(int index) {
    setState(() {
      selectedIndex = index;
      _controller.reset();
      _controller.forward();
    });
  }

  final List<Widget> pages = [
    const Intropage(),
    const FavouritePage(),
    const ProfilePage()
  ];

  final List<String> labels = ['Home', 'Funnels', 'Profile'];
  final List<IconData> icons = [
    Icons.home_rounded,
    Icons.layers_rounded,
    Icons.person_rounded
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: KeyedSubtree(
            key: ValueKey<int>(selectedIndex),
            child: pages[selectedIndex],
          ),
        ),
        extendBody: true,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: _backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(pages.length, (index) {
                  return _buildNavItem(index);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: () => navigate(index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? _selectedItemColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icons[index],
              color: isSelected ? _selectedItemColor : _unselectedItemColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              labels[index],
              style: TextStyle(
                color: isSelected ? _selectedItemColor : _unselectedItemColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
