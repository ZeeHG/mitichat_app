import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'account_manage_logic.dart';

class AccountManagePage extends StatelessWidget {
  final logic = Get.find<AccountManageLogic>();

  AccountManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(
              title: StrLibrary.accountManage, onTap: logic.cusBack),
          backgroundColor: StylesLibrary.c_F7F8FA,
          body: SingleChildScrollView(
            child: Column(
              children: [
                12.verticalSpace,
                ...List.generate(
                  logic.loginInfoList.length,
                  (i) => _buildCusPopMenuInfo(
                      info: logic.loginInfoList[i],
                      showBorder: i != logic.loginInfoList.length - 1),
                ),
                12.verticalSpace,
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => logic.goLogin(),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    color: StylesLibrary.c_FFFFFF,
                    child: SizedBox(
                      height: 54.h,
                      child: Row(children: [
                        10.horizontalSpace,
                        ImageLibrary.appAdd3.toImage
                          ..width = 30.w
                          ..height = 30.h,
                        8.horizontalSpace,
                        StrLibrary.addOrRegisterAccount.toText
                          ..style = StylesLibrary.ts_333333_16sp
                      ]),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildCusPopMenuInfo(
          {required AccountLoginInfo info, showBorder = true}) =>
      Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.3,
          children: [
            CustomSlidableAction(
              onPressed: (_) => logic.delLoginInfo(info),
              flex: 1,
              backgroundColor: StylesLibrary.c_FF4E4C,
              child: StrLibrary.delete.toText
                ..style = StylesLibrary.ts_FFFFFF_16sp,
            ),
          ],
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => logic.switchAccount(info),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            color: StylesLibrary.c_FFFFFF,
            child: Container(
              height: 62.h,
              decoration: BoxDecoration(
                border: showBorder
                    ? BorderDirectional(
                        bottom: BorderSide(
                            color: StylesLibrary.c_F1F2F6, width: 1.h),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  AvatarView(
                    width: 40.w,
                    height: 40.h,
                    text: info.nickname,
                    url: info.faceURL,
                  ),
                  8.horizontalSpace,
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      info.nickname.toText
                        ..style = StylesLibrary.ts_333333_16sp
                        ..maxLines = 1
                        ..overflow = TextOverflow.ellipsis,
                      info.server.toText
                        ..style = StylesLibrary.ts_999999_14sp
                        ..maxLines = 1
                        ..overflow = TextOverflow.ellipsis,
                    ],
                  )),
                  if (logic.curLoginInfoKey.value == info.id)
                    ImageLibrary.appChecked2.toImage
                      ..width = 18.w
                      ..height = 18.h
                ],
              ),
            ),
          ),
        ),
      );
}
