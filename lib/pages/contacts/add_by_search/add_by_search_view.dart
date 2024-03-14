import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sprintf/sprintf.dart';

import 'add_by_search_logic.dart';

class AddContactsBySearchPage extends StatelessWidget {
  final logic = Get.find<AddContactsBySearchLogic>();

  AddContactsBySearchPage({super.key});

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
          Divider(color: Styles.c_E8EAEF, height: 1.h),
          Obx(() => Expanded(
                child: logic.isSearchUser
                    ? (logic.isNotFoundUser
                        ? _buildNotFoundView()
                        : _buildUserListView())
                    : (logic.isNotFoundGroup
                        ? _buildNotFoundView()
                        : (Column(
                            children: logic.groupInfoList
                                .map((e) => _buildItemView(e))
                                .toList(),
                          ))),
              ))
        ],
      ),
    );
  }

  Widget _buildUserListView() => SmartRefresher(
        controller: logic.refreshCtrl,
        enablePullDown: false,
        enablePullUp: true,
        footer: IMViews.buildFooter(),
        onLoading: logic.loadMoreUser,
        child: ListView.builder(
          itemCount: logic.userInfoList.length,
          itemBuilder: (_, index) {
            final userInfo = logic.userInfoList.elementAt(index);
            return _buildItemView(userInfo);
          },
        ),
      );

  Widget _buildItemView(dynamic info) => InkWell(
        onTap: () => logic.viewInfo(info),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            border: BorderDirectional(
              bottom: BorderSide(color: Styles.c_E8EAEF, width: 1.h),
            ),
          ),
          height: 49.h,
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

  Widget _buildNotFoundView() => Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: (logic.isSearchUser
                ? StrLibrary.noFoundUser
                : StrLibrary.noFoundGroup)
            .toText
          ..style = Styles.ts_999999_16sp,
      );
}
