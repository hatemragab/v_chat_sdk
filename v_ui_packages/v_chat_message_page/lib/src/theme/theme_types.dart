import 'package:flutter/material.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../widgets/message_items/shared/bubble_special_one.dart';
import '../widgets/message_items/widgets/date_divider_item.dart';

typedef LocationTypeDef = Widget Function(
  BuildContext context,
  bool isMeSender,
  VLocationMessageData data,
);
typedef ReplyTypeDef = Widget Function(
  BuildContext context,
  VBaseMessage orginalMessage,
  VBaseMessage repliedMessage,
);
typedef FileTypeDef = Widget Function(
  BuildContext context,
  bool isMeSender,
  VMessageFileData data,
);

typedef CustomTypeDef = Widget Function(
  BuildContext context,
  bool isMeSender,
  VCustomMsgData data,
);

typedef InfoTypeDef = Widget Function(
  BuildContext context,
  bool isMeSender,
  VMsgInfoAtt data,
);

typedef AllDeletedTypeDef = Widget Function(
  BuildContext context,
  bool isMeSender,
);
typedef CallTypeDef = Widget Function(
  BuildContext context,
  bool isMeSender,
  VMsgCallAtt data,
);

typedef ImageTypeDef = Widget Function(
  BuildContext context,
  bool isMeSender,
  VMessageImageData data,
);
typedef TextTypeDef = TextStyle Function(
  BuildContext context,
  bool isMeSender,
);

typedef ItemHolderColorTypeDef = Color Function(
  BuildContext context,
  bool isMeSender,
  bool isDarkMode,
);
typedef VideoTypeDef = Widget Function(
  BuildContext context,
  bool isMeSender,
  VMessageVideoData data,
);

typedef ItemHolderTypeDef = Widget Function(
  BuildContext context,
  bool isMeSender,
  Widget child,
);
typedef DateDividerTypeDef = Widget Function(
  BuildContext context,
  DateTime child,
);

typedef FooterTypeDef = Widget Function(
  BuildContext context,
  DateTime createdAt,
  bool isBroadcast,
);

Widget getDateDividerWidget(BuildContext context, DateTime dateTime) {
  return DateDividerItem(dateTime: dateTime);
}

const _darkMeSenderColor = Colors.indigo;
const _darkReceiverColor = Color(0xff515156);

const _lightReceiverColor = Color(0xffffffff);
const _lightMySenderColor = Color(0xff96f3aa);

Widget getMessageItemHolder(
  BuildContext context,
  bool isMeSender,
  Widget child,
) {
  final isRtl = context.isRtl;
  return Container(
    constraints: BoxConstraints(
      maxWidth: VPlatforms.isMobile
          ? MediaQuery.of(context).size.width * .75
          : MediaQuery.of(context).size.width * .50,
    ),
    child: BubbleSpecialOne(
      isSender: isMeSender,
      isRtl: isRtl,
      tail: true,
      color: context.vMessageTheme.messageItemHolderColor(
        context,
        isMeSender,
        context.isDark,
      ),
      child: child,
    ),
  );
}

Color _getMessageColor(bool isSender, bool isDark) {
  if (isDark && isSender) {
    return _darkMeSenderColor;
  } else if (isDark && !isSender) {
    return _darkReceiverColor;
  } else if (!isDark && isSender) {
    return _lightMySenderColor;
  } else {
    return _lightReceiverColor;
  }
}

Color getMessageItemHolderColor(
  BuildContext context,
  bool isMeSender,
  bool isDarkMode,
) {
  return _getMessageColor(isMeSender, context.isDark);
}

TextStyle getTextWidget(
  BuildContext context,
  bool isMeSender,
) {
  return Theme.of(context)
      .textTheme
      .bodyLarge!
      .merge(const TextStyle(fontSize: 17));
}
