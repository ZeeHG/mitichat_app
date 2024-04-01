import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'set_remark_logic.dart';

class SetRemarkPage extends StatelessWidget {
  final logic = Get.find<SetRemarkLogic>();

  SetRemarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrLibrary.remark,
        right: StrLibrary.save.toText
          ..style = Styles.ts_333333_16sp
          ..onTap = logic.save,
      ),
      backgroundColor: Styles.c_FFFFFF,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Styles.c_E8EAEF,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: TextField(
          controller: logic.inputCtrl,
          style: Styles.ts_333333_16sp,
          inputFormatters: [LengthLimitingTextInputFormatter(20)],
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.all(10.r),
          ),
        ),
      ),
    );
  }
}
