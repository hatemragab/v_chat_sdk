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

final outlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    primary: Colors.red,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
  ),
);

final textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
  primary: Colors.blue,
));

final appBarTheme = AppBarTheme(
  elevation: 1,
  titleTextStyle: GoogleFonts.nunito(
      color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
  backgroundColor: Colors.white,
  iconTheme: const IconThemeData(color: Colors.red),
);

final vChatLightTheme = ThemeData(
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
        modalElevation: 0),
    cupertinoOverrideTheme: const CupertinoThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.red,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(color: Colors.black, fontSize: 20),
          primaryColor: Colors.red,
          actionTextStyle: TextStyle(color: Colors.black),
        )),
    cardTheme: const CardTheme(elevation: 1.5, color: Colors.white),
    errorColor: Colors.red,
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.red,
        selectionHandleColor: Colors.redAccent,
        selectionColor: Colors.redAccent[100]),
    elevatedButtonTheme: elevatedButtonThemeData,
    outlinedButtonTheme: outlinedButtonTheme,
    textButtonTheme: textButtonTheme,
    textTheme: GoogleFonts.nunitoTextTheme(
            //  Theme.of(Get.context!).textTheme,
            )
        .copyWith(
      headline3: GoogleFonts.nunito(
          fontWeight: FontWeight.w700, color: Colors.red, fontSize: 50),
      headline4:
          GoogleFonts.nunito(fontWeight: FontWeight.w700, color: Colors.red),
      headline2:
          GoogleFonts.nunito(fontWeight: FontWeight.w900, color: Colors.red),
      headline6: GoogleFonts.nunito(fontWeight: FontWeight.w700),
      subtitle2: GoogleFonts.nunito(
          letterSpacing: .1,
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.normal),
      bodyText2: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 19,
          fontWeight: FontWeight.normal,
          letterSpacing: .15),
      caption: GoogleFonts.nunito(
        color: Colors.black,
      ),
      bodyText1: GoogleFonts.nunito(
          color: Colors.black, fontSize: 19, letterSpacing: .5),
      subtitle1: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.normal,
          letterSpacing: .15),
      button: GoogleFonts.nunito(
          height: 1.3, fontSize: 18, fontWeight: FontWeight.w700),
    ),
    backgroundColor: Colors.white,
    appBarTheme: appBarTheme,
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: Colors.redAccent));
