import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'my_ai_logic.dart';

class MyAiPage extends StatelessWidget {
  final logic = Get.find<MyAiLogic>();

  MyAiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.trainAi),
      backgroundColor: Styles.c_FFFFFF,
      body: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: logic.startSearchMyAi,
            child: Container(
              color: Styles.c_FFFFFF,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              child: FakeSearchBox(),
            ),
          ),
          Flexible(
            child: Obx(
              () => WrapAzListView<ISUserInfo>(
                  data: logic.friendList,
                  itemCount: logic.friendList.length,
                  itemBuilder: (_, data, index) => _buildItemView(data),
                  firstTagPaddingColor: Styles.c_FFFFFF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemView(ISUserInfo info) => Ink(
        height: 60.h,
        color: Styles.c_FFFFFF,
        child: InkWell(
          onTap: () => logic.startTrainAi(info),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                AvatarView(
                  url: info.faceURL,
                  text: info.showName,
                ),
                12.horizontalSpace,
                info.showName.toText..style = Styles.ts_333333_16sp,
              ],
            ),
          ),
        ),
      );
}
