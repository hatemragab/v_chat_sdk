// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class VInputLanguage {
  final String textFieldHint;
  final String media;
  final String files;
  final String location;
  final String shareMediaAndLocation;

  const VInputLanguage({
    this.textFieldHint = "Type your message...",
    this.media = "Media",
    this.files = "Files",
    this.location = "Location",
    this.shareMediaAndLocation = "Share media and location",
  });

  VInputLanguage copyWith({
    String? textFieldHint,
    String? media,
    String? files,
    String? location,
    String? shareMediaAndLocation,
  }) {
    return VInputLanguage(
      textFieldHint: textFieldHint ?? this.textFieldHint,
      media: media ?? this.media,
      files: files ?? this.files,
      location: location ?? this.location,
      shareMediaAndLocation:
          shareMediaAndLocation ?? this.shareMediaAndLocation,
    );
  }
}
