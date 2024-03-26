import 'package:dio/dio.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/pages/mine/edit_my_profile/edit_my_profile_logic.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import '../../../core/ctrl/im_ctrl.dart';

class MyInfoLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();

  // final userInfo = UserFullInfo.fromJson(OpenIM.iMManager.uInfo.toJson()).obs;

  @override
  void onInit() {
    // imCtrl.selfInfoUpdatedSubject.listen(_onChangedSefInfo);
    super.onInit();
  }

  _onChangedSefInfo(UserInfo userInfo) {}

  void editMyName() => AppNavigator.startEditMyProfile();

  void openPhotoSheet() {
    IMViews.openPhotoSheet(
        onData: (path, url) async {
          if (url != null) {
            LoadingView.singleton.start(
              fn: () => Apis.updateUserInfo(
                      userID: OpenIM.iMManager.userID, faceURL: url)
                  .then((value) => imCtrl.userInfo.update((val) {
                        val?.faceURL = url;
                      })),
            );
          }
        },
        quality: 15);
  }

  void openDatePicker() {
    var appLocale = Get.locale;
    var isZh = appLocale!.languageCode.toLowerCase().contains("zh");
    DatePicker.showDatePicker(
      Get.context!,
      locale: isZh ? LocaleType.zh : LocaleType.en,
      maxTime: DateTime.now(),
      currentTime:
          DateTime.fromMillisecondsSinceEpoch(imCtrl.userInfo.value.birth ?? 0),
      theme: DatePickerTheme(
        cancelStyle: Styles.ts_333333_17sp,
        doneStyle: Styles.ts_8443F8_17sp,
        itemStyle: Styles.ts_333333_17sp,
      ),
      onConfirm: (dateTime) {
        _updateBirthday(dateTime.millisecondsSinceEpoch ~/ 1000);
      },
    );
  }

  void selectGender() {
    Get.bottomSheet(
      barrierColor: Styles.c_191919_opacity50,
      BottomSheetView(
        items: [
          SheetItem(
            label: StrLibrary.man,
            onTap: () => _updateGender(1),
          ),
          SheetItem(
            label: StrLibrary.woman,
            onTap: () => _updateGender(2),
          ),
        ],
      ),
    );
  }

  void _updateGender(int gender) {
    LoadingView.singleton.start(
      fn: () =>
          Apis.updateUserInfo(userID: OpenIM.iMManager.userID, gender: gender)
              .then((value) => imCtrl.userInfo.update((val) {
                    val?.gender = gender;
                  })),
    );
  }

  void _updateBirthday(int birthday) {
    LoadingView.singleton.start(
      fn: () => Apis.updateUserInfo(
        userID: OpenIM.iMManager.userID,
        birth: birthday * 1000,
      ).then((value) => imCtrl.userInfo.update((val) {
            val?.birth = birthday * 1000;
          })),
    );
  }

  @override
  void onReady() {
    _queryMyFullIno();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void _queryMyFullIno() async {
    CancelToken cancelToken = CancelToken();
    final info = await LoadingView.singleton.start(
        fn: () => Apis.queryMyFullInfo(cancelToken: cancelToken),
        cancelToken: cancelToken);
    if (null != info) {
      imCtrl.userInfo.update((val) {
        val?.nickname = info.nickname;
        val?.faceURL = info.faceURL;
        val?.gender = info.gender;
        val?.phoneNumber = info.phoneNumber;
        val?.birth = info.birth;
        val?.email = info.email;
      });
    }
  }

  static _trimNullStr(String? value) => MitiUtils.emptyStrToNull(value);
}
