import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'point_records_logic.dart';

class PointRecordsPage extends StatelessWidget {
  final logic = Get.find<PointRecordsLogic>();

  PointRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.newFriend),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => SingleChildScrollView(
        child: Text(logic.pointRecords.toString()),
      )),
    );
  }
}
