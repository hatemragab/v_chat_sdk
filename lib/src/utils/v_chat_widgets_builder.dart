import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Widget Function(String duration) builderVoiceSenderLight = (x) => Text(
//       "builderVoiceSenderLight $x",
//       style: TextStyle(color: Colors.black),
//     );
//
// Widget Function(String duration) builderVoiceSenderDark = (x) => Text(
//       "builderVoiceSenderDark $x",
//       style: TextStyle(color: Colors.white),
//     );
//
//
// class VChatWidgetBuilder {
//   Widget Function(String duration)? voiceSenderLight;
//   Widget Function(String duration)? voiceSenderDark;
//
//   VChatWidgetBuilder({
//     this.voiceSenderLight  = (x)=>Text("sdfdf"),
//     this.voiceSenderDark,
//   });
// }

class VChatWidgetBuilder implements VCBInterface {
  const VChatWidgetBuilder();

  @override
  Widget voiceSender(BuildContext context, String duration) {
    final theme = Theme.of(context);
    return Text('Max $duration',style: theme.textTheme.bodyText1);
  }

  // Widget voiceSenderLight(String duration) {
  //   return Text(
  //     "Default Light",
  //     style: TextStyle(color: Colors.black),
  //   );
  // }
  //
  // Widget voiceSenderDark(String duration) {
  //   return Text(
  //     " voiceSenderDark Default Light",
  //     style: TextStyle(color: Colors.black),
  //   );
  // }
}
abstract class VCBInterface{
  Widget voiceSender(BuildContext context, String duration );
}