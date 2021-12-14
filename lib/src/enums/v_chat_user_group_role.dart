import 'package:flutter/foundation.dart';

enum VChatUserGroupRole { member, admin }

extension VChatUserGroupRoleEnum on VChatUserGroupRole {
  String get inString => describeEnum(this);
}
