import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'group_qrcode_logic.dart';

class GroupQrcodePage extends StatelessWidget {
  final logic = Get.find<GroupQrcodeLogic>();

  GroupQrcodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: TitleBar.back(title: StrLibrary.groupQrcode),
        backgroundColor: Styles.c_F8F9FA,
        body: Container(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 20.h),
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            width: 311.w,
            height: 420.h,
            decoration: BoxDecoration(
              color: Styles.c_FFFFFF,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8.r,
                  spreadRadius: 1.r,
                  color: Styles.c_000000.withOpacity(.08),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 32.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AvatarView(
                        width: 48.w,
                        height: 48.h,
                        url: logic.groupSetupLogic.groupInfo.value.faceURL,
                        text: logic.groupSetupLogic.groupInfo.value.groupName,
                      ),
                      12.horizontalSpace,
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 180.w),
                        child:
                            (logic.groupSetupLogic.groupInfo.value.groupName ??
                                    '')
                                .toText
                              ..style = Styles.ts_333333_20sp
                              ..maxLines = 1
                              ..overflow = TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 120.h,
                  width: 247.w,
                  child: StrLibrary.groupQrcodeHint.toText
                    ..style = Styles.ts_999999_15sp
                    ..textAlign = TextAlign.center,
                ),
                Positioned(
                  top: 160.h,
                  width: 247.w,
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 180.w,
                      height: 180.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Styles.c_FFFFFF,
                        border: Border.all(color: Styles.c_E8EAEF, width: 4.w),
                        // gradient: const LinearGradient(
                        //   begin: Alignment.topCenter,
                        //   end: Alignment.bottomCenter,
                        //   colors: [Color(0xFFFEB2B2), Color(0xFF5496E4)],
                        // ),
                      ),
                      child: QrImageView(
                        data: logic.buildQRContent(),
                        size: 140.w,
                        backgroundColor: Styles.c_FFFFFF,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
