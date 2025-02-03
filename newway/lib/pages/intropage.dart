import 'package:flutter/material.dart';
import 'package:newway/classes/card_data.dart';
import 'package:newway/components/colors.dart';
import 'package:newway/components/content_card.dart';
import 'package:newway/components/filter_chip.dart';
import 'package:newway/components/main_appbar.dart';
import 'package:newway/pages/moredetails.dart';
import 'package:newway/pages/sidebar.dart';

class Intropage extends StatefulWidget {
  const Intropage({super.key});

  @override
  State<Intropage> createState() => _IntropageState();
}

class _IntropageState extends State<Intropage> {
  final Carddata = [
    Cardcontent(
        title: 'RRRR',
        subtitle: 'aaaaaaa',
        author: 'Randeniya',
        imagepath: 'lib/images/google.png',
        members: '100',
        price: '500.00'),
    Cardcontent(
        title: 'RRRR',
        subtitle: 'aaaaaaa',
        author: 'Nehri',
        imagepath: 'lib/images/google.png',
        members: '100',
        price: '700.00'),
  ];
  void navigatetodetailspage(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Moredetails(
                  cc: Carddata[index],
                )));
  }

  //final List<Widget> _contentCards = List.generate(6, (index) => ContentCard());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      backgroundColor: primary,
      body: Column(
        children: [
          MainAppbar(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              height: 50, // Set a fixed height for the horizontal list
              child: ListView.separated(
                scrollDirection:
                    Axis.horizontal, // Make the list scroll horizontally
                itemCount: 4, // Number of chips
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 8), // Add spacing between chips
                itemBuilder: (context, index) {
                  // Define the text for each chip
                  final List<String> chipLabels = [
                    "Leadership",
                    "Corporate",
                    "Fitness",
                    "Business",
                  ];
                  return Fchip(text: chipLabels[index]);
                },
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: Carddata.length,
                  itemBuilder: (context, index) => ContentCard(
                        card: Carddata[index],
                        onTap: () => navigatetodetailspage(index),
                      )))
        ],
      ),
    );
  }
}
