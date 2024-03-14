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
        backgroundColor: Styles.c_FFFFFF,
        body: Container(
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
                  Container(
                    width: 213.w,
                    child: Row(children: [
                      AvatarView(
                        width: 42.w,
                        height: 42.h,
                        url: logic.imLogic.userInfo.value.faceURL,
                        text: logic.imLogic.userInfo.value.nickname,
                        textStyle: Styles.ts_FFFFFF_14sp,
                        borderRadius: BorderRadius.all(Radius.circular(6.w)),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Text(logic.imLogic.userInfo.value.nickname ?? "",
                          style: Styles.ts_4B3230_18sp)
                    ]),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  QrImageView(
                    data: logic.buildQRContent(),
                    size: 213.w,
                    backgroundColor: Styles.c_FFFFFF,
                    padding: EdgeInsets.all(6),
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              StrLibrary.qrcodeHint.toText
                ..style = Styles.ts_999999_12sp
                ..textAlign = TextAlign.center,
              SizedBox(
                height: 186.h,
              ),
              // Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       StrLibrary .scan.toText
              //         ..style = Styles.ts_8443F8_16sp
              //         ..textAlign = TextAlign.center,
              //       Container(
              //         height: 30.h,
              //         width: 1.w,
              //         color: Styles.c_EDEDED,
              //         margin: EdgeInsets.symmetric(horizontal: 16.w),
              //       ),
              //       StrLibrary .changeStyle.toText
              //         ..style = Styles.ts_8443F8_16sp
              //         ..textAlign = TextAlign.center,
              //       Container(
              //         height: 30.h,
              //         width: 1.w,
              //         color: Styles.c_EDEDED,
              //         margin: EdgeInsets.symmetric(horizontal: 16.w),
              //       ),
              //       StrLibrary .saveImg.toText
              //         ..style = Styles.ts_8443F8_16sp
              //         ..textAlign = TextAlign.center,
              //     ])
            ],
          ),
        ),
      ),
    );
  }
}
