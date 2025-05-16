import 'package:flutter/material.dart';
import 'package:newway/classes/card_data.dart';

class ContentCard extends StatelessWidget {
  final Cardcontent card;
  final void Function()? onTap;

  const ContentCard({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Dark theme colors
    final darkBackground = const Color(0xFF121212);
    final cardBackground = const Color(0xFF1F1F1F);
    final surfaceColor = const Color(0xFF282828);
    final primaryText = const Color(0xFFFFFFFF);
    final secondaryText = const Color(0xFFAAAAAA);
    final accentBlue = const Color(0xFF3EA6FF);
    final dividerColor = const Color(0xFF303030);
    final privateColor = const Color(0xFFFF5252);
    final publicColor = const Color(0xFF4CAF50);
    final badgeBackground = const Color(0xFF303030);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Reduced horizontal margin to increase card width
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Image with Overlay
              Stack(
                children: [
                  // Image
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _getImageProvider(card.userimageurl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                        stops: const [0.7, 1.0],
                      ),
                    ),
                  ),

                  // Status badge (private/public)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: card.condition == 'private'
                            ? privateColor.withOpacity(0.9)
                            : publicColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            card.condition == 'private'
                                ? Icons.lock
                                : Icons.public,
                            color: primaryText,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            card.condition == 'private' ? 'Private' : 'Public',
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author Info Row - Corrected placement
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Image with Border - Now properly inside the card content
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: cardBackground,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundImage:
                                _getImageProvider(card.profileimageurl),
                            onBackgroundImageError: (_, __) =>
                                const Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Author Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.author,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: primaryText,
                                  letterSpacing: -0.2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                card.subtitle,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: secondaryText,
                                  height: 1.4,
                                  letterSpacing: 0.1,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Divider
                    Divider(
                      color: dividerColor,
                      thickness: 1,
                    ),

                    const SizedBox(height: 12),

                    // Footer Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Status and Members
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            // Status Indicator
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: badgeBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    card.condition == 'private'
                                        ? Icons.lock
                                        : Icons.public,
                                    color: card.condition == 'private'
                                        ? privateColor
                                        : publicColor,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    card.condition == 'private'
                                        ? 'Private'
                                        : 'Public',
                                    style: TextStyle(
                                      color: secondaryText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),

                            // Members Count
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: badgeBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.people,
                                    size: 14,
                                    color: secondaryText,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${card.members}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: secondaryText,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Price
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: accentBlue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: accentBlue.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            "\$${card.price}",
                            style: TextStyle(
                              fontSize: 16,
                              color: accentBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Function to Handle Image Source (Local vs Network)
  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      return NetworkImage(imagePath); // Handle network images
    } else if (imagePath.isNotEmpty) {
      return AssetImage(imagePath); // Handle local assets
    } else {
      // Return a placeholder or default image if the path is empty
      return const AssetImage(
          'lib/images/anime.jpg'); // Add a placeholder image in your assets
    }
  }
}
