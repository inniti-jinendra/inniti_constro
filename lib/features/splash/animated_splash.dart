import 'dart:async';
import 'dart:math'; // Import missing 'dart:math' for 'pi'.
import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';


class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(
            top: -20,
            left: -160,
            child: Row(
              children: [
                ScrollingImages(startingIndex: 0),
                ScrollingImages(startingIndex: 1),
                ScrollingImages(startingIndex: 2),
              ],
            ),
          ),
          // const Positioned(
          //     top: 40,
          //     child: Text(
          //       "ERP",
          //       textScaleFactor: 2.5,
          //       textAlign: TextAlign.center,
          //       style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
          //     )),
          Positioned(
              bottom: 0,
              child: Container(
                height: h * 0.55,
                width: w,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    // gradient: LinearGradient(
                    //     colors: [
                    //       Color(0xFF7117EA), // Light Blue
                    //       Color(0xFFEA6060), // Vibrant Orange
                    //     ],
                    //     begin: Alignment.topCenter,
                    //     end: Alignment.center)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    children: [
                      const Spacer(),
                      const Text(
                        "Transform Your Business Efficiency",
                        textScaleFactor: 2.5,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Roboto'),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Empower your business with the MNIML ERP system – An all-in-one solution for streamlined management and growth.",
                        textScaleFactor: 1.1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto'),
                      ),
                      const SizedBox(height: 40),
                      InkWell(
                        onTap: () {
                          // Handle onTap event here
                          // Navigate to Onboarding screen
                          Navigator.pushReplacementNamed(context, AppRoutes.WelcomCompnyCode);

                        },
                        child: Container(
                          height: 60,
                          width: w * 0.8,
                          decoration: BoxDecoration(
                              color: Colors.deepPurpleAccent,
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.blueAccent,
                                  offset: Offset(0, 4),
                                  blurRadius: 6,
                                )
                              ]),
                          child: const Center(
                            child: Text(
                              "Get Started",
                              textScaleFactor: 1.3,
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class ScrollingImages extends StatefulWidget {
  final int startingIndex;

  const ScrollingImages({
    Key? key,
    required this.startingIndex,
  }) : super(key: key);

  @override
  State<ScrollingImages> createState() => _ScrollingImagesState();
}

class _ScrollingImagesState extends State<ScrollingImages> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset ==
          _scrollController.position.minScrollExtent) {
        _autoScrollForward();
      } else if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        _autoScrollbackward();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoScrollForward();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _autoScrollForward() {
    final currentPosition = _scrollController.offset;
    final endPosition = _scrollController.position.maxScrollExtent;
    scheduleMicrotask(() {
      _scrollController.animateTo(
          currentPosition == endPosition ? 0 : endPosition,
          duration: Duration(seconds: 20 + widget.startingIndex + 2),
          curve: Curves.linear);
    });
  }

  _autoScrollbackward() {
    final currentPosition = _scrollController.offset;
    final endPosition = _scrollController.position.minScrollExtent;
    scheduleMicrotask(() {
      _scrollController.animateTo(
          currentPosition == endPosition ? 0 : endPosition,
          duration: Duration(seconds: 20 + widget.startingIndex + 2),
          curve: Curves.linear);
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Transform.rotate(
      angle: 1.96 * pi,
      child: SizedBox(
        height: h * 0.6,
        width: w * 0.6,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: 11, // Since there are 11 images.
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(20),
              margin: const EdgeInsets.only(right: 8, left: 8, top: 10),
              height: h * 0.6,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                  image: AssetImage('assets/images/animated_splash_images/${index + 1}.png'),
                  fit: BoxFit.fill,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(2, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
