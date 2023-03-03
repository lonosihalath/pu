

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

List<String> images = [
  'images/branner.png',
  'images/branner2.png',
];
var selected1 = images[0];


class BrannerSlider extends StatefulWidget {
  const BrannerSlider({Key? key}) : super(key: key);

  @override
  State<BrannerSlider> createState() => _BrannerSliderState();
}

class _BrannerSliderState extends State<BrannerSlider> {
  @override
  Widget build(BuildContext context) {
       double screen = MediaQuery.of(context).size.width;
    double screen1 = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            height: screen*0.45,
            width: screen,
            child: CarouselSlider(
              options: CarouselOptions(
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                  viewportFraction: 1.0,
                  //enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      selected1 = images[index];
                    });
                  },
                  autoPlay: true
                  // autoPlay: false,
                  ),
              items: images
                  .map((item) => Container(
                      margin: EdgeInsets.only(left: screen*0.05, right: screen*0.05),
                      width: screen,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          item,
                          fit: BoxFit.values[0],
                        ),
                      )))
                  .toList(),
            ),
          ),
          SizedBox(height: 5),
          Container(
              width: screen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    images.length,
                    (index) => Container(
                          margin: const EdgeInsets.all(4),
                          width: selected1 == images[index]
                                ? 25.0:8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: selected1 == images[index]
                                ? Color(0xFF293275)
                                : Colors.grey.shade300,
                          ),
                        )),
              ),
            ),
      ],
    );
    
  }
}