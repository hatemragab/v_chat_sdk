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

final outlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
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
  shadowColor: Colors.white,
  titleTextStyle: GoogleFonts.nunito(
      color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
  backgroundColor: Colors.black54,
  iconTheme: const IconThemeData(color: Colors.white),
);

/// Default v chat dark theme
final vChatDarkTheme = ThemeData.dark().copyWith(
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
    cupertinoOverrideTheme: const CupertinoThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black26,
        primaryColor: Colors.red,
        barBackgroundColor: Colors.black26,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(color: Colors.white, fontSize: 20),
          primaryColor: Colors.red,
          actionTextStyle: TextStyle(color: Colors.white),
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
            // Theme.of(Get.context!).textTheme,
            )
        .copyWith(
      headline3: GoogleFonts.nunito(
          fontWeight: FontWeight.w700, color: Colors.red, fontSize: 50),
      headline4:
          GoogleFonts.nunito(fontWeight: FontWeight.w700, color: Colors.red),
      headline2:
          GoogleFonts.nunito(fontWeight: FontWeight.w900, color: Colors.red),
      headline6:
          GoogleFonts.nunito(fontWeight: FontWeight.w700, color: Colors.white),
      subtitle2: GoogleFonts.nunito(
          letterSpacing: .1,
          color: Colors.white70,
          fontSize: 15,
          fontWeight: FontWeight.normal),
      bodyText2: GoogleFonts.nunito(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.normal,
          letterSpacing: .15),
      bodyText1: GoogleFonts.nunito(
          color: Colors.white, fontSize: 19, letterSpacing: .5),
      subtitle1: GoogleFonts.nunito(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.normal,
          letterSpacing: .15),
      caption: GoogleFonts.nunito(
        color: Colors.white,
      ),
      button: GoogleFonts.nunito(
          height: 1.3,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white),
    ),
    backgroundColor: Colors.black,
    appBarTheme: appBarTheme,
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: Colors.redAccent));
