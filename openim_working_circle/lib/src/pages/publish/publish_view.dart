import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'publish_logic.dart';

class PublishPage extends StatelessWidget {
  final logic = Get.find<PublishLogic>();

  PublishPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: TitleBar.back(
          title: logic.type == PublishType.picture
              ? StrRes.publishPicture
              : StrRes.publishVideo,
          right: Button(
            text: StrRes.publish,
            textStyle: Styles.ts_FFFFFF_14sp,
            height: 28.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            onTap: logic.publish,
          ),
        ),
        backgroundColor: Styles.c_F8F9FA,
        body: SingleChildScrollView(
          child: Column(
            children: [
              10.verticalSpace,
              Container(
                color: Styles.c_FFFFFF,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    SizedBox(
                      height: 120.h,
                      child: TextField(
                        controller: logic.inputCtrl,
                        focusNode: logic.focusNode,
                        keyboardType: TextInputType.multiline,
                        autofocus: false,
                        minLines: null,
                        maxLines: null,
                        expands: true,
                        style: Styles.ts_0C1C33_17sp,
                        maxLength: 150,
                        decoration: InputDecoration(
                          counterStyle: Styles.ts_8E9AB0_14sp,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                    19.verticalSpace,
                    _assetGridView,
                  ],
                ),
              ),
              10.verticalSpace,
              Obx(
                () => _buildItemView(
                  icon: ImageRes.whoCanWatch,
                  text: logic.whoCanWatchLabel,
                  showUnderline: true,
                  onTap: logic.whoCanWatch,
                  value: logic.whoCanWatchValue,
                ),
              ),
              Obx(
                () => _buildItemView(
                  icon: ImageRes.remindWhoToWatch,
                  text: StrRes.remindWhoToWatch,
                  onTap: logic.remindWhoToWatch,
                  value: logic.remindWhoToWatchValue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget get _assetGridView => Obx(
        () => GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.0,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 8.h,
          ),
          itemCount: logic.assetsList.length + logic.btnLength,
          itemBuilder: (_, index) {
            if (logic.isPicture) {
              if (logic.showAddAssetsBtn(index)) {
                return ImageRes.addFavorite.toImage..onTap = logic.selectAssets;
              }
              return _buildAssetsItemView(
                  index, logic.assetsList[index], false);
            } else {
              if (logic.assetsList.isEmpty) {
                return ImageRes.addFavorite.toImage..onTap = logic.selectAssets;
              }
              return _buildAssetsItemView(index, logic.assetsList[index], true);
            }
          },
        ),
      );

  Widget _buildAssetsItemView(int index, AssetEntity entity, bool isVideo) =>
      GestureDetector(
        onTap: () => logic.previewSelectedPicture(index),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: AssetEntityImage(
                entity,
                fit: BoxFit.cover,
              ),
            ),
            if (isVideo)
              Center(
                child: ImageRes.videoPause.toImage
                  ..width = 24.w
                  ..height = 24.h,
              ),
          ],
        ),
      );

  Widget _buildItemView({
    required String icon,
    required String text,
    String? value,
    bool showUnderline = false,
    Function()? onTap,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Container(
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            border: showUnderline
                ? BorderDirectional(
                    bottom: BorderSide(
                      color: Styles.c_E8EAEF,
                      width: 1,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              icon.toImage
                ..width = 20.w
                ..height = 20.h,
              10.horizontalSpace,
              text.toText..style = Styles.ts_0C1C33_17sp,
              Expanded(
                child: (value ?? '').toText
                  ..style = Styles.ts_8E9AB0_17sp
                  ..maxLines = 1
                  ..overflow = TextOverflow.ellipsis
                  ..textAlign = TextAlign.end,
              ),
              ImageRes.rightArrow.toImage
                ..width = 24.w
                ..height = 24.h,
            ],
          ),
        ),
      );
}
