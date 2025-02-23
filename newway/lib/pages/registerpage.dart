import 'package:flutter/material.dart';
import 'package:newway/classes/authservice.dart';
import 'package:newway/components/auth_tile.dart';
import 'package:newway/components/button.dart';
import 'package:newway/components/colors.dart';
import 'package:newway/components/textfield.dart';
import 'package:newway/pages/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final authservice = Authservicelog();
  final supabase = Supabase.instance.client;
  final email = TextEditingController();
  final password = TextEditingController();
  final repassword = TextEditingController();

  void signup() async {
    final signemail = email.text;
    final signpass = password.text;

    final signrepass = repassword.text;

    if (signpass != signrepass) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Password dosent match')));
      return;
    }
    try {
      await authservice.signupemailpass(signemail, signrepass);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('error : $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: primary,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //image
            Center(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Image.asset(
                  'lib/images/lettern.png',
                  height: 100,
                ),
              ),
            ),

            const SizedBox(
              height: 25,
            ),
            Textfield(controller: email, hinttext: 'Email', obscuretext: false),
            const SizedBox(
              height: 25,
            ),
            Textfield(
                controller: password, hinttext: 'Password', obscuretext: false),
            const SizedBox(
              height: 25,
            ),
            Textfield(
                controller: repassword,
                hinttext: 'Re enter password',
                obscuretext: false),
            const SizedBox(
              height: 55,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Button(
                text: 'Register',
                onTap: signup,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Expanded(
                      child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Or continue with",
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
                    ),
                  ),
                  Expanded(
                      child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  )),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Atile(path: 'lib/images/google.png'),
                const SizedBox(
                  width: 25,
                ),
                Atile(path: 'lib/images/apple.png')
              ],
            ),
          ],
        ),
      )),
    );
  }
}
