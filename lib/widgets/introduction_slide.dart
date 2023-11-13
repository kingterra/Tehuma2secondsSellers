import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../splashScreen/banner_clipper.dart';

class IntroductionSlide extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String message;
  final Function() onButtonPressed;

  IntroductionSlide({
    required this.imageAsset,
    required this.title,
    required this.message,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "2 seconds logistics",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: ClipPath(
              clipper: BannerClipper(),
              child: Container(
                color: Colors.blue,
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height / 2,
                  width: double.infinity,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}