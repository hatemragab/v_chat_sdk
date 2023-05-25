// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

abstract class VStringUtils {
  static final vMentionRegExp = RegExp(r"\[(@[^:]+):([^\]]+)\]");

  static String parseVMentions(
    String txt, {
    bool withOutAt = false,
  }) {
    return txt.replaceAllMapped(
      VStringUtils.vMentionRegExp,
      (match) {
        final matchTxt = match.group(1)!;
        if (withOutAt) {
          return matchTxt.replaceFirst("@", "");
        }
        return matchTxt;
      },
    );
  }

  static String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
