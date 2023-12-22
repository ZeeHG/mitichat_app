import 'package:common_utils/common_utils.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sprintf/sprintf.dart';

import 'tag_notification_issued_logic.dart';

class TagNotificationIssuedPage extends StatelessWidget {
  final logic = Get.find<TagNotificationIssuedLogic>();

  TagNotificationIssuedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrRes.issueNotice,
        right: StrRes.newBuild.toText
          ..style = Styles.ts_0C1C33_17sp
          ..onTap = logic.newBuild,
      ),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => SlidableAutoCloseBehavior(
            child: SmartRefresher(
              controller: logic.refreshCtrl,
              enablePullDown: true,
              enablePullUp: true,
              header: IMViews.buildHeader(),
              footer: IMViews.buildFooter(),
              onRefresh: logic.queryNotificationLogs,
              onLoading: logic.loadNotificationLogs,
              child: logic.list.isEmpty
                  ? ListView(children: [_emptyListView])
                  : ListView.builder(
                      itemCount: logic.list.length,
                      padding: EdgeInsets.only(top: 10.h),
                      itemBuilder: (_, index) => _buildNotificationItemView(
                          logic.list.elementAt(index)),
                    ),
            ),
          )),
    );
  }

  Widget _buildNotificationItemView(TagNotification ntf) => Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: .2,
          children: [
            CustomSlidableAction(
              onPressed: (_) => logic.delete(ntf),
              flex: 1,
              backgroundColor: Styles.c_FF381F,
              child: StrRes.delete.toText..style = Styles.ts_FFFFFF_16sp,
            ),
          ],
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => logic.viewNotificationDetail(ntf),
          child: _buildItemView(ntf),
        ),
      );

  Widget _buildItemView(TagNotification ntf) {
    final content = ntf.parseContent();
    TextElem? textElem;
    SoundElem? soundElem;
    if (null != content) {
      textElem = content.textElem;
      soundElem = content.soundElem;
    }
    final dt = DateTime.fromMillisecondsSinceEpoch(ntf.sendTime!);
    return Container(
      margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: Styles.c_FFFFFF,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sprintf(StrRes.notificationReceiver,
              [logic.getAcceptCount(ntf), logic.getAcceptObject(ntf)]).toText
            ..style = Styles.ts_8E9AB0_16sp
            ..maxLines = 2
            ..overflow = TextOverflow.ellipsis,
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.h),
            color: Styles.c_E8EAEF,
            height: .5,
          ),
          if (null != textElem)
            textElem.content!.toText
              ..style = Styles.ts_0C1C33_17sp
              ..maxLines = 2
              ..overflow = TextOverflow.ellipsis,
          if (null != soundElem)
            Obx(() => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => logic.playVoiceMessage(ntf),
                  child: SizedBox(
                    width: 88.w,
                    height: 44.h,
                    child: ChatBubble(
                      bubbleType: BubbleType.receiver,
                      backgroundColor: Styles.c_CCE7FE,
                      child: ChatVoiceView(
                        isISend: false,
                        soundPath: soundElem!.soundPath,
                        soundUrl: soundElem.sourceUrl,
                        duration: soundElem.duration,
                        isPlaying: logic.isPlaySound(ntf),
                      ),
                    ),
                  ),
                )),
          if (null == textElem && null == soundElem)
            StrRes.unsupportedMessage.toText..style = Styles.ts_0C1C33_17sp,
          16.verticalSpace,
          Align(
            alignment: Alignment.centerRight,
            child: DateUtil.formatDateMs(
              ntf.sendTime ?? 0,
              format: dt.isThisYear
                  ? IMUtils.getTimeFormat3()
                  : IMUtils.getTimeFormat2(),
            ).toText
              ..style = Styles.ts_8E9AB0_14sp,
          ),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
          //     decoration: BoxDecoration(
          //       color: Styles.c_0089FF,
          //       borderRadius: BorderRadius.circular(21.r),
          //     ),
          //     child: StrRes.sendAnother.toText..style = Styles.ts_FFFFFF_16sp,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget get _emptyListView => SizedBox(
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            157.verticalSpace,
            ImageRes.blacklistEmpty.toImage
              ..width = 120.w
              ..height = 120.h,
            22.verticalSpace,
            StrRes.emptyNotification.toText..style = Styles.ts_8E9AB0_16sp,
          ],
        ),
      );
}
