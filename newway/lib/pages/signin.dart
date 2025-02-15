import 'package:flutter/material.dart';
import 'package:newway/auth/auth_email.dart';
import 'package:newway/components/auth_tile.dart';
import 'package:newway/components/button.dart';
import 'package:newway/components/colors.dart';
import 'package:newway/components/textfield.dart';
import 'package:newway/pages/bottom_nav_bar.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final authservice = Authservise();

  void userSignUp() async {
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
      }
      return;
    }

    try {
      await authservice.emailpassSignUp(email, password);

      // If registration is successful, navigate to the home page
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
      body: Padding(
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
              "Create a new account",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 25),
            //textfields
            Textfield(
              controller: emailController,
              hinttext: 'Email',
              obscuretext: false,
            ),
            const SizedBox(
              height: 10,
            ),
            Textfield(
              controller: passwordController,
              hinttext: 'Password',
              obscuretext: true,
            ),
            const SizedBox(
              height: 10,
            ),
            Textfield(
              controller: confirmPasswordController,
              hinttext: 'Confirm Password',
              obscuretext: true,
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Button(
                text: "Sign Up",
                onTap: userSignUp,
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
                  "Already a member?",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                SizedBox(
                  width: 5,
                ),
                Text("Login now",
                    style: TextStyle(color: Colors.blue, fontSize: 15)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
