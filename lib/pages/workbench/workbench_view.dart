// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:miti_common/miti_common.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// import 'workbench_logic.dart';

// class WorkbenchPage extends StatelessWidget {
//   final logic = Get.find<WorkbenchLogic>();

//   WorkbenchPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: TitleBar.workbench(),
//       backgroundColor: Styles.c_F8F9FA,
//       body: Obx(() => _buildBody()),
//     );
//   }

//   Widget _buildBody() {
//     return Obx(() => H5Container(url: logic.url.value));

//     return SmartRefresher(
//       controller: logic.refreshCtrl,
//       header: IMViews.buildHeader(),
//       enablePullDown: true,
//       enablePullUp: false,
//       onRefresh: logic.refreshList,
//       child: logic.list.isNotEmpty ? _buildMPView() : _emptyListView,
//     );
//   }

//   Widget _buildMPView() => GridView.builder(
//         padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 16.w),
//         itemCount: logic.list.length,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 4,
//           mainAxisSpacing: 32.h,
//           crossAxisSpacing: 42.2,
//           childAspectRatio: 43.w / 68.h,
//         ),
//         itemBuilder: (_, index) {
//           final info = logic.list.elementAt(index);
//           return Obx(() => GestureDetector(
//                 onTap: () => logic.startUniMP(info),
//                 child: _buildItemView(info.value),
//               ));
//         },
//       );

//   Widget _buildItemView(UniMPInfo info) => ClipRRect(
//         borderRadius: BorderRadius.circular(6.r),
//         child: Column(
//           children: [
//             Container(
//               width: 42.w,
//               height: 42.h,
//               margin: EdgeInsets.only(bottom: 9.h),
//               child: Stack(
//                 children: [
//                   info.url != null
//                       ? ImageUtil.networkImage(
//                           url: info.icon!,
//                           width: 42.h,
//                           height: 42.h,
//                         )
//                       : const SizedBox(),
//                   if (null != info.progress &&
//                       info.progress! > 0 &&
//                       info.progress! < 100)
//                     Container(
//                       width: 42.h,
//                       height: 42.h,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: Colors.black54,
//                         borderRadius: BorderRadius.circular(6.r),
//                       ),
//                       child: '${info.progress}%'.toText
//                         ..style = Styles.ts_FFFFFF_12sp,
//                     )
//                 ],
//               ),
//             ),
//             (info.name ?? '').toText..style = Styles.ts_333333_17sp,
//           ],
//         ),
//       );

//   Widget get _emptyListView => ListView(
//         children: [
//           SizedBox(
//             width: 1.sw,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 157.verticalSpace,
//                 ImageRes.blacklistEmpty.toImage
//                   ..width = 120.w
//                   ..height = 120.h,
//                 22.verticalSpace,
//                 StrLibrary.notFoundMinP.toText..style = Styles.ts_999999_16sp,
//               ],
//             ),
//           ),
//         ],
//       );
// }
