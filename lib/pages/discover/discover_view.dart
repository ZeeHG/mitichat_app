import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'discover_logic.dart';
import 'package:miti/core/controller/im_ctrl.dart';

class DiscoverPage extends StatelessWidget {
  final logic = Get.find<DiscoverLogic>();
  final imCtrl = Get.find<IMCtrl>();

  DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: TitleBar.discover(
        //   title: StrLibrary .discover,
        //   // backgroundImage: const DecorationImage(
        //   //   image: AssetImage(ImageRes.appHeaderBg, package: 'miti_common'),
        //   //   fit: BoxFit.cover,
        //   //   alignment: FractionalOffset.center,
        //   // ),
        // ),
        backgroundColor: Styles.c_FFFFFF,
        body: Obx(
          () => MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Stack(
              children: [
                ListView.builder(
                    controller: logic.scrollController,
                    itemCount: logic.moments.length + 1,
                    itemBuilder: (_, index) {
                      if (index == 0) {
                        return Container(
                          height: 240.h,
                          margin: EdgeInsets.only(bottom: 38.h),
                          clipBehavior: Clip.none,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(ImageRes.splash,
                                      package: 'miti_common'),
                                  fit: BoxFit.cover,
                                  alignment: FractionalOffset.center)),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                right: 18.w,
                                bottom: -20.h,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(imCtrl.userInfo.value.nickname!),
                                    Text(logic.scrollHeight.toString()),
                                    12.horizontalSpace,
                                    AvatarView(
                                      width: 60.w,
                                      height: 60.h,
                                      text: imCtrl.userInfo.value.nickname,
                                      url: imCtrl.userInfo.value.faceURL,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        final info = logic.moments.elementAt(index - 1);
                        return _buildItemView(info);
                      }
                    }),
                Container(
                  decoration: BoxDecoration(
                      color: logic.scrollHeight.value <= 190
                          ? Styles.transparent
                          : Styles.c_FFFFFF),
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: TitleBar.discover(
                    title: StrLibrary.discover,
                    backgroundColor: Styles.transparent,
                    backIconColor: logic.scrollHeight.value <= 190
                        ? Styles.c_FFFFFF
                        : Styles.c_333333,
                    titleStyle: logic.scrollHeight.value <= 190
                        ? Styles.ts_FFFFFF_17sp_semibold
                        : Styles.ts_333333_17sp_semibold,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildItemView(Moment moment) => Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvatarView(
              width: 48.w,
              height: 48.h,
              text: moment.nickname,
              url: imCtrl.userInfo.value.faceURL,
            ),
            12.horizontalSpace,
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(moment.nickname, style: Styles.ts_9280B3_16sp_medium),
                4.verticalSpace,
                if (null != moment.content)
                  Text(moment.content,
                      overflow: TextOverflow.visible,
                      style: Styles.ts_333333_16sp),
                12.verticalSpace,
                ImageRes.splash.toImage..height = 180.h,
                9.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(moment.time, style: Styles.ts_999999_12sp),
                    ImageRes.appDiscoverOperation.toImage
                      ..width = 24.w
                      ..height = 16.h
                  ],
                ),
                12.verticalSpace,
                Container(
                    decoration: BoxDecoration(
                      color: Styles.c_F7F7F7,
                    ),
                    child: Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Styles.c_EDEDED, width: 1.h))),
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 3.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 5.h),
                                  child: ImageRes.appLike.toImage
                                    ..width = 12.w
                                    ..height = 11.h,
                                ),
                                6.horizontalSpace,
                                Expanded(
                                  child: Text(moment.likes,
                                      overflow: TextOverflow.visible,
                                      style: Styles.ts_9280B3_14sp_medium),
                                ),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 3.h),
                            child: Column(
                                children: moment.comments
                                    .map((item) => _buildCommentsView(item))
                                    .toList()))
                      ],
                    )),
              ],
            ))
          ],
        ),
      );

  Widget _buildCommentsView(Comment comment) => Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${comment.nickname}：",
                overflow: TextOverflow.visible,
                style: Styles.ts_9280B3_14sp_medium),
            Expanded(
                child: Text(comment.content,
                    overflow: TextOverflow.visible,
                    style: Styles.ts_333333_14sp))
          ],
        ),
      );
}
