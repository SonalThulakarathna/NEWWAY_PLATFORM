import 'package:flutter/material.dart';
import 'package:newway/classes/card_data.dart';
import 'package:newway/components/button.dart';
import 'package:newway/components/colors.dart';
import 'package:newway/pages/funnel%20pages/funnel_inside_tabbar.dart';

class Moredetails extends StatefulWidget {
  final Cardcontent cc;
  const Moredetails({super.key, required this.cc});

  @override
  State<Moredetails> createState() => _MoredetailsState();
}

class _MoredetailsState extends State<Moredetails> {
  void funnelinside(Cardcontent card) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FunnelInsideTabbar(card: card)),
    );
  }

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
                                ? Row(
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
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
                                : Row(
                                    children: [
                                      Icon(
                                        Icons.done,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
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
                            Icon(
                              Icons.people,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.cc.price,
                              style: TextStyle(
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
                            Icon(
                              Icons.label,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.cc.price,
                              style: TextStyle(
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
                            Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'By ' + widget.cc.author,
                              style: TextStyle(
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
                  text: 'Join funnel / ' + widget.cc.price,
                  onTap: () => funnelinside(widget.cc),
                ),
                const SizedBox(
                  height: 55,
                ),
                Container(
                  child: Text(
                    'Experience personalized fitness guidance with Ares Perera, a certified personal trainer dedicated to helping you achieve your unique fitness goals.',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                    child: Text(
                  '1-on-1 Personal Training: Tailored workouts and personalized attention to help you reach your peak performance.',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                )),
                const SizedBox(
                  height: 25,
                ),
                Container(
                    child: Text(
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
