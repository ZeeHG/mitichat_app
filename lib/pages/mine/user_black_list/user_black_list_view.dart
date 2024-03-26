import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'user_black_list_logic.dart';

class UserBlacklistPage extends StatelessWidget {
  final logic = Get.find<UserBlacklistLogic>();

  UserBlacklistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.blacklist),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => logic.blacklist.isEmpty
          ? _emptyListView
          : ListView.builder(
              padding: EdgeInsets.only(top: 10.h),
              itemCount: logic.blacklist.length,
              itemBuilder: (_, index) => _buildItemView(
                logic.blacklist[index],
                underline: index != logic.blacklist.length - 1,
              ),
            )),
    );
  }

  Widget _buildItemView(
    BlacklistInfo info, {
    bool underline = true,
  }) =>
      Ink(
        height: 62.h,
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          border: underline
              ? BorderDirectional(
                  bottom: BorderSide(
                    color: Styles.c_E8EAEF,
                    width: 1,
                  ),
                )
              : null,
        ),
        child: InkWell(
          onTap: () => logic.removeUser(info),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                AvatarView(
                  width: 44.w,
                  height: 44.h,
                  text: info.nickname,
                  url: info.faceURL,
                ),
                12.horizontalSpace,
                Expanded(
                  child: (info.nickname ?? '').toText
                    ..style = Styles.ts_333333_16sp,
                ),
                StrLibrary.remove.toText..style = Styles.ts_8443F8_16sp,
              ],
            ),
          ),
        ),
      );

  Widget get _emptyListView => SizedBox(
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            157.verticalSpace,
            ImageRes.blacklistEmpty.toImage
              ..width = 120.w
              ..height = 120.h,
            22.verticalSpace,
            StrLibrary.blacklistEmpty.toText..style = Styles.ts_999999_16sp,
          ],
        ),
      );
}
