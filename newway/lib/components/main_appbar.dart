import 'package:flutter/material.dart';
import 'package:newway/pages/search_page.dart';

class MainAppbar extends StatelessWidget {
  const MainAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "NEWWAY",
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications),
          iconSize: 28,
          style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(
            Colors.white,
          )),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SearchPage(),
          )),
          icon: Icon(Icons.search),
          iconSize: 28,
          style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.white)),
        ),
      ],
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: Icon(Icons.menu),
        iconSize: 28,
        style:
            ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.white)),
      ),
    );
  }
}
