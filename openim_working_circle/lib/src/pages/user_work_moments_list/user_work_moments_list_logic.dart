import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../openim_working_circle.dart';
import '../../w_apis.dart';

class UserWorkMomentsListLogic extends GetxController {
  final scrollController = ScrollController();
  final workMoments = <WorkMoments>[].obs;
  int pageNo = 1;
  int pageSize = 20;
  final hasMore = true.obs;
  bool isLoading = false;
  String? userID;
  late String nickname;
  late String faceURL;

  final dayTimelines = <WorkMoments, String?>{}.obs;
  final yearTimelines = <WorkMoments, String?>{}.obs;
  StreamSubscription? opEventSub;

  ViewUserProfileBridge? get bridge => PackageBridge.viewUserProfileBridge;

  WorkingCircleBridge? get wcBridge => PackageBridge.workingCircleBridge;

  @override
  void onClose() {
    opEventSub?.cancel();
    scrollController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    userID = Get.arguments['userID'];
    nickname = Get.arguments['nickname'] ?? OpenIM.iMManager.userInfo.nickname;
    faceURL = Get.arguments['faceURL'] ?? OpenIM.iMManager.userInfo.faceURL;
    scrollController.addListener(_scrollListener);
    opEventSub = wcBridge?.opEventSub.listen(_opEventListener);
    super.onInit();
  }

  @override
  void onReady() {
    _queryWorkingCircleList();
    super.onReady();
  }

  /// {'opEvent': OpEvent.delete, 'data': moments}
  _opEventListener(dynamic event) {
    // if (event is Map) {
    //   final opEvent = event['opEvent'];
    //   final data = event['data'];
    //   if (opEvent == OpEvent.delete) {
    //     workMoments.remove(data as WorkMoments);
    //   } else if (opEvent == OpEvent.publish) {
    //     // _queryWorkingCircleList();
    //   }
    // }
  }

  void _scrollListener() async {
    if (!isLoading &&
        hasMore.value &&
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
      isLoading = true;
      await _loadMore();
      isLoading = false;
    }
  }

  Future<WorkMomentsList> _request(int pageNo) => WApis.getUserMomentsList(
        userID: userID!,
        pageNumber: pageNo,
        showNumber: pageSize,
      );

  _queryWorkingCircleList() async {
    final result = await _request(pageNo = 1);
    final list = result.workMoments ?? [];
    hasMore.value = list.isNotEmpty && list.length == pageSize;
    workMoments.assignAll(list);
  }

  _loadMore() async {
    try {
      final result = await _request(++pageNo);
      final list = result.workMoments ?? [];
      hasMore.value = list.isNotEmpty && list.length == pageSize;
      workMoments.addAll(result.workMoments ?? []);
    } catch (_) {
      pageNo--;
    }
  }

  viewUserProfile(WorkMoments moments) => bridge?.viewUserProfile(
        moments.userID!,
        moments.nickname,
        moments.faceURL,
      );

  String? getTimelines(WorkMoments moments) {
    int ms = (moments.createTime ?? 0);
    int now = DateTime.now().millisecondsSinceEpoch;
    final day = IMUtils.getWorkMomentsTimeline(ms);
    final days = dayTimelines.values;
    if (!days.contains(day)) {
      dayTimelines[moments] = day;
      final isThisYear = DateUtil.yearIsEqualByMs(ms, now);
      final year = DateUtil.formatDateMs(ms, format: 'yyyy年');
      final years = yearTimelines.values;
      if (!years.contains(year) && !isThisYear) {
        yearTimelines[moments] = year;
      }
    }
    return dayTimelines[moments];
  }

  bool addMargin(int index) {
    if (index + 1 < workMoments.length) {
      final current = workMoments.elementAt(index);
      final next = workMoments.elementAt(index + 1);
      int currentMs = (current.createTime ?? 0);
      int nextMs = (next.createTime ?? 0);
      final curDate = DateUtil.formatDateMs(currentMs, format: 'yyyy-MM-dd');
      final nextDate = DateUtil.formatDateMs(nextMs, format: 'yyyy-MM-dd');
      return curDate != nextDate;
    }
    return false;
  }

  void viewDetail(WorkMoments info) async {
    final isDel = await WNavigator.startWorkMomentsDetail(
      workMomentID: info.workMomentID!,
    );
    if (isDel == true) {
      workMoments.remove(info);
    }
  }
}
