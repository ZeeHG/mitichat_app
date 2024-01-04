import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim/core/controller/im_controller.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'complaint_logic.dart';

class ComplaintPage extends StatelessWidget {
  final logic = Get.find<ComplaintLogic>();

  ComplaintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(
            title: logic.status.value != "result" ? StrRes.complaint : "",
          ),
          backgroundColor: Styles.c_F7F8FA,
          body: SingleChildScrollView(
            child: Container(
              width: 1.sw,
              child: Column(
                  children: logic.status.value == "select"
                      ? [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(
                                left: 12.w,
                                right: 12.w,
                                top: 16.h,
                                bottom: 16.h),
                            child: StrRes.complaintReason.toText
                              ..style = Styles.ts_999999_14sp,
                          ),
                          _buildItemView(
                              text: StrRes.harassmentContent,
                              onTap: () =>
                                  logic.changeType("ObjectionableContent")),
                          _buildItemView(
                              text: StrRes.accountHacked,
                              onTap: () => logic.changeType("AccountStolen")),
                          _buildItemView(
                              text: StrRes.infringement,
                              onTap: () => logic.changeType("Infringement")),
                          _buildItemView(
                              text: StrRes.impersonation,
                              onTap: () => logic.changeType("AccountFraud")),
                          _buildItemView(
                              text: StrRes.minorRightsViolation,
                              onTap: () => logic.changeType("MinorsViolation")),
                          _buildItemView(
                              text: StrRes.chatEncryption,
                              onTap: () => logic.changeType("Others")),
                        ]
                      : logic.status.value == "input"
                          ? [
                              Container(
                                margin: EdgeInsets.only(top: 16.h),
                                padding: EdgeInsets.only(
                                    left: 12.w,
                                    right: 12.w,
                                    top: 16.h,
                                    bottom: 16.h),
                                color: Styles.c_FFFFFF,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        StrRes.imageEvidence.toText
                                          ..style = Styles.ts_333333_14sp,
                                        "${logic.assetsList.length}/${logic.maxAssetsCount}"
                                            .toText
                                          ..style = Styles.ts_333333_14sp,
                                      ],
                                    ),
                                    16.verticalSpace,
                                    _assetGridView,
                                    Divider(
                                      height: 32.h,
                                      color: Styles.c_F1F2F6,
                                    ),
                                    SizedBox(
                                      height: 160.h,
                                      child: TextField(
                                        controller: logic.inputCtrl,
                                        focusNode: logic.focusNode,
                                        keyboardType: TextInputType.multiline,
                                        autofocus: false,
                                        minLines: null,
                                        maxLines: null,
                                        expands: true,
                                        style: Styles.ts_333333_14sp,
                                        maxLength: 200,
                                        decoration: InputDecoration(
                                          hintText: StrRes.complaintDetails,
                                          counterStyle: Styles.ts_999999_14sp,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 0.w,
                                            vertical: 6.h,
                                          ),
                                          isDense: true,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              50.verticalSpace,
                              Button(
                                enabled: logic.enabled,
                                width: 1.sw - 216.w,
                                text: StrRes.submit,
                                onTap: logic.submit,
                              )
                            ]
                          : [
                              45.verticalSpace,
                              ImageRes.appSuccess.toImage
                                ..width = 70.w
                                ..height = 70.h,
                              24.verticalSpace,
                              StrRes.submitSuccess.toText
                                ..style = Styles.ts_333333_20sp_medium,
                              10.verticalSpace,
                              StrRes.promiseResponse.toText
                                ..textAlign = TextAlign.center
                                ..style = Styles.ts_999999_16sp,
                              45.verticalSpace,
                              Button(
                                width: 1.sw - 72.w,
                                text: StrRes.backHome,
                                onTap: logic.backHome,
                              )
                            ]),
            ),
          ),
        ));
  }

  Widget get _assetGridView => Obx(
        () => GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 8.h,
          ),
          itemCount: logic.assetsList.length + logic.btnLength,
          itemBuilder: (_, index) {
            if (logic.showAddAssetsBtn(index)) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: logic.selectAssetsFromAlbum,
                  child: Container(
                      color: Styles.c_F7F7F7,
                      child: ImageRes.appAdd2.toImage
                        ..width = 34.w
                        ..height = 34.h),
                ),
              );
            }
            return _buildAssetsItemView(index, logic.assetsList[index], false);
          },
        ),
      );

  Widget _buildItemView({
    required String text,
    String? hintText,
    TextStyle? textStyle,
    String? value,
    bool switchOn = false,
    bool isTopRadius = false,
    bool isBottomRadius = false,
    bool showRightArrow = true,
    bool showSwitchButton = false,
    ValueChanged<bool>? onChanged,
    Function()? onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Container(
          color: Styles.c_FFFFFF,
          child: Container(
            height: hintText == null ? 46.h : 68.h,
            padding: EdgeInsets.only(right: 12.w),
            margin: EdgeInsets.only(left: 12.w),
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Styles.c_F1F2F6, width: 1.h))),
            child: Row(
              children: [
                null != hintText
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text.toText
                            ..style = textStyle ?? Styles.ts_333333_16sp,
                          hintText.toText..style = Styles.ts_999999_14sp,
                        ],
                      )
                    : (text.toText..style = textStyle ?? Styles.ts_333333_16sp),
                const Spacer(),
                if (null != value) value.toText..style = Styles.ts_999999_14sp,
                if (showSwitchButton)
                  CupertinoSwitch(
                    value: switchOn,
                    activeColor: Styles.c_07C160,
                    onChanged: onChanged,
                  ),
                if (showRightArrow)
                  ImageRes.appRightArrow.toImage
                    ..width = 24.w
                    ..height = 24.h,
              ],
            ),
          ),
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
}
