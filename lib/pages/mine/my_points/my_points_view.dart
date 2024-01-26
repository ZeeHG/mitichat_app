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
          title: StrRes.myPoints,
          backgroundColor: Styles.c_E5E4F6,
          right: StrRes.pointRules.toText
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
                      50.verticalSpace,
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
                                      text: '已连续签到 ',
                                      style: Styles.ts_343434_12p,
                                    ),
                                    TextSpan(
                                      text: '1',
                                      style: Styles.ts_8443F8_18sp,
                                    ),
                                    TextSpan(
                                      text: ' 天',
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
                                10.horizontalSpace,
                                "米粒获取".toText..style=Styles.ts_333333_16sp_medium
                              ],
                            ),
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
                                      text: '已连续签到 ',
                                      style: Styles.ts_343434_12p,
                                    ),
                                    TextSpan(
                                      text: '1',
                                      style: Styles.ts_8443F8_18sp,
                                    ),
                                    TextSpan(
                                      text: ' 天',
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
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
