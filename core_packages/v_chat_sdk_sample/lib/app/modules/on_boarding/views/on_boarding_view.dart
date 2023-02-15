// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';

import '../controllers/on_boarding_controller.dart';

class OnBoardingView extends GetView<OnBoardingController> {
  final introKey = GlobalKey<IntroductionScreenState>();

  OnBoardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.zero,
    );
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: IntroductionScreen(
            key: introKey,
            pages: [
              PageViewModel(
                title: "Login or register",
                body: '''
               * welcome to the most cheep chat system provider no firebase used for save chat data! 
               * this example just work on the firebase for login and register but the purpose of this 
                 example to show how to integrate chat to your existing or new system
               * v chat support social login and phone login through
                 just send the user id which you has inserted in your system the data base \n
               *  
                ''',
                image: _buildImage('images/logo.png'),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "V Chat sdk v2",
                body: "V Chat sdk v2",
                image: _buildImage('images/logo.png'),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "V Chat sdk v2",
                body: "V Chat sdk v2",
                image: _buildImage('images/logo.png'),
                decoration: pageDecoration,
              ),
            ],
            onDone: () => _onIntroEnd(context),
            //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
            showSkipButton: false,
            skipOrBackFlex: 0,
            nextFlex: 0,
            showBackButton: true,
            //rtl: true, // Display as right-to-left
            back: const Icon(Icons.arrow_back),
            skip: const Text('Skip',
                style: TextStyle(fontWeight: FontWeight.w600)),
            next: const Icon(Icons.arrow_forward),
            done: const Text('Done',
                style: TextStyle(fontWeight: FontWeight.w600)),
            curve: Curves.fastLinearToSlowEaseIn,
            controlsMargin: const EdgeInsets.all(16),
            controlsPadding: kIsWeb
                ? const EdgeInsets.all(12.0)
                : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  _onIntroEnd(BuildContext context) {
    Get.offAndToNamed(Routes.SPLASH);
  }
}
