import 'package:flutter/material.dart';
import 'package:newway/classes/card_data.dart';
import 'package:newway/components/button.dart';
import 'package:newway/components/colors.dart';

class Moredetails extends StatefulWidget {
  final Cardcontent cc;
  const Moredetails({super.key, required this.cc});

  @override
  State<Moredetails> createState() => _MoredetailsState();
}

class _MoredetailsState extends State<Moredetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: [
                //Image.asset(widget.cc.imagepath),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            widget.cc.condition
                                ? const Row(
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Private',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                : const Row(
                                    children: [
                                      Icon(
                                        Icons.done,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Public',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                          ],
                        ),
                        const SizedBox(
                          height: 45,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.people,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.cc.price,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.label,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.cc.price,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 45,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'By ${widget.cc.author}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 45,
                ),
                Button(
                  text: 'Join funnel / ${widget.cc.price}',
                  onTap: () {},
                ),
                const SizedBox(
                  height: 55,
                ),
                Container(
                  child: const Text(
                    'Experience personalized fitness guidance with Ares Perera, a certified personal trainer dedicated to helping you achieve your unique fitness goals.',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                    child: const Text(
                  '1-on-1 Personal Training: Tailored workouts and personalized attention to help you reach your peak performance.',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                )),
                const SizedBox(
                  height: 25,
                ),
                Container(
                    child: const Text(
                  'Online Training: Customized workout plans, nutrition guidance, and ongoing support to fit your busy schedule',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                )),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
