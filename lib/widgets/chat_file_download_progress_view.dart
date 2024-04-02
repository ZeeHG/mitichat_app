import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

class ChatFileDownloadProgressView extends StatelessWidget {
  ChatFileDownloadProgressView(this.message, {super.key});
  final Message message;
  final ctrl = Get.find<DownloadCtrl>();

  @override
  Widget build(BuildContext context) {
    final url = message.fileElem?.sourceUrl;
    return Obx(() => SizedBox(
          width: 38.w,
          height: 44.h,
          child: !(message.isFileType && null != ctrl.downloadTaskList[url])
              ? null
              : ValueListenableBuilder(
                  valueListenable: ctrl.downloadTaskList[url]!.status,
                  builder: (_, status, child) {
                    return ValueListenableBuilder(
                      valueListenable: ctrl.downloadTaskList[url]!.progress,
                      builder: (_, progress, child) {
                        return [
                          DownloadStatus.downloading,
                          DownloadStatus.paused,
                          DownloadStatus.queued
                        ].contains(status)
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  ImageRes.fileMask.toImage
                                    ..width = 38.w
                                    ..height = 44.h,
                                  SizedBox(
                                    width: 23.w,
                                    height: 23.w,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          backgroundColor: Styles.c_FFFFFF,
                                          color: Styles.c_8443F8,
                                          strokeWidth: 1.8,
                                          value: progress,
                                        ),
                                        if ([DownloadStatus.paused]
                                            .contains(status))
                                          ImageRes.progressGoing.toImage
                                            ..width = 15.w
                                            ..height = 15.h,
                                        if ([DownloadStatus.downloading]
                                            .contains(status))
                                          ImageRes.progressPause.toImage
                                            ..width = 15.w
                                            ..height = 15.h,
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : const SizedBox();
                      },
                    );
                  },
                ),
        ));
  }
}
