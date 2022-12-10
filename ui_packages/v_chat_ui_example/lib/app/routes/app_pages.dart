import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/message_ui/bindings/message_ui_binding.dart';
import '../modules/message_ui/views/message_ui_view.dart';
import '../modules/room_ui/bindings/room_ui_binding.dart';
import '../modules/room_ui/views/room_ui_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ROOM_UI,
      page: () => const RoomUiView(),
      binding: RoomUiBinding(),
    ),
    GetPage(
      name: _Paths.MESSAGE_UI,
      page: () => const MessageUiView(),
      binding: MessageUiBinding(),
    ),
  ];
}
