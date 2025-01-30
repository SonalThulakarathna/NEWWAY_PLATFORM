import 'package:flutter/material.dart';
import 'package:newway/components/colors.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: primary,
      child: ListView(
        children: [
          const SizedBox(
            height: 30,
          ),
          TextField(
            decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.white,
                    )),
                hintText: "Search your funnel",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none),
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
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Image.asset(
              "lib/images/Plus.png",
              height: 36,
            ),
            title: Text(
              "Discover Funnel",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
