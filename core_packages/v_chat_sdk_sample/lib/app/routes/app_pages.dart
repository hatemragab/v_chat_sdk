// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:get/get.dart';

import '../modules/about/bindings/about_binding.dart';
import '../modules/about/views/about_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/broadcast_members/bindings/broadcast_members_binding.dart';
import '../modules/broadcast_members/views/broadcast_members_view.dart';
import '../modules/broadcast_settings/bindings/broadcast_settings_binding.dart';
import '../modules/broadcast_settings/views/broadcast_settings_view.dart';
import '../modules/choose_members/bindings/choose_members_binding.dart';
import '../modules/choose_members/views/choose_members_view.dart';
import '../modules/create_broadcast/bindings/create_broadcast_binding.dart';
import '../modules/create_broadcast/views/create_broadcast_view.dart';
import '../modules/create_group/bindings/create_group_binding.dart';
import '../modules/create_group/views/create_group_view.dart';
import '../modules/create_product/bindings/create_product_binding.dart';
import '../modules/create_product/views/create_product_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/group_members/bindings/group_members_binding.dart';
import '../modules/group_members/views/group_members_view.dart';
import '../modules/group_settings/bindings/group_settings_binding.dart';
import '../modules/group_settings/views/group_settings_view.dart';
import '../modules/home_tabs/home/bindings/home_binding.dart';
import '../modules/home_tabs/home/views/home_view.dart';
import '../modules/my_orders/bindings/my_orders_binding.dart';
import '../modules/my_orders/views/my_orders_view.dart';
import '../modules/on_boarding/bindings/on_boarding_binding.dart';
import '../modules/on_boarding/views/on_boarding_view.dart';
import '../modules/peer_profile/bindings/peer_profile_binding.dart';
import '../modules/peer_profile/views/peer_profile_view.dart';
import '../modules/product_details/bindings/product_details_binding.dart';
import '../modules/product_details/views/product_details_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.ON_BOARDING,
      page: () => OnBoardingView(),
      binding: OnBoardingBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: _Paths.PEER_PROFILE,
      page: () => const PeerProfileView(),
      binding: PeerProfileBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_PRODUCT,
      page: () => const CreateProductView(),
      binding: CreateProductBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: _Paths.MY_ORDERS,
      page: () => const MyOrdersView(),
      binding: MyOrdersBinding(),
    ),
    GetPage(
      name: _Paths.CHOOSE_MEMBERS,
      page: () => const ChooseMembersView(),
      binding: ChooseMembersBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_GROUP,
      page: () => const CreateGroupView(),
      binding: CreateGroupBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_BROADCAST,
      page: () => const CreateBroadcastView(),
      binding: CreateBroadcastBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_SETTINGS,
      page: () => const GroupSettingsView(),
      binding: GroupSettingsBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_MEMBERS,
      page: () => const GroupMembersView(),
      binding: GroupMembersBinding(),
    ),
    GetPage(
      name: _Paths.BROADCAST_SETTINGS,
      page: () => const BroadcastSettingsView(),
      binding: BroadcastSettingsBinding(),
    ),
    GetPage(
      name: _Paths.BROADCAST_MEMBERS,
      page: () => const BroadcastMembersView(),
      binding: BroadcastMembersBinding(),
    ),
  ];
}
