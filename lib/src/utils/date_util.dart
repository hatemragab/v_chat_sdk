import 'package:intl/intl.dart';
import '../services/v_chat_app_service.dart';


class UtilDates {
  UtilDates._();
  static const int oneDayInMilliseconds = 86400000;

  static final daysOfWeek = [
    VChatAppService.instance.getTrans().monday(),
    VChatAppService.instance.getTrans().tuesday(),
    VChatAppService.instance.getTrans().wednesday(),
    VChatAppService.instance.getTrans().thursday(),
    VChatAppService.instance.getTrans().friday(),
    VChatAppService.instance.getTrans().saturday(),
    VChatAppService.instance.getTrans().sunday(),
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
      return VChatAppService.instance.getTrans().yesterday();
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
      return VChatAppService.instance.getTrans().toDay();
    }

    if (daysSinceMessage == 1) {
      return VChatAppService.instance.getTrans().yesterday();
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
