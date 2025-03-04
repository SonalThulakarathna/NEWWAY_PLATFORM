import 'package:flutter/material.dart';
import 'package:newway/classes/card_data.dart';
import 'package:newway/components/colors.dart';

class ContentCard extends StatelessWidget {
  final Cardcontent card;
  final void Function()? onTap;

  const ContentCard({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: double.infinity, // Ensure the Card expands to full width
          ),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Image(
                  height: 180,
                  image: _getImageProvider(card.userimageurl),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage:
                                  _getImageProvider(card.imagepath),
                              onBackgroundImageError: (_, __) =>
                                  const Icon(Icons.error, color: Colors.red),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    card.author,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[900],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    card.subtitle,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                      height: 1.4,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Footer Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 4),
                                if (card.condition == 'private')
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        color: textfieldgrey,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Private',
                                        style: TextStyle(
                                          color: textfieldgrey,
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  )
                                else
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.done,
                                        color: textfieldgrey,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Public',
                                        style: TextStyle(
                                          color: textfieldgrey,
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ), // Empty widget if condition is false

                                const SizedBox(width: 12),
                                Text(
                                  "${card.members} Members",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "\$${card.price}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
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
      return AssetImage(
          'lib/images/anime.jpg'); // Add a placeholder image in your assets
    }
  }
}
