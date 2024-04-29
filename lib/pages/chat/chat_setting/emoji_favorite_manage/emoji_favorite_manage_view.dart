import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

import 'emoji_favorite_manage_logic.dart';

class EmojiFavoriteManagePage extends StatelessWidget {
  final logic = Get.find<EmojiFavoriteManageLogic>();

  EmojiFavoriteManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(
            title: StrLibrary.favoriteFace,
            right: StrLibrary.favoriteManage.toText
              ..onTap = logic.manage
              ..style = StylesLibrary.ts_333333_16sp,
          ),
          body: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  itemCount: logic.cacheLogic.urlList.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    mainAxisSpacing: 25.h,
                    crossAxisSpacing: 25.w,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return GestureDetector(
                        onTap: logic.addFavorite,
                        child: ImageLibrary.addFavorite.toImage
                          ..width = 70.w
                          ..height = 70.h,
                      );
                    }
                    var url = logic.cacheLogic.urlList[index - 1];
                    return GestureDetector(
                      onTap: logic.isMultiModel.value
                          ? () => logic.updateSelectedStatus(url)
                          : null,
                      child: Stack(
                        children: [
                          ImageUtil.networkImage(
                            url: url,
                            width: 70.w,
                            height: 70.h,
                            cacheWidth: 70.w.toInt(),
                            fit: BoxFit.cover,
                          ),
                          if (logic.isMultiModel.value)
                            Positioned(
                              right: 4.5.w,
                              bottom: 4.5.h,
                              child: ChatRadio(checked: logic.isChecked(url)),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _bottomBar(),
            ],
          ),
        ));
  }

  Widget _bottomBar() => Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          border: BorderDirectional(
            top: BorderSide(color: StylesLibrary.c_E8EAEF, width: 1.h),
          ),
        ),
        child: Row(
          children: [
            sprintf(StrLibrary.favoriteCount,
                [logic.cacheLogic.favoriteList.length]).toText
              ..style = StylesLibrary.ts_999999_16sp,
            const Spacer(),
            if (logic.isMultiModel.value)
              GestureDetector(
                onTap: logic.delete,
                behavior: HitTestBehavior.translucent,
                child:
                    sprintf(StrLibrary.favoriteDel, [logic.selectedList.length])
                        .toText
                      ..style = StylesLibrary.ts_8443F8_16sp,
              ),
          ],
        ),
      );
}
