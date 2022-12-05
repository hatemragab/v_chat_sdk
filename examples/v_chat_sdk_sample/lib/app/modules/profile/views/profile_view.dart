import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      providerConfigs: [
        EmailProviderConfiguration(),
        GoogleProviderConfiguration(
          clientId: '...',
        ),
        FacebookProviderConfiguration(
          clientId: '...',
        ),
        AppleProviderConfiguration(),
      ],
      avatarSize: 24,
    );
  }
}
