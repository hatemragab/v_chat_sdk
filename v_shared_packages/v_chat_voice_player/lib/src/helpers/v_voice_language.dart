// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class VVoiceLanguage {
  final String x1;
  final String x1_25;
  final String x1_50;
  final String x1_75;
  final String x2;

  VVoiceLanguage({
    this.x1 = "x1",
    this.x1_25 = "x 1.25",
    this.x1_50 = "x 1.50",
    this.x1_75 = "x 1.75",
    this.x2 = "x2",
  });

  VVoiceLanguage copyWith({
    String? x1,
    String? x1_25,
    String? x1_50,
    String? x1_75,
    String? x2,
  }) {
    return VVoiceLanguage(
      x1: x1 ?? this.x1,
      x1_25: x1_25 ?? this.x1_25,
      x1_50: x1_50 ?? this.x1_50,
      x1_75: x1_75 ?? this.x1_75,
      x2: x2 ?? this.x2,
    );
  }
}
