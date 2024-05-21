import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'my_qrcode_logic.dart';

class MyQrcodePage extends StatelessWidget {
  final logic = Get.find<MyQrcodeLogic>();

  MyQrcodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: TitleBar.back(
          title: StrLibrary.qrcode,
        ),
        backgroundColor: StylesLibrary.c_FFFFFF,
        body: SizedBox(
          // alignment: Alignment.topCenter,
          width: 1.sw,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 121.h,
                  ),
                  SizedBox(
                    width: 240.w,
                    child: Row(children: [
                      AvatarView(
                        width: 42.w,
                        height: 42.h,
                        url: logic.imCtrl.userInfo.value.faceURL,
                        text: logic.imCtrl.userInfo.value.nickname,
                        borderRadius: BorderRadius.all(Radius.circular(6.r)),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Expanded(child: (logic.imCtrl.userInfo.value.nickname ?? "").toText..style=StylesLibrary.ts_4B3230_18sp..maxLines=1..overflow=TextOverflow.ellipsis)
                    ]),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  QrImageView(
                    data: logic.qrcodeData,
                    size: 240.w,
                    backgroundColor: StylesLibrary.c_FFFFFF,
                    padding: EdgeInsets.all(6.r),
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              StrLibrary.qrcodeHint.toText
                ..style = StylesLibrary.ts_999999_12sp
                ..textAlign = TextAlign.center,
              SizedBox(
                height: 186.h,
              ),
              // Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       StrLibrary .scan.toText
              //         ..style = StylesLibrary.ts_8443F8_16sp
              //         ..textAlign = TextAlign.center,
              //       Container(
              //         height: 30.h,
              //         width: 1.w,
              //         color: StylesLibrary.c_EDEDED,
              //         margin: EdgeInsets.symmetric(horizontal: 16.w),
              //       ),
              //       StrLibrary .changeStyle.toText
              //         ..style = StylesLibrary.ts_8443F8_16sp
              //         ..textAlign = TextAlign.center,
              //       Container(
              //         height: 30.h,
              //         width: 1.w,
              //         color: StylesLibrary.c_EDEDED,
              //         margin: EdgeInsets.symmetric(horizontal: 16.w),
              //       ),
              //       StrLibrary .saveImg.toText
              //         ..style = StylesLibrary.ts_8443F8_16sp
              //         ..textAlign = TextAlign.center,
              //     ])
            ],
          ),
        ),
      ),
    );
  }
}
