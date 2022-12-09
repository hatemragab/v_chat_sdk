import  'dart:html' as html   if (dart.library.html)'dart:io' ;

class V {
  static String getVideoPlayer(List<int> bytes) {
    final blob = html.Blob([bytes]);
    return html.Url.createObjectUrlFromBlob(blob);
  }
}
