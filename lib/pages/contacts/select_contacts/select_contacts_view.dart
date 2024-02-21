import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

import 'select_contacts_logic.dart';

class SelectContactsPage extends StatelessWidget {
  final logic = Get.find<SelectContactsLogic>();

  SelectContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: logic.appBarTitle.value),
      backgroundColor: Styles.c_F7F8FA,
      body: Column(
        children: [
          // GestureDetector(
          //   behavior: HitTestBehavior.translucent,
          //   onTap: logic.selectFromSearch,
          //   child: Container(
          //     color: Styles.c_FFFFFF,
          //     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          //     child: const SearchBox(),
          //   ),
          // ),
          12.verticalSpace,
          Flexible(
            child: Obx(() => CustomScrollView(
                  slivers: [
                    SliverFixedExtentList(
                      delegate: SliverChildListDelegate(
                        [
                          _buildCategoryItemView(
                            label: StrRes.myFriend,
                            onTap: logic.selectFromMyFriend,
                          ),
                          if (!logic.hiddenGroup)
                            _buildCategoryItemView(
                              label: StrRes.myGroup,
                              onTap: logic.selectFromMyGroup,
                            ),
                          // if (!logic.hiddenOrganization)
                          //   _buildCategoryItemView(
                          //     label: StrRes.organizationStructure,
                          //     onTap: logic.selectFromOrganization,
                          //   ),
                          if (!logic.hiddenTagGroup)
                            _buildCategoryItemView(
                              label: StrRes.tagGroup,
                              onTap: logic.selectTagGroup,
                            ),
                        ],
                      ),
                      itemExtent: 54.h,
                    ),
                    if (logic.conversationList.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Container(
                          height: 29.h,
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.symmetric(horizontal: 12.w),
                          child: StrRes.recentConversations.toText
                            ..style = Styles.ts_999999_12sp,
                        ),
                      ),
                    SliverFixedExtentList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: logic.conversationList.length,
                        (_, index) => _buildRecentConversationsItemView(
                          logic.conversationList.elementAt(index),
                        ),
                      ),
                      itemExtent: 86.h,
                    ),
                  ],
                )),
          ),
          logic.checkedConfirmView,
        ],
      ),
    );
  }

  Widget _buildCategoryItemView({
    required String label,
    Function()? onTap,
  }) =>
      Ink(
        height: 54.h,
        color: Styles.c_FFFFFF,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                label.toText..style = Styles.ts_333333_16sp,
                const Spacer(),
                ImageRes.appRightArrow.toImage
                  ..width = 20.w
                  ..height = 20.h,
              ],
            ),
          ),
        ),
      );

  Widget _buildRecentConversationsItemView(ConversationInfo info) {
    Widget buildChild() => Ink(
          height: 54.h,
          color: Styles.c_FFFFFF,
          child: InkWell(
            onTap: logic.onTap(info),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  if (logic.isMultiModel)
                    Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: ChatRadio(
                        checked: logic.isChecked(info),
                      ),
                    ),
                  AvatarView(
                    url: info.faceURL,
                    text: info.showName,
                    isGroup: !info.isSingleChat,
                  ),
                  10.horizontalSpace,
                  Flexible(
                    child: (info.showName ?? '').toText
                      ..style = Styles.ts_333333_16sp
                      ..maxLines = 1
                      ..overflow = TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
    return logic.isMultiModel ? Obx(buildChild) : buildChild();
  }
}

class CheckedConfirmView extends StatelessWidget {
  CheckedConfirmView({Key? key}) : super(key: key);
  final logic = Get.find<SelectContactsLogic>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86.h,
      decoration: BoxDecoration(
        color: Styles.c_F7F7F7,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -1.h),
            blurRadius: 4.r,
            spreadRadius: 1.r,
            color: Styles.c_000000_opacity4,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Obx(() => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: logic.viewSelectedContactsList,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ImageRes.appUpArrow.toImage
                        ..width = 10.w
                        ..height = 6.h,
                      if (logic.checkedList.isNotEmpty) 17.horizontalSpace,
                      Expanded(
                        child: logic.checkedStrTips.toText
                          ..style = Styles.ts_999999_14sp
                          ..maxLines = 1
                          ..overflow = TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ),
              Button(
                height: 28.h,
                enabled: logic.enabledConfirmButton,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                text: sprintf(
                    StrRes.confirmSelectedPeople, [logic.checkedList.length]),
                textStyle: Styles.ts_FFFFFF_14sp,
                onTap: logic.confirmSelectedList,
              ),
            ],
          )),
    );
  }
}

class SelectedContactsListView extends StatelessWidget {
  SelectedContactsListView({Key? key}) : super(key: key);
  final logic = Get.find<SelectContactsLogic>();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 548.h),
      decoration: BoxDecoration(
        color: Styles.c_FFFFFF,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6.r),
          topRight: Radius.circular(6.r),
        ),
      ),
      child: Obx(() => Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(color: Styles.c_E8EAEF, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    sprintf(StrRes.selectedPeopleCount,
                        [logic.checkedList.length]).toText
                      ..style = Styles.ts_333333_16sp_medium,
                    const Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => Get.back(),
                      child: Container(
                        height: 52.h,
                        alignment: Alignment.center,
                        child: StrRes.confirm.toText
                          ..style = Styles.ts_8443F8_16sp,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: logic.checkedList.length,
                  shrinkWrap: true,
                  itemBuilder: (_, index) => _buildItemView(index),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildItemView(int index) {
    final info = logic.checkedList.values.elementAt(index);
    String? name;
    String? faceURL;
    bool isGroup = false;
    name = SelectContactsLogic.parseName(info);
    faceURL = SelectContactsLogic.parseFaceURL(info);
    if (info is ConversationInfo) {
      isGroup = !info.isSingleChat;
    } else if (info is GroupInfo) {
      isGroup = true;
    }
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      color: Styles.c_FFFFFF,
      child: Row(
        children: [
          if (info is TagInfo)
            ImageRes.tagGroup.toImage
              ..width = 44.w
              ..height = 44.h
          else
            AvatarView(url: faceURL, text: name, isGroup: isGroup),
          10.horizontalSpace,
          Expanded(
            child: (name ?? '').toText
              ..style = Styles.ts_333333_16sp
              ..maxLines = 1
              ..overflow = TextOverflow.ellipsis,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => logic.removeItem(info),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 4.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.r),
                border: Border.all(
                  color: Styles.c_E8EAEF,
                  width: 1,
                ),
              ),
              child: StrRes.remove.toText..style = Styles.ts_8443F8_16sp,
            ),
          ),
        ],
      ),
    );
  }
}
