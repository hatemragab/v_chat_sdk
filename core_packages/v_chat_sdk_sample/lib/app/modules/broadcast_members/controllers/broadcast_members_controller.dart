import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class BroadcastMembersController extends GetxController {
  final VToChatSettingsModel data;
  VChatLoadingState loadingState = VChatLoadingState.ideal;
  final members = <VBroadcastMember>[];

  BroadcastMembersController(this.data);

  @override
  void onInit() {
    _getMembers();
    super.onInit();
  }

  void _getMembers() async {
    await vSafeApiCall<List<VBroadcastMember>>(
      onLoading: () {
        loadingState = VChatLoadingState.loading;
      },
      request: () async {
        return VChatController.I.nativeApi.remote.room
            .getBroadcastMembers(roomId: data.roomId);
      },
      onSuccess: (response) {
        members.addAll(response);
        loadingState = VChatLoadingState.success;
        update();
      },
      onError: (exception, trace) {
        loadingState = VChatLoadingState.error;
        update();
      },
    );
  }
}
