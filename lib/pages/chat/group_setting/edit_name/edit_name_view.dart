import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'edit_name_logic.dart';

class EditGroupNamePage extends StatelessWidget {
  final logic = Get.find<EditGroupNameLogic>();

  EditGroupNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: logic.title,
        right: StrLibrary.save.toText
          ..style = StylesLibrary.ts_333333_16sp
          ..onTap = logic.save,
      ),
      backgroundColor: StylesLibrary.c_FFFFFF,
      body: Column(
        children: [
          20.verticalSpace,
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: StylesLibrary.c_E8EAEF,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: TextField(
              controller: logic.inputCtrl,
              style: StylesLibrary.ts_333333_16sp,
              autofocus: true,
              inputFormatters: [LengthLimitingTextInputFormatter(16)],
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
