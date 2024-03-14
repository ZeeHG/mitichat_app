import 'package:flutter/cupertino.dart';
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
      child: Obx(() => Scaffold(
            appBar: TitleBar.back(
              onTap: logic.back,
              title: logic.isPicture
                  ? StrLibrary.publishPicture
                  : StrLibrary.publishVideo,
              right: Button(
                  text: StrLibrary.publish,
                  textStyle: Styles.ts_FFFFFF_14sp,
                  disabledTextStyle: Styles.ts_FFFFFF_14sp,
                  height: 28.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  onTap: logic.publish,
                  enabled: logic.canPublish),
            ),
            backgroundColor: Styles.c_F8F9FA,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  10.verticalSpace,
                  Container(
                    color: Styles.c_FFFFFF,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 300.h,
                          child: TextField(
                            controller: logic.inputCtrl,
                            focusNode: logic.focusNode,
                            keyboardType: TextInputType.multiline,
                            autofocus: false,
                            minLines: null,
                            maxLines: null,
                            expands: true,
                            style: Styles.ts_333333_16sp,
                            maxLength: 5570,
                            decoration: InputDecoration(
                              counterStyle: Styles.ts_999999_14sp,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 6.h,
                              ),
                              isDense: true,
                            ),
                          ),
                        ),
                        if (logic.isPublishXhs.value) ...[
                          16.verticalSpace,
                          Container(
                            width: 1.sw,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: Wrap(
                              spacing: 10.w,
                              runSpacing: 5.h,
                              alignment: WrapAlignment.start,
                              children: List.generate(
                                  logic.tags.length,
                                  (index) => Obx(() {
                                        final tag = logic.tags[index];
                                        final isActive =
                                            logic.activeTag.value.value ==
                                                tag.value;
                                        return GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () => logic.selectTag(index),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 4.h),
                                            decoration: BoxDecoration(
                                              color: isActive
                                                  ? Styles.c_8443F8
                                                  : Styles.c_F7F7F7,
                                              borderRadius:
                                                  BorderRadius.circular(17.r),
                                            ),
                                            child: "# ${tag.label}".toText
                                              ..style = isActive
                                                  ? Styles.ts_FFFFFF_12sp
                                                  : Styles.ts_999999_12sp,
                                          ),
                                        );
                                      })),
                            ),
                          ),
                        ],
                        16.verticalSpace,
                        _assetGridView,
                      ],
                    ),
                  ),
                  10.verticalSpace,
                  // _buildItemView(
                  //   icon: ImageRes.appLocation,
                  //   text: StrLibrary .myLocation,
                  //   onTap: showDeveloping,
                  // ),
                  if (!logic.isPublishXhs.value) ...[
                    Obx(
                      () => _buildItemView(
                        icon: ImageRes.appRemindWhoToWatch,
                        text: StrLibrary.remindWhoToWatch,
                        onTap: logic.remindWhoToWatch,
                        value: logic.remindWhoToWatchValue,
                      ),
                    ),
                    Obx(
                      () => _buildItemView(
                        icon: ImageRes.appWhoCanWatch,
                        text: logic.whoCanWatchLabel,
                        showUnderline: true,
                        onTap: logic.whoCanWatch,
                        value: logic.whoCanWatchValue,
                      ),
                    )
                  ],
                  _buildItemView(
                    icon: ImageRes.appWhoCanWatch,
                    text: StrLibrary.allCanSee,
                    showUnderline: true,
                    showSwitchButton: true,
                    onChanged: (_) => logic.changePublish(),
                  ),
                  if (logic.isPublishXhs.value) ...[
                    12.verticalSpace,
                    Container(
                        height: 53.h,
                        padding: EdgeInsets.only(left: 20.w, right: 12.w),
                        decoration: BoxDecoration(
                          color: Styles.c_FFFFFF,
                          border: BorderDirectional(
                            bottom: BorderSide(
                              color: Styles.c_F1F2F6,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Center(
                          child: InputBox(
                            label: "",
                            border: false,
                            hintText: StrLibrary.pleaseInputTitle,
                            controller: logic.titleCtrl,
                          ),
                        )),
                    if (!logic.isReprintArticle.value)
                      _buildItemView(
                        icon: ImageRes.reprintArticle,
                        text: StrLibrary.reprintArticle,
                        onTap: logic.changeReprintArticle,
                      ),
                    if (logic.isReprintArticle.value) ...[
                      Container(
                          height: 53.h,
                          padding: EdgeInsets.only(left: 20.w, right: 12.w),
                          decoration: BoxDecoration(
                            color: Styles.c_FFFFFF,
                            border: BorderDirectional(
                              bottom: BorderSide(
                                color: Styles.c_F1F2F6,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Center(
                            child: InputBox(
                              label: "",
                              border: false,
                              hintText: StrLibrary.pleaseInputOriginUrl,
                              controller: logic.originUrlCtrl,
                            ),
                          )),
                      Container(
                          height: 53.h,
                          padding: EdgeInsets.only(left: 20.w, right: 12.w),
                          decoration: BoxDecoration(
                            color: Styles.c_FFFFFF,
                            border: BorderDirectional(
                              bottom: BorderSide(
                                color: Styles.c_F1F2F6,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Center(
                            child: InputBox(
                              label: "",
                              border: false,
                              hintText: StrLibrary.pleaseInputAuthor,
                              controller: logic.authorCtrl,
                            ),
                          ))
                    ],
                  ]
                ],
              ),
            ),
          )),
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
    bool showSwitchButton = false,
    Function()? onTap,
    Function(bool)? onChanged,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Container(
          height: 53.h,
          padding: EdgeInsets.only(left: 20.w, right: 12.w),
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            border: showUnderline
                ? BorderDirectional(
                    bottom: BorderSide(
                      color: Styles.c_F1F2F6,
                      width: 1,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              icon.toImage..width = 18.w,
              12.horizontalSpace,
              text.toText..style = Styles.ts_333333_16sp,
              Expanded(
                child: (value ?? '').toText
                  ..style = Styles.ts_333333_16sp
                  ..maxLines = 1
                  ..overflow = TextOverflow.ellipsis
                  ..textAlign = TextAlign.end,
              ),
              if (!showSwitchButton)
                ImageRes.appRightArrow.toImage
                  ..width = 20.w
                  ..height = 20.h,
              if (showSwitchButton)
                CupertinoSwitch(
                  value: logic.isPublishXhs.value,
                  activeColor: Styles.c_07C160,
                  onChanged: onChanged,
                ),
            ],
          ),
        ),
      );
}
