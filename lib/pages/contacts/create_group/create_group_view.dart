import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

import 'create_group_logic.dart';

class CreateGroupPage extends StatelessWidget {
  final logic = Get.find<CreateGroupLogic>();

  CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: TitleBar.back(title: StrLibrary.createGroup),
        backgroundColor: StylesLibrary.c_F7F8FA,
        body: SingleChildScrollView(
          child: SizedBox(
            height: 1.sh - 44.h - 10.h - 34.h,
            child: Column(
              children: [
                _groupBaseInfo(),
                _groupMember(),
                const Spacer(),
                Container(
                  color: StylesLibrary.c_FFFFFF,
                  padding: EdgeInsets.all(12.w),
                  child: Button(
                    text: StrLibrary.completeCreation,
                    onTap: logic.completeCreation,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _groupBaseInfo() => Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: StylesLibrary.c_FFFFFF,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Obx(() => Row(
              children: [
                if (logic.faceURL.isNotEmpty)
                  AvatarView(
                    width: 48.w,
                    height: 48.h,
                    url: logic.faceURL.value,
                    onTap: logic.selectAvatar,
                  )
                else
                  ImageLibrary.cameraGray.toImage
                    ..width = 48.w
                    ..height = 48.h
                    ..onTap = logic.selectAvatar,
                10.horizontalSpace,
                Flexible(
                  child: TextField(
                    style: StylesLibrary.ts_333333_16sp,
                    controller: logic.nameCtrl,
                    inputFormatters: [LengthLimitingTextInputFormatter(20)],
                    decoration: InputDecoration(
                      hintStyle: StylesLibrary.ts_999999_16sp,
                      hintText: StrLibrary.plsEnterGroupNameHint,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            )),
      );

  Widget _groupMember() => Obx(() => Container(
        decoration: BoxDecoration(
          color: StylesLibrary.c_FFFFFF,
          borderRadius: BorderRadius.circular(6.r),
        ),
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                children: [
                  StrLibrary.groupMember.toText
                    ..style = StylesLibrary.ts_999999_16sp,
                  const Spacer(),
                  sprintf(StrLibrary.nPerson, [logic.allList.length]).toText
                    ..style = StylesLibrary.ts_999999_16sp,
                ],
              ),
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logic.length(),
              shrinkWrap: true,
              // padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 68.w / 78.h,
              ),
              itemBuilder: (BuildContext context, int index) {
                return logic.itemBuilder(
                  index: index,
                  builder: (info) => Column(
                    children: [
                      AvatarView(
                        width: 48.w,
                        height: 48.h,
                        url: info.faceURL,
                        text: info.nickname,
                      ),
                      2.verticalSpace,
                      (info.nickname ?? '').toText
                        ..style = StylesLibrary.ts_999999_10sp
                        ..maxLines = 1
                        ..overflow = TextOverflow.ellipsis,
                    ],
                  ),
                  addButton: () => GestureDetector(
                    onTap: logic.opMember,
                    child: Column(
                      children: [
                        ImageLibrary.addMember.toImage
                          ..width = 48.w
                          ..height = 48.h,
                        StrLibrary.addMember.toText
                          ..style = StylesLibrary.ts_999999_10sp,
                      ],
                    ),
                  ),
                  delButton: () => GestureDetector(
                    onTap: () => logic.opMember(isDel: true),
                    child: Column(
                      children: [
                        ImageLibrary.delMember.toImage
                          ..width = 48.w
                          ..height = 48.h,
                        StrLibrary.delMember.toText
                          ..style = StylesLibrary.ts_999999_10sp,
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ));
}
