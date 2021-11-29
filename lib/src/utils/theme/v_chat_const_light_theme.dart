import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    elevation: 0,
    onSurface: Colors.black,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    onPrimary: Colors.white,
    primary: Colors.red,
    padding: const EdgeInsets.all(10),
  ),
);

final appBarTheme = AppBarTheme(
  elevation: 1,
  centerTitle: true,
  titleTextStyle: GoogleFonts.nunito(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w800),
  backgroundColor: Colors.white,
  iconTheme: const IconThemeData(color: Colors.red),
);

/// Default v chat light theme
final vChatConstLightTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: Colors.red,
  canvasColor: Colors.transparent,
  scaffoldBackgroundColor: Colors.white,
  iconTheme: const IconThemeData(color: Colors.red),
  dialogTheme: DialogTheme(
    contentTextStyle: const TextStyle(color: Colors.black, fontSize: 19),
    titleTextStyle: const TextStyle(color: Colors.black, fontSize: 23),
    backgroundColor: Colors.white,
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
    backgroundColor: Colors.white,
    elevation: 0,
    modalBackgroundColor: Colors.white,
    modalElevation: 0,
  ),
  elevatedButtonTheme: elevatedButtonThemeData,
  textTheme: GoogleFonts.nunitoTextTheme().copyWith(
    headline6: GoogleFonts.nunito(fontWeight: FontWeight.w700),
    subtitle2: GoogleFonts.nunito(
      letterSpacing: .1,
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.normal,
    ),
    bodyText2: GoogleFonts.nunito(
      color: Colors.black,
      fontSize: 19,
      fontWeight: FontWeight.normal,
      letterSpacing: .15,
    ),
    caption: GoogleFonts.nunito(
      color: Colors.black,
    ),
    bodyText1: GoogleFonts.nunito(color: Colors.black, fontSize: 19, letterSpacing: .5),
    subtitle1: GoogleFonts.nunito(
      color: Colors.black,
      fontSize: 22,
      fontWeight: FontWeight.normal,
      letterSpacing: .15,
    ),
  ),
  backgroundColor: Colors.white,
  appBarTheme: appBarTheme,
);
