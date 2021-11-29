import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    onPrimary: Colors.white,
    primary: Colors.red,
    padding: const EdgeInsets.all(10),
  ),
);

final appBarTheme = AppBarTheme(
  elevation: 1,
  centerTitle: true,
  shadowColor: Colors.white,
  titleTextStyle: GoogleFonts.nunito(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
  backgroundColor: Colors.black54,
  iconTheme: const IconThemeData(color: Colors.white),
);

/// Default v chat dark theme
final vChatConstDarkTheme = ThemeData.dark().copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: Colors.black45,
    canvasColor: Colors.transparent,
    scaffoldBackgroundColor: const Color(0xff362421),
    iconTheme: const IconThemeData(color: Colors.white),
    dialogTheme: DialogTheme(
      contentTextStyle: const TextStyle(color: Colors.white, fontSize: 19),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 23),
      backgroundColor: Colors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        )),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.black38,
        elevation: 0,
        modalBackgroundColor: Colors.black45,
        modalElevation: 0),
    elevatedButtonTheme: elevatedButtonThemeData,
    textTheme: GoogleFonts.nunitoTextTheme().copyWith(
      headline6: GoogleFonts.nunito(fontWeight: FontWeight.w700, color: Colors.white),
      subtitle2:
          GoogleFonts.nunito(letterSpacing: .1, color: Colors.white70, fontSize: 15, fontWeight: FontWeight.normal),
      bodyText2:
          GoogleFonts.nunito(color: Colors.white, fontSize: 19, fontWeight: FontWeight.normal, letterSpacing: .15),
      bodyText1: GoogleFonts.nunito(color: Colors.white, fontSize: 19, letterSpacing: .5),
      subtitle1:
          GoogleFonts.nunito(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal, letterSpacing: .15),
      caption: GoogleFonts.nunito(
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.black,
    appBarTheme: appBarTheme,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.redAccent));
