import 'package:app/auth/views/welcome_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const WelcomePage() ),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
        bodyTextStyle: bodyStyle,
        descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        pageColor: Colors.white,
        imagePadding: EdgeInsets.zero,
        imageFlex: 3,
        bodyFlex: 2);

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Feature 1",
          decoration: pageDecoration,
          body:
              "Here you can write the description of the page, to explain someting...",
          image: Center(child: _buildImage('img1.jpg')),
        ),
        PageViewModel(
          title: "Feature 2",
          decoration: pageDecoration,
          body:
              "Here you can write the description of the page, to explain someting...",
          image: Center(
            child: _buildImage('img2.jpg'),
          ),
        ),
        PageViewModel(
            title: "Feature 3",
            decoration: pageDecoration,
            body:
                "Here you can write the description of the page, to explain someting...",
            image: Center(
              child: _buildImage('img3.jpg'),
            ),
            footer: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: () {}, child: Text('Masuk')),
                ElevatedButton(onPressed: () {}, child: Text('Daftar')),
              ],
            ))
      ],
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () {
        // When done button is press
        _onIntroEnd(context);
      },
      showNextButton: true,
      onChange: (pageId) {
        // swipe pageview callback
        // page id : 0, 1, 2 : turn on permission here
        print(pageId);
      },
      next: const Text('Next'),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
