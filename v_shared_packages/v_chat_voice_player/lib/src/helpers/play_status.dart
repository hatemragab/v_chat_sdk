// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

enum PlayStatus { init, playing, pause, stop, downloading, downloadError }

enum PlaySpeed { x1, x1_25, x1_5, x1_75, x2 }

extension GetSpeed on PlaySpeed {
  double get getSpeed {
    switch (this) {
      case PlaySpeed.x1:
        return 1.0;
      case PlaySpeed.x1_25:
        return 1.25;
      case PlaySpeed.x1_5:
        return 1.50;
      case PlaySpeed.x1_75:
        return 1.75;
      case PlaySpeed.x2:
        return 2.00;
    }
  }
}
