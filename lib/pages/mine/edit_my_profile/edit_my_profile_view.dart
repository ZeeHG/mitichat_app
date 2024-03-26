import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'edit_my_profile_logic.dart';

class EditMyProfilePage extends StatelessWidget {
  final logic = Get.find<EditMyProfileLogic>();

  EditMyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: logic.title,
        right: StrLibrary.save.toText
          ..style = Styles.ts_333333_16sp
          ..onTap = logic.save,
      ),
      backgroundColor: Styles.c_FFFFFF,
      body: Column(
        children: [
          22.verticalSpace,
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: Styles.c_E8EAEF,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: TextField(
              controller: logic.inputCtrl,
              style: Styles.ts_333333_16sp,
              autofocus: true,
              keyboardType: logic.keyboardType,
              inputFormatters: [
                LengthLimitingTextInputFormatter(logic.maxLength)
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.h,
                  horizontal: 12.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
