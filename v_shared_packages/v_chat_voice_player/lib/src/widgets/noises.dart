// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class Noises extends StatelessWidget {
  final List<double> rList;
  final Color activeSliderColor;

  const Noises({
    Key? key,
    required this.rList,
    required this.activeSliderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: rList.map((e) => _singleNoise(e)).toList(),
    );
  }

  Widget _singleNoise(double height) {
    return Container(
      //  margin: EdgeInsets.symmetric(horizontal: 2),
      width: 3,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: activeSliderColor,
      ),
    );
  }
}
