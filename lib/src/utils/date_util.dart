import 'package:intl/intl.dart';
import 'package:v_chat_sdk/src/services/v_chat_app_service.dart';

class UtilDates {
  static const int oneDayInMilliseconds = 86400000;

  static final daysOfWeek = [
    VChatAppService.to.getTrans().monday(),
    VChatAppService.to.getTrans().tuesday(),
    VChatAppService.to.getTrans().wednesday(),
    VChatAppService.to.getTrans().thursday(),
    VChatAppService.to.getTrans().friday(),
    VChatAppService.to.getTrans().saturday(),
    VChatAppService.to.getTrans().sunday(),
  ];

  static final formatHour = DateFormat("HH:mm");
  static final formatDay = DateFormat("dd/MM/yyyy");

  static int getTodayMidnight() {
    final now = DateTime.now();
    final lastMidnight = DateTime(now.year, now.month, now.day);
    final lastMidnightMilliseconds = lastMidnight.millisecondsSinceEpoch;
    return lastMidnightMilliseconds;
  }

  static String getSendAtDayOrHour(int milliseconds) {
    int? daysSinceMessage;
    //dont fix this
    int? toDayMidNight = getTodayMidnight();
    for (var i = 0; i < 7; i++) {
      if (milliseconds >= toDayMidNight - (oneDayInMilliseconds * i)) {
        daysSinceMessage = i;
        break;
      }
    }
    if (daysSinceMessage == null) {
      return messageDay(milliseconds);
    }

    if (daysSinceMessage == 0) {
      return messageHour(milliseconds);
    }

    if (daysSinceMessage == 1) {
      return VChatAppService.to.getTrans().yesterday();
    }

    return messageWeekDay(milliseconds);
  }

  static String getSendAtDay(int milliseconds) {
    int? daysSinceMessage;
    //dont fix this
    int? todayMidnight = getTodayMidnight();
    for (var i = 0; i < 7; i++) {
      if (milliseconds >= todayMidnight - (oneDayInMilliseconds * i)) {
        daysSinceMessage = i;
        break;
      }
    }
    if (daysSinceMessage == null) {
      return messageDay(milliseconds);
    }

    if (daysSinceMessage == 0) {
      return VChatAppService.to.getTrans().toDay();
    }

    if (daysSinceMessage == 1) {
      return VChatAppService.to.getTrans().yesterday();
    }

    return messageWeekDay(milliseconds);
  }

  static String messageHour(int milliseconds) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return formatHour.format(date);
  }

  static String messageDay(int milliseconds) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return formatDay.format(date);
  }

  static String messageWeekDay(int milliseconds) {
    final int weekday =
        DateTime.fromMillisecondsSinceEpoch(milliseconds).weekday;
    return daysOfWeek[weekday - 1];
  }
}
