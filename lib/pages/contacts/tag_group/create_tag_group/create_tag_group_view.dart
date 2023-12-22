import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'create_tag_group_logic.dart';

class CreateTagGroupPage extends StatelessWidget {
  final logic = Get.find<CreateTagGroupLogic>();

  CreateTagGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: TitleBar.back(
          title: logic.isEdit ? StrRes.editTagGroup : StrRes.createTagGroup,
        ),
        backgroundColor: Styles.c_F8F9FA,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildTagNameInputView(),
                  _buildTagMemberView(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Obx(() => Button(
                    text: logic.isEdit
                        ? StrRes.completeEdit
                        : StrRes.completeCreation,
                    enabled: logic.enabled.value,
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    onTap: logic.completeCreation,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagNameInputView() => Container(
        // height: 44.h,
        margin: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: TextField(
          controller: logic.inputCtrl,
          style: Styles.ts_0C1C33_17sp,
          autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
            isDense: true,
            hintStyle: Styles.ts_8E9AB0_17sp,
            hintText: StrRes.plsEnterTagGroupName,
          ),
        ),
      );

  Widget _buildTagMemberView() => Container(
        margin: EdgeInsets.only(
          left: 10.w,
          right: 10.w,
          bottom: 10.h,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StrRes.tagGroupMember.toText..style = Styles.ts_8E9AB0_14sp,
                // 12.verticalSpace,
                if (logic.memberList.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 12.h, bottom: 26.h),
                    child: Wrap(
                      spacing: 10.w,
                      runSpacing: 9.h,
                      children: logic.memberList
                          .map((e) => _buildMemberItemView(userInfo: e))
                          .toList(),
                    ),
                  ),
                // 26.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ImageRes.addTagMember.toImage
                      ..width = 76.w
                      ..height = 31.h
                      ..onTap = logic.selectTagMember,
                  ],
                ),
              ],
            )),
      );

  Widget _buildMemberItemView({required UserInfo userInfo}) => InkWell(
        onTap: () => logic.delTagMember(userInfo),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: Styles.c_E8EAEF, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AvatarView(
                text: userInfo.nickname,
                url: userInfo.faceURL,
                height: 16.h,
                width: 16.w,
                textStyle: Styles.ts_FFFFFF_10sp,
              ),
              7.horizontalSpace,
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 50.w),
                child: userInfo.nickname!.toText
                  ..style = Styles.ts_0C1C33_14sp
                  ..maxLines = 1
                  ..overflow = TextOverflow.ellipsis,
              ),
              8.horizontalSpace,
              Container(
                width: 16.w,
                height: 16.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.r),
                  color: Styles.c_E8EAEF,
                ),
                child: Icon(
                  Icons.clear,
                  size: 10.w,
                  color: Styles.c_8E9AB0,
                ),
              ),
            ],
          ),
        ),
      );
}
