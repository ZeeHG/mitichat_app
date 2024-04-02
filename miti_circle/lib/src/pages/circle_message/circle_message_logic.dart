import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:miti_circle/miti_circle.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CircleMessageLogic extends GetxController {
  final refreshCtrl = RefreshController();
  final list = <WorkMoments>[].obs;
  int pageNo = 1;
  int pageSize = 20;

  @override
  void onInit() {
    refreshNewMessage();
    super.onInit();
  }

  Future<List<WorkMoments>> _request(int pageNo) =>
      CircleApis.getInteractiveLogs(
        pageNumber: pageNo,
        showNumber: pageSize,
      );

  /// 工作圈消息类型    0为普通评论 1为被喜欢 2为AT提醒看的朋友圈
  /// notificationMsgType
  refreshNewMessage() async {
    var list = await _request(pageNo = 1);
    this.list.assignAll(list);
    refreshCtrl.refreshCompleted();
    list.length < pageSize
        ? refreshCtrl.loadNoData()
        : refreshCtrl.loadComplete();
  }

  void loadNewMessage() async {
    var list = await _request(++pageNo);
    this.list.addAll(list);
    list.length < pageSize
        ? refreshCtrl.loadNoData()
        : refreshCtrl.loadComplete();
  }

  void clearNewMessage() async {
    await LoadingView.singleton.start(
      fn: () async {
        CircleApis.clearUnreadCount(type: 3);
        list.clear();
      },
    );
  }

  void viewDetail(WorkMoments info) async {
    final isDel = await CircleNavigator.startMomentsDetail(
      workMomentID: info.workMomentID!,
    );
    if (isDel == true) {
      list.remove(info);
    }
  }
}
