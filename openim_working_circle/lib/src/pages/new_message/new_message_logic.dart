import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:openim_working_circle/openim_working_circle.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sprintf/sprintf.dart';

import '../../w_apis.dart';

class NewMessageLogic extends GetxController {
  final refreshCtrl = RefreshController();
  final list = <WorkMoments>[].obs;
  int pageNo = 1;
  int pageSize = 20;

  @override
  void onReady() {
    refreshNewMessage();
    super.onReady();
  }

  Future<List<WorkMoments>> _request(int pageNo) => WApis.getInteractiveLogs(
        pageNumber: pageNo,
        showNumber: pageSize,
      );

  /// 工作圈消息类型    0为普通评论 1为被喜欢 2为AT提醒看的朋友圈
  /// notificationMsgType
  refreshNewMessage() async {
    var list = await _request(pageNo = 1);
    this.list.assignAll(list);
    refreshCtrl.refreshCompleted();
    if (list.length < pageSize) {
      refreshCtrl.loadNoData();
    } else {
      refreshCtrl.loadComplete();
    }
  }

  void loadNewMessage() async {
    var list = await _request(++pageNo);
    this.list.addAll(list);
    if (list.length < pageSize) {
      refreshCtrl.loadNoData();
    } else {
      refreshCtrl.loadComplete();
    }
  }

  void clearNewMessage() async {
    await LoadingView.singleton.wrap(
      asyncFunction: () => WApis.clearUnreadCount(type: 3),
    );
    list.clear();
  }

  void viewDetail(WorkMoments info) async {
    final isDel = await WNavigator.startWorkMomentsDetail(
      workMomentID: info.workMomentID!,
    );
    if (isDel == true) {
      list.remove(info);
    }
  }
}
