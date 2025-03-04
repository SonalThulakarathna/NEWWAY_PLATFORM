import 'package:flutter/material.dart';
import 'package:newway/classes/authservice.dart';
import 'package:newway/components/button.dart';
import 'package:newway/components/colors.dart';
import 'package:newway/pages/edit_profile_page.dart';
import 'package:newway/pages/funnel%20pages/profilefunnelpage_selector.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authservice = Authservicelog();
  final supbase = Supabase.instance.client;

  void editprofilepage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfilePage()),
    );
  }

  Future<bool> userHasAFunnel() async {
    final uid = authservice.getuserid();

    if (uid == null) {
      print("User ID is null. Cannot check funnel.");
      return false;
    }

    try {
      final response = await supbase
          .from('newwayfunnelinfo')
          .select('userid')
          .eq('userid', uid)
          .maybeSingle();

      return response != null;
    } catch (error) {
      print("Error checking funnel: $error");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(
                  height: 70,
                ),
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: const Image(
                        image: AssetImage('lib/images/lettern.png')),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 17,
                ),
                Text(
                  'Selina Rogert',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Photographer',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Button(
                    text: 'Edit profile',
                    onTap: editprofilepage,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                FutureBuilder(
                  future: userHasAFunnel(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData && snapshot.data == true) {
                      return Padding(
                        // Return Padding widget explicitly
                        padding: const EdgeInsets.all(27.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfilefunnelpageSelector(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: buttoncolor,
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.all(13),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Funnel Info',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 25,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
