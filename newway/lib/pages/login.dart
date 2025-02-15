import 'package:flutter/material.dart';
import 'package:newway/auth/auth_email.dart';
import 'package:newway/components/auth_tile.dart';
import 'package:newway/components/button.dart';
import 'package:newway/components/colors.dart';
import 'package:newway/components/textfield.dart';
import 'package:newway/pages/bottom_nav_bar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final username = TextEditingController();
  final authservice = Authservise();
  final password = TextEditingController();

  void usersignin() async {
    final email = username.text;
    final pass = password.text;

    /*try {
      await authservice.emailpass(email, pass);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error : $e')));
      }
    }*/

    try {
      await authservice.emailpass(email, pass);

      // If login is successful, navigate to the home page
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
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
              const SizedBox(height: 25),
              //text
              const Text(
                "Welcome back you've been missed",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 25),
              //textares
              Textfield(
                controller: username,
                hinttext: 'Username',
                obscuretext: false,
              ),
              const SizedBox(
                height: 10,
              ),
              Textfield(
                controller: password,
                hinttext: 'Password',
                obscuretext: true,
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Button(
                  text: "Sign in",
                  onTap: usersignin,
                ),
              ),
              const SizedBox(
                height: 50,
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Atile(path: 'lib/images/google.png'),
                  SizedBox(
                    width: 25,
                  ),
                  Atile(path: 'lib/images/apple.png')
                ],
              ),
              const SizedBox(
                height: 50,
              ),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Register now",
                      style: TextStyle(color: Colors.blue, fontSize: 15)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
