import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

import 'request_records_logic.dart';

class RequestRecordsPage extends StatelessWidget {
  final logic = Get.find<RequestRecordsLogic>();

  RequestRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: ""),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => ListView.builder(
            padding: EdgeInsets.only(top: 10.h),
            itemCount: logic.allList.length,
            itemBuilder: (_, index) => itemView(logic.allList[index]),
          )),
    );
  }

  Widget itemView(dynamic info) => info is FriendApplicationInfo
      ? _friendItemView(info)
      : _groupItemView(info);

  Widget _friendItemView(FriendApplicationInfo info) {
    final isISendRequest = info.fromUserID == OpenIM.iMManager.userID;
    String? name = isISendRequest ? info.toNickname : info.fromNickname;
    String? faceURL = isISendRequest ? info.toFaceURL : info.fromFaceURL;
    String? reason = info.reqMsg;

    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Styles.c_FFFFFF,
        border: BorderDirectional(
          bottom: BorderSide(
            color: Styles.c_F8F9FA,
            width: 1.h,
          ),
        ),
      ),
      child: Row(
        children: [
          AvatarView(url: faceURL, text: name),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (name ?? '').toText
                  ..style = Styles.ts_333333_17sp
                  ..maxLines = 1
                  ..overflow = TextOverflow.ellipsis,
                4.verticalSpace,
                if (MitiUtils.isNotNullEmptyStr(reason))
                  reason!.toText
                    ..style = Styles.ts_999999_14sp
                    ..maxLines = 1
                    ..overflow = TextOverflow.ellipsis,
              ],
            ),
          ),
          if (/*info.isWaitingHandle && */ isISendRequest)
            ImageRes.sendRequests.toImage
              ..width = 20.w
              ..height = 20.h,
          if (info.isWaitingHandle && !isISendRequest)
            Button(
              text: StrLibrary.lookOver,
              textStyle: Styles.ts_FFFFFF_14sp,
              onTap: () => logic.acceptFriendApplication(info),
              height: 28.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
            ),
          if (info.isWaitingHandle && isISendRequest)
            StrLibrary.waitingForVerification.toText
              ..style = Styles.ts_999999_14sp,
          if (info.isRejected)
            StrLibrary.rejected.toText..style = Styles.ts_999999_14sp,
          if (info.isAgreed)
            StrLibrary.approved.toText..style = Styles.ts_999999_14sp,
        ],
      ),
    );
  }

  Widget _groupItemView(GroupApplicationInfo info) {
    final isISendRequest = info.userID == OpenIM.iMManager.userID;
    return Container(
      // height: 68.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Styles.c_FFFFFF,
        border: BorderDirectional(
          bottom: BorderSide(color: Styles.c_F8F9FA, width: 1.h),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvatarView(
                  url: info.userFaceURL,
                  text: info.nickname,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (info.nickname ?? '').toText
                        ..style = Styles.ts_333333_17sp
                        ..maxLines = 1
                        ..overflow = TextOverflow.ellipsis,
                      4.verticalSpace,
                      if (!logic.isInvite(info))
                        RichText(
                          text: TextSpan(
                            text: StrLibrary.applyJoin,
                            style: Styles.ts_999999_14sp,
                            children: [
                              WidgetSpan(child: 2.horizontalSpace),
                              TextSpan(
                                text: logic.getGroupName(info),
                                style: Styles.ts_8443F8_14sp,
                              ),
                            ],
                          ),
                        )
                      else
                        RichText(
                          text: TextSpan(
                            text: logic.getInviterNickname(info),
                            style: Styles.ts_8443F8_14sp,
                            children: [
                              WidgetSpan(child: 2.horizontalSpace),
                              TextSpan(
                                text: StrLibrary.invite,
                                style: Styles.ts_999999_14sp,
                              ),
                              WidgetSpan(child: 2.horizontalSpace),
                              TextSpan(
                                text: info.nickname,
                                style: Styles.ts_8443F8_14sp,
                              ),
                              WidgetSpan(child: 2.horizontalSpace),
                              TextSpan(
                                text: StrLibrary.joinIn,
                                style: Styles.ts_999999_14sp,
                              ),
                              WidgetSpan(child: 2.horizontalSpace),
                              TextSpan(
                                text: logic.getGroupName(info),
                                style: Styles.ts_8443F8_14sp,
                              ),
                            ],
                          ),
                        ),
                      // 4.verticalSpace,
                      if (null != MitiUtils.emptyStrToNull(info.reqMsg))
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: sprintf(StrLibrary.applyReason, [info.reqMsg!])
                              .toText
                            ..style = Styles.ts_999999_14sp
                            ..maxLines = 1
                            ..overflow = TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          if (/*info.handleResult == 0 && */ isISendRequest)
            ImageRes.sendRequests.toImage
              ..width = 20.w
              ..height = 20.h,
          if (info.handleResult == 0 && !isISendRequest)
            Button(
              text: StrLibrary.lookOver,
              textStyle: Styles.ts_FFFFFF_14sp,
              height: 28.h,
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              onTap: () => logic.handle(info),
            ),
          if (info.handleResult == 0 && isISendRequest)
            StrLibrary.waitingForVerification.toText
              ..style = Styles.ts_999999_14sp,
          if (info.handleResult == -1)
            StrLibrary.rejected.toText..style = Styles.ts_999999_14sp,
          if (info.handleResult == 1)
            StrLibrary.approved.toText..style = Styles.ts_999999_14sp,
        ],
      ),
    );
  }
}
