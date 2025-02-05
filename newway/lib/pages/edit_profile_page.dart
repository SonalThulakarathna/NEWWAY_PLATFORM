import 'package:flutter/material.dart';
import 'package:newway/components/colors.dart';
import 'package:newway/components/textfield.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final nametext = TextEditingController();
    final reputext = TextEditingController();
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Expanded(
          child: Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              SizedBox(
                width: 140,
                height: 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child:
                      const Image(image: AssetImage('lib/images/lettern.png')),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        'Change pic',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )),
              const SizedBox(
                height: 55,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Textfield(
                        controller: nametext,
                        hinttext: 'Enter your name (eg :- David)',
                        obscuretext: false),
                    const SizedBox(
                      height: 25,
                    ),
                    Textfield(
                        controller: reputext,
                        hinttext: 'Reputation',
                        obscuretext: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
