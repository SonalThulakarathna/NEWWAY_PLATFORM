import 'package:flutter/material.dart';
import 'package:newway/components/colors.dart';

class ProfilefunnelStatuspage extends StatefulWidget {
  const ProfilefunnelStatuspage({super.key});

  @override
  State<ProfilefunnelStatuspage> createState() =>
      _ProfilefunnelStatuspageState();
}

class _ProfilefunnelStatuspageState extends State<ProfilefunnelStatuspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    height: 200,
                    width: 145,
                    decoration: BoxDecoration(
                        color: textfieldgrey,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people,
                          color: Colors.white,
                          size: 35,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          '20',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'members',
                          style: TextStyle(
                              color: const Color.fromARGB(236, 158, 158, 158),
                              fontSize: 18),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    height: 200,
                    width: 145,
                    decoration: BoxDecoration(
                        color: textfieldgrey,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.money,
                          color: Colors.white,
                          size: 35,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          '1657.00',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Income',
                          style: TextStyle(
                              color: const Color.fromARGB(236, 158, 158, 158),
                              fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
