import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'invite_friends _qrcode_logic.dart';

class InviteFriendsQrcodePage extends StatelessWidget {
  final logic = Get.find<InviteFriendsQrcodeLogic>();

  InviteFriendsQrcodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TitleBar.back(
            title: StrLibrary.qrcode, backgroundColor: StylesLibrary.c_E7E4F5),
        backgroundColor: StylesLibrary.c_E7E4F5,
        body: Obx(
          () => AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                  systemNavigationBarColor: StylesLibrary.c_E7E4F5),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 1.sw,
                  child: Column(
                    children: [
                      RepaintBoundary(
                        key: logic.previewContainer,
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 30.h),
                            decoration: BoxDecoration(
                              color: StylesLibrary.c_E7E4F5,
                              image: const DecorationImage(
                                image: AssetImage(ImageLibrary.inviteQrBg,
                                    package: 'miti_common'),
                                // fit: BoxFit.fitWidth,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: StylesLibrary.c_FFFFFF,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              padding: EdgeInsets.only(
                                  top: 20.h,
                                  left: 20.w,
                                  right: 20.w,
                                  bottom: 50.h),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      AvatarView(
                                        width: 40.w,
                                        height: 40.h,
                                        url:
                                            logic.imCtrl.userInfo.value.faceURL,
                                        text: logic
                                            .imCtrl.userInfo.value.nickname,
                                      ),
                                      8.horizontalSpace,
                                      Flexible(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          logic.imCtrl.userInfo.value.nickname!
                                              .toText
                                            ..style = StylesLibrary
                                                .ts_333333_16sp_medium
                                            ..maxLines = 1
                                            ..overflow = TextOverflow.ellipsis,
                                          DateUtil.formatDate(DateTime.now(),
                                                  format: "yyyy.MM.dd")
                                              .toText
                                            ..style = StylesLibrary
                                                .ts_000000_opacity40_12sp,
                                        ],
                                      ))
                                    ],
                                  ),
                                  20.verticalSpace,
                                  DottedBorder(
                                      color: StylesLibrary.c_000000_opacity16,
                                      strokeWidth: 1.h,
                                      customPath: (size) {
                                        return Path()
                                          ..moveTo(0, 0)
                                          ..lineTo(size.width, 0);
                                      },
                                      child: Container()),
                                  44.verticalSpace,
                                  QrImageView(
                                    data: logic.qrcodeData,
                                    size: 200.w,
                                    backgroundColor: StylesLibrary.c_FFFFFF,
                                  ),
                                ],
                              ),
                            )),
                      ),
                      64.verticalSpace,
                      Button(
                        width: 1.sw - 80.w,
                        text: StrLibrary.saveImg,
                        onTap: logic.saveImg,
                      )
                    ],
                  ),
                ),
              )),
        ));
  }
}
