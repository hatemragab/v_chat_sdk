import 'package:flutter/cupertino.dart';

class CustomSheetModel{
  final int value;
  final String text;
  IconData?iconData;
  bool isHidden;

  CustomSheetModel({required this.value,required this.text, this.iconData,this.isHidden = false});
}