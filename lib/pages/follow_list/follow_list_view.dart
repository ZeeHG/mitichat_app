import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'follow_list_logic.dart';

class FollowListPage extends StatelessWidget {
  FollowListPage({super.key});
  final FollowListLogic logic = Get.put(FollowListLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.c_FFFFFF,
      body: SingleChildScrollView(
        child: Column(
          children: [Text("关注")],
        ),
      ),
    );
  }
}
