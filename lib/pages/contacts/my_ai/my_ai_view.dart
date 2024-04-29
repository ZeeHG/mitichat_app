import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'my_ai_logic.dart';

class MyAiPage extends StatelessWidget {
  final logic = Get.find<MyAiLogic>();

  MyAiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.trainAi),
      backgroundColor: StylesLibrary.c_FFFFFF,
      body: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: logic.startSearchMyAi,
            child: Container(
              color: StylesLibrary.c_FFFFFF,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              child: FakeSearchBox(),
            ),
          ),
          Flexible(
            child: Obx(
              () => AzList<ISUserInfo>(
                  data: logic.friendList,
                  itemCount: logic.friendList.length,
                  itemBuilder: (_, data, index) => _buildItemView(data),
                  firstTagPaddingColor: StylesLibrary.c_FFFFFF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemView(ISUserInfo info) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => logic.startTrainAi(info),
        child: Container(
          height: 60.h,
          color: StylesLibrary.c_FFFFFF,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            children: [
              AvatarView(
                url: info.faceURL,
                text: info.showName,
              ),
              12.horizontalSpace,
              info.showName.toText..style = StylesLibrary.ts_333333_16sp,
            ],
          ),
        ),
      );
}
