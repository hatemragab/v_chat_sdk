import 'package:core_example/app/modules/http/http_model.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class HttpController extends GetxController {
  final authService = VChatAuthApiService.create();
  final httpModels = <HttpModel>[
    HttpModel(
      endpoint: "/text",
      isExpanded: false,
      method: VChatHttpMethods.get,
      state: VChatLoadingState.ideal,
    )
  ];

  void onExpansionChanged(HttpModel model) {
    update([model.endpoint]);
  }

  void onLogin(HttpModel httpModel) async {
    try {
      final res = await authService.login(
        VChatLoginDto(
          identifier: '',
          password: "",
          language: "en",
          deviceInfo: {"id": 1},
          deviceId: "",
          platform: "Android",
          pushKey: null,
        ),
      );
    } catch (err) {
      httpModel.state = VChatLoadingState.error;
      update([httpModel.endpoint]);
    }
  }
}
