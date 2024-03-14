import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'my_points_logic.dart';

class MyPointsPage extends StatelessWidget {
  final logic = Get.find<MyPointsLogic>();

  MyPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar2.back(
          title: StrLibrary.myPoints,
          backgroundColor: Styles.c_E5E4F6,
          right: StrLibrary.rulesTitle.toText
            ..style = Styles.ts_333333_16sp
            ..onTap = logic.pointRules),
      backgroundColor: Styles.c_E5E4F6,
      body: Obx(() => SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                    width: 1.sw,
                    height: 812.h - 44.h - MediaQuery.of(context).padding.top,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImageRes.appMyPointsBg,
                            package: 'openim_common'),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.bottomCenter,
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    children: [
                      "aaa".toText..onTap = logic.inviteRecords,
                      10.verticalSpace,
                      "aaa".toText..onTap = logic.inviteRecords,
                      30.verticalSpace,
                      Text(logic.aaa.value),
                      Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Styles.c_BA78FC, Styles.c_8443F8],
                            tileMode: TileMode.mirror,
                          ).createShader(bounds),
                          // blendMode: BlendMode.src,
                          child: Text(
                            '20',
                            style: Styles.ts_FFFFFF_46sp_bold,
                          ),
                        ),
                      ),
                      60.verticalSpace,
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Styles.c_FFFFFF_opacity95,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.r),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 38.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: [0, 0.51, 1],
                                  colors: [
                                    Styles.c_F7B500_opacity10,
                                    Styles.c_B620E0_opacity10,
                                    Styles.c_32C5FF_opacity10,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: StrLibrary.consecutiveSignIn + " ",
                                      style: Styles.ts_343434_12p,
                                    ),
                                    TextSpan(
                                      text: '1',
                                      style: Styles.ts_8443F8_18sp_bold,
                                    ),
                                    TextSpan(
                                      text: " " + StrLibrary.day,
                                      style: Styles.ts_343434_12p,
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                            Container(
                              height: 96.h,
                            )
                          ],
                        ),
                      ),
                      15.verticalSpace,
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Styles.c_FFFFFF_opacity95,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.r),
                          ),
                        ),
                        child: Column(
                          children: [
                            15.verticalSpace,
                            Row(
                              children: [
                                ImageRes.appSemicircle.toImage..width = 5.w,
                                10.horizontalSpace,
                                StrLibrary.earningTitle.toText
                                  ..style = Styles.ts_333333_16sp_medium
                              ],
                            ),
                            16.verticalSpace,
                            Container(
                              width: 1.sw - 60.w,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      ImageRes.appSignInTask.toImage
                                        ..width = 36.w,
                                      10.horizontalSpace,
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          StrLibrary.dailySignIn.toText
                                            ..style =
                                                Styles.ts_333333_16sp_medium,
                                          RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                                text: StrLibrary.mitiToken,
                                                style: Styles.ts_999999_12sp),
                                            TextSpan(
                                                text: "+1",
                                                style: Styles.ts_8443F8_12sp)
                                          ]))
                                        ],
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        child: Container(
                                          height: 34.h,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 19.w),
                                          decoration: BoxDecoration(
                                              // color: Styles.c_32C5FF_opacity10,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(21.r),
                                              ),
                                              border: Border.all(
                                                color: Styles.c_8443F8,
                                                width: 1.w,
                                              )),
                                          child: Center(
                                              child: StrLibrary.signedIn.toText
                                                ..style =
                                                    Styles.ts_8443F8_14sp),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            16.verticalSpace,
                            Container(
                              width: 1.sw - 60.w,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      ImageRes.appInviteTask.toImage
                                        ..width = 36.w,
                                      10.horizontalSpace,
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          StrLibrary.inviteFriends.toText
                                            ..style =
                                                Styles.ts_333333_16sp_medium,
                                          RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                                text: StrLibrary.mitiToken,
                                                style: Styles.ts_999999_12sp),
                                            TextSpan(
                                                text: "+10",
                                                style: Styles.ts_8443F8_12sp)
                                          ]))
                                        ],
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        child: Container(
                                          height: 34.h,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 19.w),
                                          decoration: BoxDecoration(
                                              color: Styles.c_8443F8,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(21.r),
                                              ),
                                              border: Border.all(
                                                color: Styles.c_8443F8,
                                                width: 1.w,
                                              )),
                                          child: Center(
                                              child: StrLibrary.invite2.toText
                                                ..style =
                                                    Styles.ts_FFFFFF_14sp),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            16.verticalSpace,
                            Container(
                              width: 1.sw - 60.w,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      ImageRes.appChatTask.toImage
                                        ..width = 36.w,
                                      10.horizontalSpace,
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          StrLibrary.aiAgentInteraction.toText
                                            ..style =
                                                Styles.ts_333333_16sp_medium,
                                          RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                                text: StrLibrary.mitiToken,
                                                style: Styles.ts_999999_12sp),
                                            TextSpan(
                                                text: "+1",
                                                style: Styles.ts_8443F8_12sp)
                                          ]))
                                        ],
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        child: Container(
                                          height: 34.h,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 19.w),
                                          decoration: BoxDecoration(
                                              color: Styles.c_8443F8,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(21.r),
                                              ),
                                              border: Border.all(
                                                color: Styles.c_8443F8,
                                                width: 1.w,
                                              )),
                                          child: Center(
                                              child: StrLibrary.interact.toText
                                                ..style =
                                                    Styles.ts_FFFFFF_14sp),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            25.verticalSpace,
                          ],
                        ),
                      ),
                      15.verticalSpace,
                      Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Styles.c_FFFFFF_opacity95,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                          ),
                          child: Column(children: [
                            15.verticalSpace,
                            Row(
                              children: [
                                ImageRes.appSemicircle.toImage..width = 5.w,
                                10.horizontalSpace,
                                StrLibrary.history.toText
                                  ..style = Styles.ts_333333_16sp_medium,
                                Spacer(),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: logic.pointRecords,
                                  child: Row(
                                    children: [
                                      StrLibrary.allRecords.toText
                                        ..style = Styles.ts_999999_12sp,
                                      ImageRes.appRightArrow.toImage
                                        ..width = 16.w,
                                      15.horizontalSpace
                                    ],
                                  ),
                                )
                              ],
                            ),
                            16.verticalSpace,
                            ...List.generate(
                                4,
                                (index) => Container(
                                      margin: EdgeInsets.only(bottom: 16.h),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                      child: Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              StrLibrary.inviteFriends.toText
                                                ..style = Styles
                                                    .ts_333333_14sp_medium,
                                              "2024-01-01".toText
                                                ..style = Styles.ts_999999_12sp,
                                            ],
                                          ),
                                          Spacer(),
                                          "+5".toText
                                            ..style =
                                                Styles.ts_8443F8_18sp_medium,
                                        ],
                                      ),
                                    )),
                          ])),
                      16.verticalSpace
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
