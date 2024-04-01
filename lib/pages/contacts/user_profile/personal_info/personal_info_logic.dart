import 'package:collection/collection.dart';
import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:url_launcher/url_launcher.dart';

import '../user_profile_logic.dart';

class PersonalInfoLogic extends GetxController {
  final userProfilesLogic =
      Get.find<UserProfileLogic>(tag: GetTags.userProfile);
  late String userID;
  final userFullInfo = UserFullInfo().obs;

  @override
  void onInit() {
    super.onInit();
    userID = Get.arguments['userID'];
    _queryUserFullInfo();
  }

  void _queryUserFullInfo() async {
    await LoadingView.singleton.start(
      fn: () async {
        final list = await Apis.getUserFullInfo(userIDList: [userID]);
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
      },
    );
  }

  String? get nickname => MitiUtils.emptyStrToNull(
      userProfilesLogic.userInfo.value.nickname, userFullInfo.value.nickname);

  String? get faceURL => MitiUtils.emptyStrToNull(
      userProfilesLogic.userInfo.value.faceURL, userFullInfo.value.faceURL);

  bool get isMale =>
      (userProfilesLogic.userInfo.value.gender ?? userFullInfo.value.gender) ==
      1;

  // String? get englishName =>
  //     MitiUtils.emptyStrToNull(userFullInfo.value.englishName) ?? '-';

  int? get _birth =>
      userProfilesLogic.userInfo.value.birth ?? userFullInfo.value.birth;

  String? get birth => _birth == null
      ? '-'
      : DateUtil.formatDateMs(_birth!, format: MitiUtils.getTimeFormat1());

  String? get telephone =>
      MitiUtils.emptyStrToNull(userFullInfo.value.telephone) ?? '-';

  String? get phoneNumber =>
      MitiUtils.emptyStrToNull(userProfilesLogic.userInfo.value.phoneNumber,
          userFullInfo.value.phoneNumber) ??
      '-';

  String? get email =>
      MitiUtils.emptyStrToNull(
          userProfilesLogic.userInfo.value.email, userFullInfo.value.email) ??
      '-';

  clickPhoneNumber() => _callSystemPhone(userFullInfo.value.phoneNumber);

  // clickTel() => _callSystemPhone(userFullInfo.value.telephone);

  // clickEmail() => _callSystemEmail(userFullInfo.value.email);

  _callSystemPhone(String? phone) async {
    final value = MitiUtils.emptyStrToNull(phone);
    if (null != value) {
      final uri = Uri.parse('tel:$value');
      try {
        launchUrl(uri);
      } catch (e, s) {
        myLogger.e({"error": e, "stack": s});
      }
    }
  }

  // _callSystemEmail(String? email) {
  //   final value = MitiUtils.emptyStrToNull(email);
  //   if (null != value) {
  //     final uri = Uri.parse('mailto:$value');
  //     try {
  //       launchUrl(uri);
  //     } catch (_) {}
  //   }
  // }
}
