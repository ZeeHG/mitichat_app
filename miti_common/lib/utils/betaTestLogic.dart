import 'dart:convert';
import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import '../miti_common.dart';

class BetaTestLogic extends GetxController {
  BetaTestLogic() {}

  final openChatMd = false.obs;

  bool isDevUser(String id) => Config.devUserIds.contains(id);

  bool isTestUser(String id) => Config.testUserIds.contains(id);

  bool isBot(String id) => Config.botIDs.contains(id);

  void setOpenChatMd(bool open) => openChatMd.value = open;
}
