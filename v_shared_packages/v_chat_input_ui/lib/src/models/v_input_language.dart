// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class VInputLanguage {
  final String textFieldHint;
  final String media;
  final String files;
  final String cancel;
  final String location;
  final String shareMediaAndLocation;
  final String thereIsVideoSizeBiggerThanAllowedSize;
  final String thereIsFileHasSizeBiggerThanAllowedSize;

  const VInputLanguage({
    this.textFieldHint = "Type your message...",
    this.media = "Media",
    this.files = "Files",
    this.cancel = "Cancel",
    this.location = "Location",
    this.shareMediaAndLocation = "Share media and location",
    this.thereIsVideoSizeBiggerThanAllowedSize =
        "There is video size bigger than allowed size",
    this.thereIsFileHasSizeBiggerThanAllowedSize =
        "There is File has size bigger than allowed size",
  });
}
