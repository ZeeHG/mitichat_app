import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:openim_meeting/openim_meeting.dart';

class BookMeetingLogic extends GetxController {
  final meetingSubjectCtrl = TextEditingController();
  final focusNode = FocusNode();
  final startTime = "".obs;
  final duration = "".obs;
  final durationList = [0.5, 1, 1.5, 2];
  final enabled = false.obs;
  int _duration = 0;
  int _startTime = 0;
  MeetingInfo? meetingInfo;
  late String format;
  late bool isZh;

  @override
  void onInit() {
    meetingInfo = Get.arguments['meetingInfo'];
    _initLocale();
    _initValue();
    meetingSubjectCtrl.addListener(changedButtonStatus);
    super.onInit();
  }

  _initLocale() {
    isZh = Get.locale!.languageCode.toLowerCase().contains("zh");
    format = isZh ? "MM月dd日 HH时mm分" : "MM/dd HH:mm";
  }

  _initValue() {
    if (null != meetingInfo) {
      meetingSubjectCtrl.text = meetingInfo!.meetingName!;
      _startTime = meetingInfo!.startTime!;
      _duration = meetingInfo!.endTime! - meetingInfo!.startTime!;
      startTime.value = DateUtil.formatDate(
        DateTime.fromMillisecondsSinceEpoch(_startTime * 1000),
        format: format,
      );
      duration.value = '${_duration / 3600} ${StrRes.hours}';
      focusNode.requestFocus();
    }
  }

  @override
  void onClose() {
    focusNode.dispose();
    meetingSubjectCtrl.dispose();
    super.onClose();
  }

  void changedButtonStatus() {
    enabled.value = meetingSubjectCtrl.text.trim().isNotEmpty && startTime.isNotEmpty && duration.isNotEmpty;
  }

  void selectMeetingStartTime() {
    DatePicker.showDateTimePicker(
      Get.context!,
      locale: isZh ? LocaleType.zh : LocaleType.en,
      minTime: DateTime.now(),
      theme: DatePickerTheme(
        cancelStyle: Styles.ts_0C1C33_17sp,
        doneStyle: Styles.ts_0089FF_17sp,
        itemStyle: Styles.ts_0C1C33_17sp,
      ),
      onConfirm: (dateTime) {
        final time = dateTime.millisecondsSinceEpoch ~/ 1000;
        _startTime = time;
        startTime.value = DateUtil.formatDate(dateTime, format: format);
        changedButtonStatus();
      },
    );
  }

  void selectMeetingDuration() {
    Get.bottomSheet(
      BottomSheetView(
        items: durationList
            .map((e) => SheetItem(
                  label: '$e ${StrRes.hours}',
                  onTap: () {
                    _duration = (e * 60 * 60).toInt();
                    duration.value = '$e ${StrRes.hours}';
                    changedButtonStatus();
                  },
                ))
            .toList(),
      ),
      isScrollControlled: true,
    );
  }

  void enterMeeting() async {
    await MeetingClient().create(
      Get.context!,
      meetingName: meetingSubjectCtrl.text,
      startTime: _startTime,
      duration: _duration,
    );
    if (Get.currentRoute == MRoutes.bookMeeting) {
      Get.back();
    }
  }

  bookMeeting() async {
    final sc = await LoadingView.singleton.wrap(
        asyncFunction: () => OpenIM.iMManager.signalingManager.signalingCreateMeeting(
              meetingName: meetingSubjectCtrl.text,
              startTime: _startTime,
              meetingDuration: _duration,
            ));
    MNavigator.startMeetingDetail(
      MeetingInfo()
        ..roomID = sc.roomID
        ..meetingName = meetingSubjectCtrl.text.toString().trim()
        ..startTime = _startTime
        ..endTime = (_startTime + _duration),
      OpenIM.iMManager.userInfo.nickname!,
      offAndToNamed: true,
    );
  }

  void modifyMeeting() async {
    meetingInfo!
      ..meetingName = meetingSubjectCtrl.text.toString().trim()
      ..startTime = _startTime
      ..endTime = (_startTime + _duration);

    try {
      await LoadingView.singleton.wrap(
          asyncFunction: () => OpenIM.iMManager.signalingManager.signalingUpdateMeetingInfo(
                info: meetingInfo!.toJson(),
              ));
      IMViews.showToast("修改成功！");
      Get.back();
    } catch (e, s) {
      Logger.print('error: $e,  stack: $s');
      if (e.toString().contains('NotExist')) {
        IMViews.showToast("会议已经结束！");
      } else {
        IMViews.showToast("网络异常请稍后再试！");
      }
    }
  }
}
