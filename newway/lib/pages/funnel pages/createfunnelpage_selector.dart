import 'package:flutter/material.dart';
import 'package:newway/pages/funnel%20pages/createfunnel_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CreatefunnelpageSelector extends StatefulWidget {
  const CreatefunnelpageSelector({super.key});

  @override
  State<CreatefunnelpageSelector> createState() =>
      _CreatefunnelpageSelectorState();
}

class _CreatefunnelpageSelectorState extends State<CreatefunnelpageSelector> {
  PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [CreatefunnelPage()],
          ),
          Container(
              alignment: Alignment(0, 0.99),
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SmoothPageIndicator(controller: _controller, count: 2),
                ],
              )),
        ],
      ),
    );
  }
}
