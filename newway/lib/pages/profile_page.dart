import 'package:flutter/material.dart';
import 'package:newway/components/colors.dart';
import 'package:newway/pages/edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Image
            Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'lib/images/tempbanner.jpg'), // Add your banner image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Profile Picture and Name
            Transform.translate(
              offset: Offset(0, -50), // Move the profile picture up
              child: Column(
                children: [
                  // Profile Picture
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                      image: DecorationImage(
                        image: AssetImage(
                            'lib/images/girl.jpeg'), // Add your profile picture
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Name
                  const Text(
                    'Selina Rogger',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),

                  const Text(
                    'Photographer ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 10),
                  // Reputation

                  const SizedBox(height: 10),
                  // Bio Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'A talented female photographer with a keen eye for capturing moments that tell stories. ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      // Edit Profile Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to EditProfilePage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProfilePage()),
          );
        },
        child: Icon(Icons.edit, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
