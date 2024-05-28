import 'package:dio/dio.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import '../../../core/ctrl/im_ctrl.dart';

class MyProfileLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();

  @override
  void onReady() {
    queryMyFullIno();
    super.onReady();
  }

  void editMyName() => AppNavigator.startEditMyProfile();

  void openPhotoSheet() {
    IMViews.openPhotoSheet(
        onData: (path, url) async {
          if (url != null) {
            LoadingView.singleton.start(
              fn: () => ClientApis.updateUserInfo(
                      userID: OpenIM.iMManager.userID, faceURL: url)
                  .then((value) => imCtrl.userInfo.update((val) {
                        val?.faceURL = url;
                      })),
            );
          }
        },
        quality: 90);
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
        cancelStyle: StylesLibrary.ts_333333_16sp,
        doneStyle: StylesLibrary.ts_8443F8_16sp,
        itemStyle: StylesLibrary.ts_333333_16sp,
      ),
      onConfirm: (dateTime) {
        updateInfo("birth", dateTime.millisecondsSinceEpoch ~/ 1000 * 1000);
      },
    );
  }

  void mitiIDChangeEntry() {
    AppNavigator.startMitiIDChangeEntry();
  }

  void selectGender() {
    Get.bottomSheet(
      barrierColor: StylesLibrary.c_191919_opacity50,
      BottomSheetView(
        items: [
          SheetItem(
            label: StrLibrary.man,
            onTap: () => updateInfo("gender", 1),
          ),
          SheetItem(
            label: StrLibrary.woman,
            onTap: () => updateInfo("gender", 2),
          ),
        ],
      ),
    );
  }

  void updateInfo(String key, dynamic value) {
    LoadingView.singleton.start(fn: () async {
      final userID = OpenIM.iMManager.userID;
      switch (key) {
        case "birth":
          await ClientApis.updateUserInfo(
            userID: userID,
            birth: value,
          );
          imCtrl.userInfo.update((val) {
            val?.birth = value;
          });
          break;
        case "gender":
          await ClientApis.updateUserInfo(
            userID: userID,
            gender: value,
          );
          imCtrl.userInfo.update((val) {
            val?.gender = value;
          });
          break;
        default:
      }
    });
  }

  void queryMyFullIno() async {
    CancelToken cancelToken = CancelToken();
    final info = await LoadingView.singleton.start(
        fn: () => ClientApis.queryMyFullInfo(cancelToken: cancelToken),
        cancelToken: cancelToken);
    if (null != info) {
      imCtrl.userInfo.update((val) {
        val?.nickname = info.nickname;
        val?.faceURL = info.faceURL;
        val?.gender = info.gender;
        val?.phoneNumber = info.phoneNumber;
        val?.birth = info.birth;
        val?.email = info.email;
        val?.mitiID = info.mitiID;
      });
    }
  }
}
