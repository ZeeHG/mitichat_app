import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:search_keyword_text/search_keyword_text.dart';

import 'search_group_member_logic.dart';

class SearchGroupMemberPage extends StatelessWidget {
  final logic = Get.find<SearchGroupMemberLogic>();

  SearchGroupMemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: TitleBar.search(
          focusNode: logic.focusNode,
          controller: logic.searchCtrl,
          onSubmitted: (_) => logic.search(),
          onCleared: () => logic.focusNode.requestFocus(),
        ),
        backgroundColor: StylesLibrary.c_F8F9FA,
        body: Obx(() => logic.isSearchNotResult
            ? _emptyView
            : SmartRefresher(
                controller: logic.controller,
                enablePullUp: true,
                enablePullDown: false,
                footer: IMViews.buildFooter(),
                onLoading: logic.load,
                child: ListView.builder(
                  itemCount: logic.memberList.length,
                  itemBuilder: (_, index) {
                    final info = logic.memberList[index];
                    if (logic.hiddenMembers(info)) {
                      return const SizedBox();
                    } else {
                      return _itemView(info);
                    }
                  },
                ),
              )),
      ),
    );
  }

  Widget _itemView(GroupMembersInfo membersInfo) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => logic.clickMember(membersInfo),
        child: Container(
          height: 64.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          color: StylesLibrary.c_FFFFFF,
          child: Row(
            children: [
              // if (logic.isMultiSelMode)
              //   Padding(
              //     padding: EdgeInsets.only(right: 15.w),
              //     child: ChatRadio(checked: logic.isChecked(membersInfo)),
              //   ),
              AvatarView(
                url: membersInfo.faceURL,
                text: membersInfo.nickname,
              ),
              10.horizontalSpace,
              Expanded(
                // child: (membersInfo.nickname ?? '').toText
                //   ..style = StylesLibrary.ts_333333_16sp
                //   ..maxLines = 1
                //   ..overflow = TextOverflow.ellipsis,
                child: SearchKeywordText(
                  text: membersInfo.nickname ?? '',
                  keyText: logic.searchCtrl.text.trim(),
                  style: StylesLibrary.ts_333333_16sp,
                  keyStyle: StylesLibrary.ts_8443F8_16sp,
                ),
              ),
              if (membersInfo.roleLevel == GroupRoleLevel.owner)
                StrLibrary.groupOwner.toText
                  ..style = StylesLibrary.ts_999999_16sp,
              if (membersInfo.roleLevel == GroupRoleLevel.admin)
                StrLibrary.groupAdmin.toText
                  ..style = StylesLibrary.ts_999999_16sp,
            ],
          ),
        ),
      );

  Widget get _emptyView => SizedBox(
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 157.verticalSpace,
            // ImageLibrary.blacklistEmpty.toImage
            //   ..width = 120.w
            //   ..height = 120.h,
            // 22.verticalSpace,
            44.verticalSpace,
            StrLibrary.searchNotFound.toText
              ..style = StylesLibrary.ts_999999_16sp,
          ],
        ),
      );
}
