// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

final fakeLocalMessages = [
  {
    "tb_m_id": "1",
    "tb_m_s_id": "63ac6118079aac2880035ed3",
    "tb_m_s_name": "user1",
    "tb_m_s_img": "default_user_image.png",
    "tb_m_room_id": "rid1",
    "tb_m_content": "first message",
    "tb_m_type": "text",
    "tb_m_att": null,
    "tb_m_l_att": null,
    "tb_m_reply_to": null,
    "tb_m_seen_at": null,
    "tb_m_all_deleted_at": null,
    "tb_m_p_b_id": null,
    "tb_m_delivered_at": null,
    "tb_m_forward_l_id": null,
    "tb_m_is_star": 0,
    "tb_m_created_at": "2022-12-26T19:32:26.613Z",
    "tb_m_updated_at": "2022-12-26T19:32:26.613Z",
    "tb_m_platform": "Android",
    "tb_m_emit_status": VMessageEmitStatus.serverConfirm.name,
    "tb_m_local_id": "65a285ce-ed5f-402c-ae28-c65ce361e592"
  },
  {
    "tb_m_id": "2",
    "tb_m_s_id": "63ac6eea079aac2880035f8d",
    "tb_m_s_name": "user2",
    "tb_m_s_img": "default_user_image.png",
    "tb_m_room_id": "rid1",
    "tb_m_content": "second message",
    "tb_m_type": "text",
    "tb_m_att": null,
    "tb_m_l_att": null,
    "tb_m_reply_to": null,
    "tb_m_seen_at": null,
    "tb_m_all_deleted_at": null,
    "tb_m_p_b_id": null,
    "tb_m_delivered_at": null,
    "tb_m_forward_l_id": null,
    "tb_m_is_star": 0,
    "tb_m_created_at": "2022-12-28T14:50:32Z",
    "tb_m_updated_at": "2022-12-28T14:50:32Z",
    "tb_m_platform": "Android",
    "tb_m_emit_status": VMessageEmitStatus.serverConfirm.name,
    "tb_m_local_id": "fd35ergdfh456yhgjhf2"
  },
  {
    "tb_m_id": "3",
    "tb_m_s_id": "63ac6118079aac2880035ed3",
    "tb_m_s_name": "user1",
    "tb_m_s_img": "default_user_image.png",
    "tb_m_room_id": "rid1",
    "tb_m_content": "image",
    "tb_m_type": VMessageType.image.name,
    "tb_m_att": jsonEncode(
      VMessageImageData(
        fileSource: VPlatformFileSource.fromUrl(url: "url"),
        width: 300,
        height: 300,
      ).toMap(),
    ),
    "tb_m_l_att": null,
    "tb_m_reply_to": null,
    "tb_m_seen_at": null,
    "tb_m_all_deleted_at": null,
    "tb_m_p_b_id": null,
    "tb_m_delivered_at": null,
    "tb_m_forward_l_id": null,
    "tb_m_is_star": 0,
    "tb_m_created_at": "2022-12-28T14:51:32Z",
    "tb_m_updated_at": "2022-12-28T14:51:32Z",
    "tb_m_platform": "Android",
    "tb_m_emit_status": VMessageEmitStatus.sending.name,
    "tb_m_local_id": "fd35ergdfh456yhgjhfsd"
  },
];
