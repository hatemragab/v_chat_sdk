// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VConstraintImage extends StatelessWidget {
  final VMessageImageData data;
  final BorderRadius? borderRadius;
  final BoxFit? fit;

  const VConstraintImage({
    Key? key,
    required this.data,
    this.borderRadius,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      constraints: BoxConstraints(
        maxHeight: VPlatforms.isMobile ? height * .50 : height * .30,
        maxWidth: VPlatforms.isMobile ? width * .80 : width * .40,
      ),
      child: AspectRatio(
        aspectRatio: data.width / data.height,
        child: VPlatformCacheImageWidget(
          source: data.fileSource,
          borderRadius: borderRadius,
          fit: fit,
        ),
      ),
    );
  }
}
