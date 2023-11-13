import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../authentication/auth_screen.dart';
import '../widgets/introduction_slide.dart';
import 'banner_clipper.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  bool _initialized = false;

  List<IntroductionSlide> _slides = [];

  @override
  void initState() {
    super.initState();
    _initializeSlides();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page?.round() ?? 0;
      });
    });
  }

  void _initializeSlides() {
    if (!_initialized) {
      _slides = [
        IntroductionSlide(
          imageAsset: "images/packing.png",
          title: "Sell Food Online",
          message: "Empower your restaurant",
          onButtonPressed: _nextScreen,
        ),
        IntroductionSlide(
          imageAsset: "images/stone1.mp4",
          title: "Empower Your Supermarket",
          message: "Discover new opportunities",
          onButtonPressed: _nextScreen,
        ),
        IntroductionSlide(
          imageAsset: "images/backgroundImage.jpg",
          title: "Your Custom Title",
          message: "Your Custom Message",
          onButtonPressed: _nextScreen,
        ),
      ];
      _initialized = true;
      print("_slides initialized. Length: ${_slides.length}");
    }
    print("_initialized: $_initialized");
    print("_slides length: ${_slides.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
          Expanded(
          child: Container(
          height: 400,
            child: Stack(
              children: [
                ClipPath(
                  clipper: BannerClipper(),
                  child: Container(
                    color: Colors.blue,
                  ),
                ),
                PageView.builder(
                  controller: _controller,
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    return _slides[index];
                  },
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
          AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: _currentPage == 0
              ? SizedBox.shrink()
              : Column(
            key: ValueKey<int>(_currentPage),
            children: [
              Text(
                _slides[_currentPage].title,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              Text(
                _slides[_currentPage].message,
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        _currentPage != 0
        ? ElevatedButton(
        onPressed: _previousScreen,
          child: Text("Previous"),
        )
            : Container(),
    Container(
    height: 20.0,
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: _buildPageIndicator(),
    ),
    ),
            ElevatedButton(
              onPressed: _nextScreen,
              child: Text("Next"),
            ),
          ],
        ),
              ],
          ),
        ),
            ],
          ),
        ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];

    if (_slides.isNotEmpty) {
      for (int i = 0; i < _slides.length; i++) {
        indicators.add(
          Container(
            width: _currentPage == i ? 20.0 : 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              color: _currentPage == i ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        );
      }
    }

    return indicators;
  }

  void _nextScreen() {
    if (_currentPage == _slides.length - 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen()),
      );
    } else {
      _controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousScreen() {
    _controller.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
