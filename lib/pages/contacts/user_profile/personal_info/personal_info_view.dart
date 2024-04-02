import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'personal_info_logic.dart';

class PersonalInfoPage extends StatelessWidget {
  final logic = Get.find<PersonalInfoLogic>();

  PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrLibrary.personalInfo,
      ),
      backgroundColor: StylesLibrary.c_F8F9FA,
      body: Obx(() => SingleChildScrollView(
            child: Column(
              children: [
                10.verticalSpace,
                _buildCornerBgView(
                  children: [
                    _buildItemView(
                      label: StrLibrary.avatar,
                      isAvatar: true,
                      value: logic.nickname,
                      url: logic.faceURL,
                    ),
                    _buildItemView(
                      label: StrLibrary.name,
                      value: logic.nickname,
                    ),
                    _buildItemView(
                      label: StrLibrary.gender,
                      value: logic.isMale ? StrLibrary.man : StrLibrary.woman,
                    ),
                    // _buildItemView(
                    //   label: StrLibrary .englishName,
                    //   value: logic.englishName,
                    // ),
                    _buildItemView(
                      label: StrLibrary.birthDay,
                      value: logic.birth,
                    ),
                  ],
                ),
                10.verticalSpace,
                _buildCornerBgView(
                  children: [
                    // _buildItemView(
                    //   label: StrLibrary .tel,
                    //   value: logic.telephone,
                    //   onTap: logic.clickTel,
                    // ),
                    _buildItemView(
                      label: StrLibrary.mobile,
                      value: logic.phoneNumber,
                      onTap: logic.clickPhoneNumber,
                    ),
                    _buildItemView(
                      label: StrLibrary.email,
                      value: logic.email,
                      // onTap: logic.clickEmail,
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildCornerBgView({required List<Widget> children}) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: StylesLibrary.c_FFFFFF,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.r),
            topRight: Radius.circular(6.r),
            bottomLeft: Radius.circular(6.r),
            bottomRight: Radius.circular(6.r),
          ),
        ),
        child: Column(children: children),
      );

  Widget _buildItemView({
    required String label,
    String? value,
    String? url,
    bool isAvatar = false,
    Function()? onTap,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: SizedBox(
          height: 46.h,
          child: Row(
            children: [
              label.toText..style = StylesLibrary.ts_333333_16sp,
              const Spacer(),
              if (null != value && !isAvatar)
                value.toText..style = StylesLibrary.ts_333333_16sp,
              if (isAvatar)
                AvatarView(
                  width: 32.w,
                  height: 32.h,
                  url: url,
                  text: value,
                ),
            ],
          ),
        ),
      );
}
