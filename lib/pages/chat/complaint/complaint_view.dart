import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'complaint_logic.dart';

class ComplaintPage extends StatelessWidget {
  final logic = Get.find<ComplaintLogic>();

  ComplaintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(
            title: logic.pageTitle.value,
          ),
          backgroundColor: Styles.c_F7F8FA,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  width: 1.sw,
                  child: Column(
                      children: logic.status.value == "select"
                          ? (logic.complaintType.value == ComplaintType.xhs
                              ? [
                                  12.verticalSpace,
                                  _buildItemView(
                                      showRadio: true,
                                      showRightArrow: false,
                                      text: StrLibrary.riskyLocation,
                                      value: "风险地点",
                                      onTap: () => logic.mulSelect("风险地点")),
                                  _buildItemView(
                                      showRadio: true,
                                      showRightArrow: false,
                                      text: StrLibrary.suspectedFraud,
                                      value: "涉嫌欺诈",
                                      onTap: () => logic.mulSelect("涉嫌欺诈")),
                                  _buildItemView(
                                      showRadio: true,
                                      showRightArrow: false,
                                      text: StrLibrary.pornography,
                                      value: "色情低俗",
                                      onTap: () => logic.mulSelect("色情低俗")),
                                  _buildItemView(
                                      showRadio: true,
                                      showRightArrow: false,
                                      text: StrLibrary.illegalActivities,
                                      value: "违法犯罪",
                                      onTap: () => logic.mulSelect("违法犯罪")),
                                  _buildItemView(
                                      showRadio: true,
                                      showRightArrow: false,
                                      text: StrLibrary.politicalSensitivity,
                                      value: "政治敏感",
                                      onTap: () => logic.mulSelect("政治敏感")),
                                  _buildItemView(
                                      showRadio: true,
                                      showRightArrow: false,
                                      text: StrLibrary.falseInformation,
                                      value: "虚假不实",
                                      onTap: () => logic.mulSelect("虚假不实")),
                                  _buildItemView(
                                      showRadio: true,
                                      showRightArrow: false,
                                      text: StrLibrary.involvingMinors,
                                      value: "涉未成年",
                                      onTap: () => logic.mulSelect("涉未成年")),
                                  _buildItemView(
                                      showRadio: true,
                                      showRightArrow: false,
                                      text: StrLibrary.abuse,
                                      value: "辱骂引战",
                                      onTap: () => logic.mulSelect("辱骂引战")),
                                  _buildItemView(
                                      showRadio: true,
                                      showRightArrow: false,
                                      text: StrLibrary.publicOrder,
                                      value: "违反公德秩序",
                                      onTap: () => logic.mulSelect("违反公德秩序")),
                                  _buildItemView(
                                      showRadio: true,
                                      showRightArrow: false,
                                      text: StrLibrary.spamAds,
                                      value: "低差广告",
                                      onTap: () => logic.mulSelect("低差广告")),
                                  _buildItemView(
                                      showRadio: true,
                                      showRightArrow: false,
                                      text: StrLibrary.personalSafety,
                                      value: "危害人身安全",
                                      onTap: () => logic.mulSelect("危害人身安全")),
                                  _buildItemView(
                                      showRadio: true,
                                      showRightArrow: false,
                                      text: StrLibrary.plagiarism,
                                      value: "搬运抄袭洗稿",
                                      onTap: () => logic.mulSelect("搬运抄袭洗稿")),
                                  _buildItemView(
                                      showRadio: true,
                                      showRightArrow: false,
                                      text: StrLibrary.infringement2,
                                      value: "侵犯权益",
                                      onTap: () => logic.mulSelect("侵犯权益")),
                                  _buildItemView(
                                      showRadio: true,
                                      showRightArrow: false,
                                      text: StrLibrary.illegalSales,
                                      value: "违规售卖",
                                      onTap: () => logic.mulSelect("违规售卖")),
                                  _buildItemView(
                                      showRadio: true,
                                      showRightArrow: false,
                                      text: StrLibrary.other,
                                      value: "其他",
                                      onTap: () => logic.mulSelect("其他")),
                                  100.verticalSpace
                                ]
                              : [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                        left: 12.w,
                                        right: 12.w,
                                        top: 16.h,
                                        bottom: 16.h),
                                    child: StrLibrary.complaintReason.toText
                                      ..style = Styles.ts_999999_14sp,
                                  ),
                                  _buildItemView(
                                      text: StrLibrary.harassmentContent,
                                      onTap: () => logic
                                          .changeType("ObjectionableContent")),
                                  _buildItemView(
                                      text: StrLibrary.accountHacked,
                                      onTap: () =>
                                          logic.changeType("AccountStolen")),
                                  _buildItemView(
                                      text: StrLibrary.infringement,
                                      onTap: () =>
                                          logic.changeType("Infringement")),
                                  _buildItemView(
                                      text: StrLibrary.impersonation,
                                      onTap: () =>
                                          logic.changeType("AccountFraud")),
                                  _buildItemView(
                                      text: StrLibrary.minorRightsViolation,
                                      onTap: () =>
                                          logic.changeType("MinorsViolation")),
                                  _buildItemView(
                                      text: StrLibrary.chatEncryption,
                                      onTap: () => logic.changeType("Others")),
                                ])
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
                                        SizedBox(
                                          height: 160.h,
                                          child: TextField(
                                            controller: logic.inputCtrl,
                                            focusNode: logic.focusNode,
                                            keyboardType:
                                                TextInputType.multiline,
                                            autofocus: false,
                                            minLines: null,
                                            maxLines: null,
                                            expands: true,
                                            style: Styles.ts_333333_14sp,
                                            maxLength: 200,
                                            decoration: InputDecoration(
                                              hintText:
                                                  StrLibrary.complaintDetails,
                                              counterStyle:
                                                  Styles.ts_999999_14sp,
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 0.w,
                                                vertical: 6.h,
                                              ),
                                              isDense: true,
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          height: 32.h,
                                          color: Styles.c_F1F2F6,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            StrLibrary.imageEvidence.toText
                                              ..style = Styles.ts_999999_14sp,
                                            "${logic.assetsList.length}/${logic.maxAssetsCount}"
                                                .toText
                                              ..style = Styles.ts_999999_14sp,
                                          ],
                                        ),
                                        16.verticalSpace,
                                        _assetGridView,
                                      ],
                                    ),
                                  ),
                                  50.verticalSpace,
                                  Button(
                                    enabled: logic.enabled,
                                    width: 1.sw - 83.w,
                                    text: StrLibrary.submit,
                                    onTap: logic.submit,
                                  )
                                ]
                              : [
                                  45.verticalSpace,
                                  ImageRes.appSuccess.toImage
                                    ..width = 70.w
                                    ..height = 70.h,
                                  24.verticalSpace,
                                  StrLibrary.submitSuccess.toText
                                    ..style = Styles.ts_333333_20sp_medium,
                                  10.verticalSpace,
                                  StrLibrary.promiseResponse.toText
                                    ..textAlign = TextAlign.center
                                    ..style = Styles.ts_999999_16sp,
                                  45.verticalSpace,
                                  Button(
                                    width: 1.sw - 72.w,
                                    text: StrLibrary.iKnow,
                                    onTap: logic.backHome,
                                  )
                                ]),
                ),
              ),
              if (logic.complaintType.value == ComplaintType.xhs &&
                  logic.status.value == 'select')
                Positioned(
                    bottom: 34.h,
                    child: SizedBox(
                      width: 1.sw,
                      child: Center(
                        child: Button(
                          width: 1.sw - 72.w,
                          text: StrLibrary.nextStep,
                          enabled: logic.reasonList.isNotEmpty,
                          onTap: () => logic.nextStep('input'),
                        ),
                      ),
                    ))
            ],
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
    TextStyle? textStyle,
    String? value,
    bool showRightArrow = true,
    bool showRadio = false,
    Function()? onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Container(
          color: Styles.c_FFFFFF,
          child: Container(
            height: 46.h,
            padding: EdgeInsets.only(right: 12.w),
            margin: EdgeInsets.only(left: 12.w),
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Styles.c_F1F2F6, width: 1.h))),
            child: Row(
              children: [
                text.toText..style = textStyle ?? Styles.ts_333333_16sp,
                const Spacer(),
                if (showRightArrow)
                  ImageRes.appRightArrow.toImage
                    ..width = 24.w
                    ..height = 24.h,
                if (showRadio) ...[
                  if (logic.reasonList.contains(value))
                    ImageRes.appChecked2.toImage
                      ..width = 20.w
                      ..height = 20.h,
                  if (!logic.reasonList.contains(value))
                    Container(
                        width: 20.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Styles.c_CFCFCF, width: 1.w),
                          borderRadius: BorderRadius.circular(10.r),
                        ))
                ]
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
