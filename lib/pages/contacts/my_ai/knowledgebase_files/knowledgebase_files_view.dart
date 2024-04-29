import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'knowledgebase_files_logic.dart';

class KnowledgebaseFilesPage extends StatelessWidget {
  final logic = Get.find<KnowledgebaseFilesLogic>();

  KnowledgebaseFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
          title: StrLibrary.knowledgebaseFiles,
          backgroundColor: StylesLibrary.c_F7F8FA),
      backgroundColor: StylesLibrary.c_F7F8FA,
      body: Obx(() => ListView.builder(
            itemCount: logic.files.length,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            itemBuilder: (_, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 15.h),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: StylesLibrary.c_FFFFFF,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageLibrary.files.toImage
                      ..width = 40.w
                      ..height = 40.h,
                    10.horizontalSpace,
                    Expanded(
                      child: logic.files[index].toText
                        ..style = StylesLibrary.ts_666666_16sp
                        ..maxLines = 1
                        ..overflow = TextOverflow.ellipsis,
                    ),
                    10.horizontalSpace
                  ],
                ),
              );
            },
          )),
    );
  }
}
