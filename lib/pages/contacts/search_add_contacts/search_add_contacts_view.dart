import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'search_add_contacts_logic.dart';

class SearchAddContactsPage extends StatelessWidget {
  final logic = Get.find<SearchAddContactsLogic>();

  SearchAddContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: logic.isSearchUser ? StrLibrary.addFriend : StrLibrary.addGroup,
      ),
      backgroundColor: Styles.c_FFFFFF,
      body: Column(
        children: [
          SearchBox(
            focusNode: logic.focusNode,
            controller: logic.searchCtrl,
            hintText: logic.isSearchUser
                ? StrLibrary.searchByPhoneAndUid
                : StrLibrary.searchIDAddGroup,
            enabled: true,
            autofocus: true,
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            onSubmitted: (_) => logic.search(),
          ),
          Container(color: Styles.c_E8EAEF, height: 1.h),
          Obx(() => Expanded(
                child: logic.isSearchUser
                    ? (logic.isNotFoundUser ? _empty() : _userList())
                    : (logic.isNotFoundGroup
                        ? _empty()
                        : (Column(
                            children: logic.groupInfoList
                                .map((e) => _item(e))
                                .toList(),
                          ))),
              ))
        ],
      ),
    );
  }

  Widget _userList() => SmartRefresher(
        controller: logic.refreshCtrl,
        enablePullDown: false,
        enablePullUp: true,
        footer: IMViews.buildFooter(),
        onLoading: logic.loadMoreUser,
        child: ListView.builder(
          itemCount: logic.userInfoList.length,
          itemBuilder: (_, i) {
            return Obx(() {
              return _item(logic.userInfoList[i]);
            });
          },
        ),
      );

  Widget _item(dynamic info) => GestureDetector(
        onTap: () => logic.viewInfo(info),
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            border: BorderDirectional(
              bottom: BorderSide(color: Styles.c_E8EAEF, width: 1.h),
            ),
          ),
          height: 50.h,
          child: Row(
            children: [
              (logic.isSearchUser
                      ? ImageRes.searchPersonIcon
                      : ImageRes.searchGroupIcon)
                  .toImage
                ..width = 24.w
                ..height = 24.h,
              12.horizontalSpace,
              Expanded(
                  child: logic.getShowTitle(info).toText
                    ..style = Styles.ts_9280B3_16sp
                    ..maxLines = 1
                    ..overflow = TextOverflow.ellipsis),
            ],
          ),
        ),
      );

  Widget _empty() => Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: (logic.isSearchUser
                ? StrLibrary.noFoundUser
                : StrLibrary.noFoundGroup)
            .toText
          ..style = Styles.ts_999999_16sp,
      );
}
