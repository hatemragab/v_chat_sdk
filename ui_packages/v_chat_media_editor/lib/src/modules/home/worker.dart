// @JS()
// library sample;
//
// import 'dart:html';
// import 'dart:typed_data';
//
// import 'package:image/image.dart' as Library;
// import 'package:js/js.dart';
//
// @JS('self')
// external DedicatedWorkerGlobalScope get self;
//
// void main() {
//   self.onMessage.listen((event) {
//     final arguments = event.data;
//     if (arguments[0] == 0) {
//       final bytes = arguments[1];
//       final Library.Image libraryImage = getCompressedImage(bytes);
//       self.postMessage(
//         [
//           Library.encodePng(libraryImage),
//           libraryImage.width,
//           libraryImage.height,
//           libraryImage.getBytes(),
//         ],
//       );
//     } else if (arguments[0] == 1) {
//       final libraryImage = Library.copyCrop(
//         Library.Image.fromBytes(
//           arguments[2],
//           arguments[3],
//           arguments[1],
//           channels: Library.Channels.rgb,
//         ),
//         arguments[4],
//         arguments[5],
//         arguments[6],
//         arguments[7],
//       );
//       Uint8List libraryUInt8List;
//       if (arguments.length > 8) {
//         libraryUInt8List = Uint8List.fromList(
//           arguments[9] == 0
//               ? Library.encodeJpg(
//                   libraryImage,
//                   quality: arguments[8],
//                 )
//               : Library.encodePng(libraryImage),
//         );
//       } else {
//         libraryUInt8List = Uint8List.fromList(
//           Library.encodeJpg(
//             libraryImage,
//             quality: arguments[8],
//           ),
//         );
//       }
//       self.postMessage([libraryImage.getBytes(), libraryUInt8List]);
//     }
//   });
// }
//
// Library.Image getCompressedImage(Uint8List imageData) {
//   Library.Image image = Library.decodeImage(imageData)!;
//   if (image.width > 1920) {
//     image = Library.copyResize(image, width: 1920);
//   } else if (image.height > 1920) {
//     image = Library.copyResize(image, height: 1920);
//   }
//   return image;
// }
