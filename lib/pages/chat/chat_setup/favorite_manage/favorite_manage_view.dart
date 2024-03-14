import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

import 'favorite_manage_logic.dart';

class FavoriteManagePage extends StatelessWidget {
  final logic = Get.find<FavoriteManageLogic>();

  FavoriteManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(
            title: StrLibrary.favoriteFace,
            right: StrLibrary.favoriteManage.toText
              ..onTap = logic.manage
              ..style = Styles.ts_333333_17sp,
          ),
          body: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 22.w,
                    vertical: 10.h,
                  ),
                  itemCount: logic.cacheLogic.urlList.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    mainAxisSpacing: 22.h,
                    crossAxisSpacing: 22.w,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return GestureDetector(
                        onTap: logic.addFavorite,
                        child: ImageRes.addFavorite.toImage
                          ..width = 66.w
                          ..height = 66.h,
                      );
                    }
                    var url = logic.cacheLogic.urlList.elementAt(index - 1);
                    return GestureDetector(
                      onTap: logic.isMultiModel.value
                          ? () => logic.updateSelectedStatus(url)
                          : null,
                      child: Stack(
                        children: [
                          ImageUtil.networkImage(
                            url: url,
                            width: 66.w,
                            height: 66.h,
                            cacheWidth: 66.w.toInt(),
                            fit: BoxFit.cover,
                          ),
                          if (logic.isMultiModel.value)
                            Positioned(
                              right: 4.w,
                              bottom: 4.h,
                              child: ChatRadio(checked: logic.isChecked(url)),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ));
  }

  Widget _buildBottomBar() => Container(
        height: 48.h,
        padding: EdgeInsets.only(left: 22.w),
        decoration: BoxDecoration(
          border: BorderDirectional(
            top: BorderSide(color: Styles.c_E8EAEF, width: 1),
          ),
        ),
        child: Row(
          children: [
            sprintf(StrLibrary.favoriteCount,
                [logic.cacheLogic.favoriteList.length]).toText
              ..style = Styles.ts_999999_16sp,
            const Spacer(),
            if (logic.isMultiModel.value)
              GestureDetector(
                onTap: logic.delete,
                behavior: HitTestBehavior.translucent,
                child:
                    sprintf(StrLibrary.favoriteDel, [logic.selectedList.length])
                        .toText
                      ..style = Styles.ts_8443F8_16sp,
              ),
          ],
        ),
      );
}
