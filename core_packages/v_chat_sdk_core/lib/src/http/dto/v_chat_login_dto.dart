// // Copyright 2023, the hatemragab project author.
// // All rights reserved. Use of this source code is governed by a
// // MIT license that can be found in the LICENSE file.
//
// /// `VChatLoginDto` is a Data Transfer Object (DTO) class for sending
// /// login data to the VChat API.
// class VChatLoginDto {
//   /// The identifier for a user. This could be a username or a unique ID.
//   final String identifier;
//
//   /// The unique device ID from which the user is logging in.
//   final String deviceId;
//
//   /// The language used by the user, typically in ISO 639-1 format.
//   final String language;
//
//   /// The push notification key for the user's device. This is optional.
//   String? pushKey;
//
//   /// The platform the user is logging in from.
//   final String platform;
//
//   /// The user's password.
//   final String password;
//
//   /// A constructor to create an instance of `VChatLoginDto`.
//   ///
//   /// Requires [identifier], [deviceId], [language], [platform], and [password]
//   /// to be non-null, while [pushKey] is optional.
//   VChatLoginDto({
//     required this.identifier,
//     required this.deviceId,
//     required this.language,
//     required this.platform,
//     required this.password,
//     this.pushKey,
//   });
//
//   /// Converts the object properties to a Map with String keys and dynamic values.
//   ///
//   /// The map can be easily converted to a JSON format for data transfer.
//   ///
//   /// Returns a Map containing user's identifier, device ID, language, push key,
//   /// password, and platform.
//   Map<String, dynamic> toMap() {
//     return {
//       "identifier": identifier,
//       "deviceId": deviceId,
//       "language": language,
//       "pushKey": pushKey,
//       "password": password,
//       "platform": platform,
//     };
//   }
// }
