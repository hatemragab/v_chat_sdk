import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:v_chat_sdk/src/services/v_chat_app_service.dart';

enum Days { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class UtilDates {
  UtilDates._();

  static const int oneDayInMilliseconds = 86400000;

  static final daysOfWeek = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  static final formatHour = DateFormat("HH:mm");
  static final formatDay = DateFormat("dd/MM/yyyy");

  static int getTodayMidnight() {
    final now = DateTime.now();
    final lastMidnight = DateTime(now.year, now.month, now.day);
    final lastMidnightMilliseconds = lastMidnight.millisecondsSinceEpoch;
    return lastMidnightMilliseconds;
  }

  // static String getSendAtDayOrHour(int milliseconds) {
  //   int? daysSinceMessage;
  //   //dont fix this
  //   int? toDayMidNight = getTodayMidnight();
  //   for (var i = 0; i < 7; i++) {
  //     if (milliseconds >= toDayMidNight - (oneDayInMilliseconds * i)) {
  //       daysSinceMessage = i;
  //       break;
  //     }
  //   }
  //   if (daysSinceMessage == null) {
  //     return messageDay(milliseconds);
  //   }
  //
  //   if (daysSinceMessage == 0) {
  //     return messageHour(milliseconds);
  //   }
  //
  //   if (daysSinceMessage == 1) {
  //     return VChatAppService.instance.getTrans().yesterday();
  //   }
  //
  //   return messageWeekDay(milliseconds);
  // }

  static String getSendAtDay(BuildContext context, int milliseconds) {
    int? daysSinceMessage;

    final int todayMidnight = getTodayMidnight();
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
      return VChatAppService.instance.getTrans(context).toDay();
    }

    if (daysSinceMessage == 1) {
      return VChatAppService.instance.getTrans(context).yesterday();
    }

    return messageWeekDay(context, milliseconds);
  }

  static String messageHour(int milliseconds) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return formatHour.format(date);
  }

  static String messageDay(int milliseconds) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return formatDay.format(date);
  }

  static String messageWeekDay(BuildContext context, int milliseconds) {
    final weekday = DateTime.fromMillisecondsSinceEpoch(milliseconds).weekday;
    final day = daysOfWeek[weekday - 1];
    final service = VChatAppService.instance.getTrans(context);
    if (day == "monday") {
      return service.monday();
    }
    if (day == "tuesday") {
      return service.tuesday();
    }
    if (day == "wednesday") {
      return service.wednesday();
    }
    if (day == "thursday") {
      return service.thursday();
    }
    if (day == "friday") {
      return service.friday();
    }
    if (day == "saturday") {
      return service.saturday();
    }
    if (day == "sunday") {
      return service.sunday();
    }
    return daysOfWeek[weekday - 1];
  }
}
