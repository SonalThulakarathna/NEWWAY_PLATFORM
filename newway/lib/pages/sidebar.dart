import 'package:flutter/material.dart';
import 'package:newway/classes/authservice.dart';
import 'package:newway/pages/funnel%20pages/createfunnel_page.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final authservice = Authservicelog();

  void logout() async {
    await authservice.signout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1F1F1F), // Dark gray background
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white, // White icons for search
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white, // White icon for clearing search
                      ),
                    ),
                    hintText: "Search your funnel",
                    hintStyle: TextStyle(
                        color: const Color(0xFFAAAAAA)), // Light gray hint text
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                ListTile(
                  leading: Image.asset(
                    "lib/images/Plus.png",
                    height: 36,
                  ),
                  title: Text(
                    "Create Funnel",
                    style: TextStyle(
                        color: Colors.white), // White text for menu item
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreatefunnelPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  leading: Image.asset(
                    "lib/images/search.png",
                    height: 36,
                  ),
                  title: Text(
                    "Discover Funnel",
                    style: TextStyle(
                        color: Colors.white), // White text for menu item
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          // Logout ListTile at the bottom
          ListTile(
            leading: Image.asset(
              "lib/images/logout.png",
              height: 36,
            ),
            title: Text(
              "Log out",
              style: TextStyle(color: Colors.white), // White text for logout
            ),
            onTap: logout,
          ),
        ],
      ),
    );
  }
}
