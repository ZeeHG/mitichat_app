import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../../../core/ctrl/im_ctrl.dart';
import 'my_info_logic.dart';

class MyInfoPage extends StatelessWidget {
  final logic = Get.find<MyInfoLogic>();
  final imCtrl = Get.find<IMCtrl>();

  MyInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrLibrary.myInfo,
      ),
      backgroundColor: Styles.c_F7F8FA,
      body: Obx(() => SingleChildScrollView(
            child: Column(
              children: [
                12.verticalSpace,
                _buildCornerBgView(
                  children: [
                    _buildItemView(
                        label: "${StrLibrary.avatar}",
                        isAvatar: true,
                        value: imCtrl.userInfo.value.nickname,
                        url: imCtrl.userInfo.value.faceURL,
                        onTap: logic.openPhotoSheet,
                        showBorder: false),
                  ],
                ),
                12.verticalSpace,
                _buildCornerBgView(
                  children: [
                    _buildItemView(
                        label: StrLibrary.mobile,
                        value: imCtrl.userInfo.value.phoneNumber,
                        // onTap: logic.editMobile,
                        showRightArrow: false,
                        showBorder: false),
                    _buildItemView(
                      label: StrLibrary.email,
                      value: imCtrl.userInfo.value.email,
                      // onTap: logic.editEmail,
                      showRightArrow: false,
                    ),
                  ],
                ),
                12.verticalSpace,
                _buildCornerBgView(
                  children: [
                    _buildItemView(
                        label: StrLibrary.name,
                        value: imCtrl.userInfo.value.nickname,
                        onTap: logic.editMyName,
                        showBorder: false),
                    _buildItemView(
                      label: StrLibrary.gender,
                      value: imCtrl.userInfo.value.isMale
                          ? StrLibrary.man
                          : StrLibrary.woman,
                      onTap: logic.selectGender,
                    ),
                    _buildItemView(
                      label: StrLibrary.birthDay,
                      value: DateUtil.formatDateMs(
                        imCtrl.userInfo.value.birth ?? 0,
                        format: IMUtils.getTimeFormat1(),
                      ),
                      onTap: logic.openDatePicker,
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildCornerBgView({required List<Widget> children}) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(6.r),
          //   topRight: Radius.circular(6.r),
          //   bottomLeft: Radius.circular(6.r),
          //   bottomRight: Radius.circular(6.r),
          // ),
        ),
        child: Column(children: children),
      );

  Widget _buildItemView({
    required String label,
    String? value,
    String? url,
    bool isAvatar = false,
    bool showRightArrow = true,
    bool showBorder = true,
    Function()? onTap,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: showRightArrow ? onTap : null,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Styles.c_F1F2F6,
                width: showBorder ? 1.h : 0,
              ),
            ),
          ),
          height: 50.h,
          child: Row(
            children: [
              label.toText..style = Styles.ts_333333_14sp,
              const Spacer(),
              if (isAvatar)
                AvatarView(
                  width: 38.w,
                  height: 38.h,
                  url: url,
                  text: value,
                  textStyle: Styles.ts_FFFFFF_12sp,
                  isCircle: true,
                )
              else
                Expanded(
                    flex: 3,
                    child: (IMUtils.emptyStrToNull(value) ?? '').toText
                      ..style = Styles.ts_999999_14sp
                      ..maxLines = 1
                      ..overflow = TextOverflow.ellipsis
                      ..textAlign = TextAlign.right),
              if (showRightArrow)
                ImageRes.appRightArrow.toImage
                  ..width = 20.w
                  ..height = 20.h,
            ],
          ),
        ),
      );
}
