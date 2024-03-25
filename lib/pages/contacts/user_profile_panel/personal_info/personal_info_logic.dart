import 'package:collection/collection.dart';
import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:url_launcher/url_launcher.dart';

import '../user_profile _panel_logic.dart';

class PersonalInfoLogic extends GetxController {
  final userProfilesLogic =
      Get.find<UserProfilePanelLogic>(tag: GetTags.userProfile);
  late String userID;
  final userFullInfo = UserFullInfo().obs;

  @override
  void onInit() {
    userID = Get.arguments['userID'];
    super.onInit();
  }

  @override
  void onReady() {
    _queryUserFullInfo();
    super.onReady();
  }

  void _queryUserFullInfo() async {
    final list = await LoadingView.singleton.start(
      fn: () => Apis.getUserFullInfo(userIDList: [userID]),
    );
    final info = list?.firstOrNull;
    if (null != info) {
      userFullInfo.update((val) {
        val?.nickname = info.nickname;
        val?.faceURL = info.faceURL;
        val?.gender = info.gender;
        val?.englishName = info.englishName;
        val?.birth = info.birth;
        val?.telephone = info.telephone;
        val?.phoneNumber = info.phoneNumber;
        val?.email = info.email;
      });
    }
  }

  String? get nickname =>
      MitiUtils.emptyStrToNull(userProfilesLogic.userInfo.value.nickname) ??
      MitiUtils.emptyStrToNull(userFullInfo.value.nickname);

  String? get faceURL =>
      MitiUtils.emptyStrToNull(userProfilesLogic.userInfo.value.faceURL) ??
      MitiUtils.emptyStrToNull(userFullInfo.value.faceURL);

  bool get isMale =>
      (userProfilesLogic.userInfo.value.gender ?? userFullInfo.value.gender) ==
      1;

  String? get englishName =>
      MitiUtils.emptyStrToNull(userFullInfo.value.englishName) ?? '-';

  int? get _birth =>
      userProfilesLogic.userInfo.value.birth ?? userFullInfo.value.birth;

  String? get birth => _birth == null
      ? '-'
      : DateUtil.formatDateMs(_birth!, format: MitiUtils.getTimeFormat1());

  String? get telephone =>
      MitiUtils.emptyStrToNull(userFullInfo.value.telephone) ?? '-';

  String? get phoneNumber =>
      MitiUtils.emptyStrToNull(userProfilesLogic.userInfo.value.phoneNumber) ??
      MitiUtils.emptyStrToNull(userFullInfo.value.phoneNumber) ??
      '-';

  String? get email =>
      MitiUtils.emptyStrToNull(userProfilesLogic.userInfo.value.email) ??
      MitiUtils.emptyStrToNull(userFullInfo.value.email) ??
      '-';

  clickPhoneNumber() => _callSystemPhone(userFullInfo.value.phoneNumber);

  clickTel() => _callSystemPhone(userFullInfo.value.telephone);

  clickEmail() => _callSystemEmail(userFullInfo.value.email);

  _callSystemPhone(String? phone) async {
    final value = MitiUtils.emptyStrToNull(phone);
    if (null != value) {
      final uri = Uri.parse('tel:$value');
      try {
        launchUrl(uri);
      } catch (_) {}
    }
  }

  _callSystemEmail(String? email) {
    final value = MitiUtils.emptyStrToNull(email);
    if (null != value) {
      final uri = Uri.parse('mailto:$value');
      try {
        launchUrl(uri);
      } catch (_) {}
    }
  }
}
