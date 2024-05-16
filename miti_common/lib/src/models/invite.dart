import 'dart:convert';

import 'package:miti_common/miti_common.dart';

class InviteInfo {
  int applyTime;
  int? handleTime;
  // 发起邀请人
  String userID;
  // 目标用户
  UserFullInfo inviteUser;
  int? result;

  InviteInfo.fromJson(Map<String, dynamic> map)
      : applyTime = map["applyTime"],
        handleTime = map["handleTime"],
        result = map["result"],
        userID = map["userID"],
        inviteUser = UserFullInfo.fromJson(map["inviteUser"]);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['applyTime'] = applyTime;
    data['handleTime'] = handleTime;
    data['result'] = result;
    data['userID'] = userID;
    data['inviteUser'] = inviteUser;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
