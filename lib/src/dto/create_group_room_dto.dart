import 'dart:convert';
import 'dart:io';

import '../enums/room_type.dart';

class CreateGroupRoomDto {
  final List<String> usersEmails;
  final String groupTitle;
  final File groupImage;

//<editor-fold desc="Data Methods">

  const CreateGroupRoomDto({
    required this.usersEmails,
    required this.groupTitle,
    required this.groupImage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreateGroupRoomDto &&
          runtimeType == other.runtimeType &&
          usersEmails == other.usersEmails &&
          groupTitle == other.groupTitle &&
          groupImage == other.groupImage);

  @override
  int get hashCode =>
      usersEmails.hashCode ^ groupTitle.hashCode ^ groupImage.hashCode;

  @override
  String toString() {
    return 'CreateGroupRoomDto{' +
        ' usersEmails: $usersEmails,' +
        ' groupTitle: $groupTitle,' +
        ' groupImage: $groupImage,' +
        '}';
  }

  CreateGroupRoomDto copyWith({
    List<String>? usersEmails,
    String? groupTitle,
    File? groupImage,
  }) {
    return CreateGroupRoomDto(
      usersEmails: usersEmails ?? this.usersEmails,
      groupTitle: groupTitle ?? this.groupTitle,
      groupImage: groupImage ?? this.groupImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usersEmails': this.usersEmails,
      'groupTitle': this.groupTitle,
      'groupImage': this.groupImage,
    };
  }

  factory CreateGroupRoomDto.fromMap(Map<String, dynamic> map) {
    return CreateGroupRoomDto(
      usersEmails: map['usersEmails'] as List<String>,
      groupTitle: map['groupTitle'] as String,
      groupImage: map['groupImage'] as File,
    );
  }

//</editor-fold>
}
