import 'package:flutter/material.dart';
import 'package:newway/classes/authservice.dart';
import 'package:newway/classes/card_data.dart';
import 'package:newway/components/button.dart';
import 'package:newway/components/carousel.dart';
import 'package:newway/pages/funnel%20pages/funnel_inside_tabbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Moredetails extends StatefulWidget {
  final Cardcontent cc;
  const Moredetails({super.key, required this.cc});

  @override
  State<Moredetails> createState() => _MoredetailsState();
}

final supabase = Supabase.instance.client;
final auth = Authservicelog();

class _MoredetailsState extends State<Moredetails> {
  void funnelinside(Cardcontent card) async {
    final cuser = auth.getuserid(); // Get current user ID

    try {
      await supabase.from('funnelmembers').insert({
        'userid': cuser,
        'funnelid': card.id,
      });

      // If no exception, insert was successful, navigate
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FunnelInsideTabbar(card: card),
        ),
      );
    } catch (e) {
      // Handle error case
      print("Error joining funnel: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E2E),
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
                Carousel(),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            if (widget.cc.condition == 'private')
                              Row(
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
                            else
                              Row(
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
                const SizedBox(
                  height: 25,
                ),
                Container(
                    child: Text(
                  widget.cc.subtitle,
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
