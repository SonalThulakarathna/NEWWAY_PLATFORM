import 'package:flutter/material.dart';
import 'package:newway/classes/card_data.dart';

class FunnelCoverpage extends StatelessWidget {
  final Cardcontent card;
  const FunnelCoverpage({super.key, required this.card});
  final double coverHeight = 180;
  final double profileHeight = 90;

  @override
  Widget build(BuildContext context) {
    final top = coverHeight - (profileHeight / 2);
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            buildCoverImage(context),
            Positioned(
              top: top,
              child: buildProfileImage(),
            ),
          ],
        ),
        const SizedBox(
          height: 70,
        ),
        Text(
          card.author,
          style: TextStyle(
              fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            card.subtitle,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
            textAlign: TextAlign.justify,
          ),
        )
      ],
    );
  }

  Widget buildCoverImage(BuildContext context) => Container(
        color: Colors.grey,
        width: MediaQuery.of(context).size.width,
        height: coverHeight,
        child: card.userimageurl.startsWith('http')
            ? Image.network(card.userimageurl, fit: BoxFit.cover)
            : Image.asset('lib/images/anime.jpg',
                fit: BoxFit.cover), // Fallback to a local default image
      );

  Widget buildProfileImage() => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey.shade800,
        backgroundImage: card.profileimageurl.startsWith('http')
            ? NetworkImage(card.profileimageurl)
            : AssetImage('lib/images/lettern.png')
                as ImageProvider, // Fallback to a local default image
      );
}
