import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'invite_logic.dart';

class InvitePage extends StatelessWidget {
  final logic = Get.find<InviteLogic>();

  InvitePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.newFriend),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => SingleChildScrollView(
            child: Text(logic.aaa.toString()),
          )),
    );
  }
}
