import 'package:flutter/material.dart';
import 'package:newway/classes/card_data.dart';

class FunnelCoverpage extends StatelessWidget {
  final Cardcontent card;
  const FunnelCoverpage({super.key, required this.card});

  // Define dimensions
  final double coverHeight = 180;
  final double profileHeight = 90;

  // YouTube dark theme colors
  static const Color ytBackground = Color(0xFF0F0F0F);
  static const Color ytPrimary = Color(0xFFFF0000);
  static const Color ytSurface = Color(0xFF212121);
  static const Color ytText = Color(0xFFFFFFFF);
  static const Color ytTextSecondary = Color(0xFFAAAAAA);

  @override
  Widget build(BuildContext context) {
    final top = coverHeight - (profileHeight / 2);

    return Container(
      color: ytBackground,
      child: Column(
        children: [
          // Cover image and profile picture stack
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

          // Spacing for profile image overflow
          const SizedBox(height: 70),

          // Author name with modern typography
          Text(
            card.author,
            style: const TextStyle(
              fontSize: 24,
              color: ytText,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 16),

          // Subtitle with improved readability
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              card.subtitle,
              style: const TextStyle(
                fontSize: 16,
                color: ytTextSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Cover image with improved error handling
  Widget buildCoverImage(BuildContext context) => Container(
        color: ytSurface,
        width: MediaQuery.of(context).size.width,
        height: coverHeight,
        child: card.userimageurl.startsWith('http')
            ? Image.network(
                card.userimageurl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'lib/images/anime.jpg',
                    fit: BoxFit.cover,
                  );
                },
              )
            : Image.asset(
                'lib/images/anime.jpg',
                fit: BoxFit.cover,
              ),
      );

  // Profile image with elevation and border
  Widget buildProfileImage() => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: ytBackground,
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: CircleAvatar(
          radius: profileHeight / 2,
          backgroundColor: ytSurface,
          backgroundImage: card.profileimageurl.startsWith('http')
              ? NetworkImage(card.profileimageurl) as ImageProvider
              : AssetImage('lib/images/lettern.png') as ImageProvider,
        ),
      );
}
