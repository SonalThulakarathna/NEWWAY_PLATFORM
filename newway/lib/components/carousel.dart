import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int activeindex = 0;
  final images = [
    'lib/images/anime.jpg',
    'lib/images/anime.jpg',
    'lib/images/anime.jpg',
    'lib/images/anime.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider.builder(
                itemCount: images.length,
                itemBuilder: (context, index, realIndex) {
                  final urlimage = images[index];
                  return buildimage(urlimage, index);
                },
                options: CarouselOptions(
                  height: 300,
                  onPageChanged: (index, reason) =>
                      setState(() => activeindex = index),
                )),
            const SizedBox(
              height: 12,
            ),
            buildindicator(),
          ],
        ),
      ),
    );
  }

  Widget buildindicator() => AnimatedSmoothIndicator(
      effect: ExpandingDotsEffect(
          dotWidth: 10, activeDotColor: Colors.grey, dotHeight: 10),
      activeIndex: activeindex,
      count: images.length);
}

Widget buildimage(String urlimage, int index) => Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Image.asset(
        urlimage,
        fit: BoxFit.cover,
      ),
    );
