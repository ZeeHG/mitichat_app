import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:miti_common/miti_common.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

enum RegisterType {
  google,
  apple,
  facebook,
}

extension RegisterTypeExtension on RegisterType {
  int toNumber() {
    switch (this) {
      case RegisterType.google:
        return 3;
      case RegisterType.apple:
        return 4;
      case RegisterType.facebook:
        return 5;
      default:
        return 3;
    }
  }
}

class ClientApis {
  static Options get imTokenOptions =>
      Options(headers: {'token': DataSp.imToken});

  static Options get chatTokenOptions =>
      Options(headers: {'token': DataSp.chatToken});

  /// login
  static Future<LoginCertificate> login(
      {String? areaCode,
      String? phoneNumber,
      String? email,
      String? password,
      String? verificationCode,
      bool encryptPwdRequest = true}) async {
    try {
      var data = await HttpUtil.post(ClientUrls.login, data: {
        "areaCode": areaCode,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': null != password
            ? (encryptPwdRequest ? MitiUtils.generateMD5(password) : password)
            : null,
        'platform': MitiUtils.getPlatform(),
        'verifyCode': verificationCode,
        // 'operationID': operationID,
      });
      return LoginCertificate.fromJson(data!);
    } catch (e, s) {
      myLogger.e({"error": e, "stack": s});
      return Future.error(e);
    }
  }

  /// register
  static Future<LoginCertificate> register(
      {required String nickname,
      required String password,
      String? faceURL,
      String? areaCode,
      String? phoneNumber,
      String? email,
      int birth = 0,
      int gender = 1,
      required String verificationCode,
      String? invitationCode,
      bool encryptPwdRequest = true}) async {
    assert(phoneNumber != null || email != null);
    try {
      var data = await HttpUtil.post(ClientUrls.register, data: {
        'deviceID': DataSp.getDeviceID(),
        'verifyCode': verificationCode,
        'platform': MitiUtils.getPlatform(),
        // 'operationID': operationID,
        'invitationCode': invitationCode,
        'autoLogin': true,
        'user': {
          "nickname": nickname,
          "faceURL": faceURL,
          'birth': birth,
          'gender': gender,
          'email': email,
          "areaCode": areaCode,
          'phoneNumber': phoneNumber,
          'password':
              encryptPwdRequest ? MitiUtils.generateMD5(password) : password,
        },
      });
      return LoginCertificate.fromJson(data!);
    } catch (e, s) {
      myLogger.e({"error": e, "stack": s});
      return Future.error(e);
    }
  }

  /// register
  static Future<LoginCertificate> registerOrLoginByOauth({
    required RegisterType registerType,
    String? idToken,
    String? accessToken,
  }) async {
    try {
      var data = await HttpUtil.post(ClientUrls.oauth, data: {
        'deviceID': DataSp.getDeviceID(),
        'platform': MitiUtils.getPlatform(),
        'clientId': registerType == RegisterType.google
            ? Config.googleClientId
            : registerType == RegisterType.apple
                ? Config.appleClientId
                : registerType == RegisterType.facebook
                    ? Config.facebookClientId
                    : "",
        'registerType': registerType.toNumber(),
        'idToken': idToken,
        'accessToken': accessToken
      });
      return LoginCertificate.fromJson(data!);
    } catch (e, s) {
      myLogger.e({"error": e, "stack": s});
      return Future.error(e);
    }
  }

  /// reset password
  static Future<dynamic> resetPassword({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String password,
    required String verificationCode,
  }) async {
    return HttpUtil.post(
      ClientUrls.resetPwd,
      data: {
        "areaCode": areaCode,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': MitiUtils.generateMD5(password),
        'verifyCode': verificationCode,
        'platform': MitiUtils.getPlatform(),
        // 'operationID': operationID,
      },
      options: chatTokenOptions,
    );
  }

  /// change password
  static Future<bool> changePassword({
    required String userID,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await HttpUtil.post(
        ClientUrls.changePwd,
        data: {
          "userID": userID,
          'currentPassword': MitiUtils.generateMD5(currentPassword),
          'newPassword': MitiUtils.generateMD5(newPassword),
          'platform': MitiUtils.getPlatform(),
          // 'operationID': operationID,
        },
        options: chatTokenOptions,
      );
      return true;
    } catch (e, s) {
      myLogger.e({"error": e, "stack": s});
      return false;
    }
  }

  /// update user info
  static Future<dynamic> updateUserInfo({
    required String userID,
    String? account,
    String? phoneNumber,
    String? areaCode,
    String? email,
    String? nickname,
    String? faceURL,
    int? gender,
    int? birth,
    int? level,
    int? allowAddFriend,
    int? allowBeep,
    int? allowVibration,
  }) async {
    Map<String, dynamic> param = {'userID': userID};
    void put(String key, dynamic value) {
      if (null != value) {
        param[key] = value;
      }
    }

    put('account', account);
    put('phoneNumber', phoneNumber);
    put('areaCode', areaCode);
    put('email', email);
    put('nickname', nickname);
    put('faceURL', faceURL);
    put('gender', gender);
    put('gender', gender);
    put('level', level);
    put('birth', birth);
    put('allowAddFriend', allowAddFriend);
    put('allowBeep', allowBeep);
    put('allowVibration', allowVibration);

    return HttpUtil.post(
      ClientUrls.updateUserInfo,
      data: {
        ...param,
        'platform': MitiUtils.getPlatform(),
        // 'operationID': operationID,
      },
      options: chatTokenOptions,
    );
  }

  static Future<List<FriendInfo>> searchFriendInfo(
    String keyword, {
    int pageNumber = 1,
    int showNumber = 10,
  }) async {
    final data = await HttpUtil.post(
      ClientUrls.searchFriendInfo,
      data: {
        'pagination': {'pageNumber': pageNumber, 'showNumber': showNumber},
        'keyword': keyword,
      },
      options: chatTokenOptions,
    );
    if (data['users'] is List) {
      return (data['users'] as List)
          .map((e) => FriendInfo.fromJson(e))
          .toList();
    }
    return [];
  }

  static Future<List<UserFullInfo>?> getUserFullInfo(
      {int pageNumber = 0,
      int showNumber = 10,
      required List<String> userIDList,
      CancelToken? cancelToken}) async {
    final data = await HttpUtil.post(ClientUrls.getUsersFullInfo,
        data: {
          'pagination': {'pageNumber': pageNumber, 'showNumber': showNumber},
          'userIDs': userIDList,
          'platform': MitiUtils.getPlatform(),
          // 'operationID': operationID,
        },
        options: chatTokenOptions,
        cancelToken: cancelToken);
    myLogger.i(data['users']);
    if (data['users'] is List) {
      return (data['users'] as List)
          .map((e) => UserFullInfo.fromJson(e))
          .toList();
    }
    return null;
  }

  static Future<List<UserFullInfo>?> searchUserFullInfo({
    required String content,
    int pageNumber = 1,
    int showNumber = 10,
  }) async {
    final data = await HttpUtil.post(
      ClientUrls.searchUserFullInfo,
      data: {
        'pagination': {'pageNumber': pageNumber, 'showNumber': showNumber},
        'keyword': content,
        // 'operationID': operationID,
      },
      options: chatTokenOptions,
    );
    if (data['users'] is List) {
      return (data['users'] as List)
          .map((e) => UserFullInfo.fromJson(e))
          .toList();
    }
    return null;
  }

  static Future<UserFullInfo?> queryMyFullInfo(
      {CancelToken? cancelToken}) async {
    final list = await ClientApis.getUserFullInfo(
        userIDList: [OpenIM.iMManager.userID], cancelToken: cancelToken);
    return list?.firstOrNull;
  }

  /// 获取验证码
  /// [usedFor] 1：注册，2：重置密码 3：登录
  static Future<bool> requestVerificationCode({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required int usedFor,
    String? invitationCode,
  }) async {
    return HttpUtil.post(
      ClientUrls.getVerificationCode,
      data: {
        "areaCode": areaCode,
        "phoneNumber": phoneNumber,
        "email": email,
        'usedFor': usedFor,
        'invitationCode': invitationCode
      },
    ).then((value) {
      showToast(StrLibrary.sentSuccessfully);
      return true;
    }).catchError((e, s) {
      myLogger.e({"error": e, "stack": s});
      return false;
    });
  }

  /// 校验验证码
  static Future<dynamic> checkVerificationCode({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String verificationCode,
    required int usedFor,
    String? invitationCode,
  }) {
    return HttpUtil.post(
      ClientUrls.checkVerificationCode,
      data: {
        "phoneNumber": phoneNumber,
        "areaCode": areaCode,
        "email": email,
        "verifyCode": verificationCode,
        "usedFor": usedFor,
        // 'operationID': operationID,
        'invitationCode': invitationCode
      },
    );
  }

  /// 蒲公英更新检测
  // static Future<UpgradeInfoV2> checkUpgradeV2({CancelToken? cancelToken}) {
  //   final url = dotenv.env['ANDROID_UPDATE_URL'] ?? "";
  //   final apiKey = dotenv.env['ANDROID_UPDATE_API_KEY'] ?? "";
  //   final appKey = dotenv.env['ANDROID_UPDATE_APP_KEY'] ?? "";
  //   return dio
  //       .post<Map<String, dynamic>>(url,
  //           options: Options(
  //             contentType: 'application/x-www-form-urlencoded',
  //           ),
  //           data: {
  //             '_api_key': apiKey,
  //             'appKey': appKey,
  //           },
  //           cancelToken: cancelToken)
  //       .then((resp) {
  //     Map<String, dynamic> map = resp.data!;
  //     if (map['code'] == 0) {
  //       return UpgradeInfoV2.fromJson(map['data']);
  //     }
  //     return Future.error(map);
  //   });
  // }

  static void queryUserOnlineStatus({
    required List<String> uidList,
    Function(Map<String, String>)? onlineStatusDescCallback,
    Function(Map<String, bool>)? onlineStatusCallback,
  }) async {
    var resp = await HttpUtil.post(
      ClientUrls.userOnlineStatus,
      data: <String, dynamic>{"userIDList": uidList},
      options: imTokenOptions,
    );
    Map<String, dynamic> map = resp.data!;
    if (map['errCode'] == 0 && map['data'] is List) {
      _handleStatus(
        (map['data'] as List).map((e) => OnlineStatus.fromJson(e)).toList(),
        onlineStatusCallback: onlineStatusCallback,
        onlineStatusDescCallback: onlineStatusDescCallback,
      );
    }
  }

  /// discoverPageURL
  /// ordinaryUserAddFriend,
  /// bossUserID,
  /// adminURL ,
  /// allowSendMsgNotFriend
  /// needInvitationCodeRegister
  /// robots
  static Future<Map<String, dynamic>> getClientConfig() async {
    var result = await HttpUtil.post(
      ClientUrls.getClientConfig,
      data: {
        // 'operationID': operationID,
      },
      options: chatTokenOptions,
      showErrorToast: false,
    );
    return result['config'] ?? {};
  }

  static _handleStatus(
    List<OnlineStatus> list, {
    Function(Map<String, String>)? onlineStatusDescCallback,
    Function(Map<String, bool>)? onlineStatusCallback,
  }) {
    final statusDesc = <String, String>{};
    final status = <String, bool>{};
    for (var e in list) {
      if (e.status == 'online') {
        // IOSPlatformStr     = "IOS"
        // AndroidPlatformStr = "Android"
        // WindowsPlatformStr = "Windows"
        // OSXPlatformStr     = "OSX"
        // WebPlatformStr     = "Web"
        // MiniWebPlatformStr = "MiniWeb"
        // LinuxPlatformStr   = "Linux"
        final pList = <String>[];
        for (var platform in e.detailPlatformStatus!) {
          if (platform.platform == "Android" || platform.platform == "IOS") {
            pList.add(StrLibrary.phoneOnline);
          } else if (platform.platform == "Windows") {
            pList.add(StrLibrary.pcOnline);
          } else if (platform.platform == "Web") {
            pList.add(StrLibrary.webOnline);
          } else if (platform.platform == "MiniWeb") {
            pList.add(StrLibrary.webMiniOnline);
          } else {
            statusDesc[e.userID!] = StrLibrary.online;
          }
        }
        statusDesc[e.userID!] = '${pList.join('/')}${StrLibrary.online}';
        status[e.userID!] = true;
      } else {
        statusDesc[e.userID!] = StrLibrary.offline;
        status[e.userID!] = false;
      }
    }
    onlineStatusDescCallback?.call(statusDesc);
    onlineStatusCallback?.call(status);
  }

  // static Future<List<UniMPInfo>> queryUniMPList() async {
  //   var result = await HttpUtil.post(
  //     ClientUrls.uniMPUrl,
  //     data: {
  //       // 'operationID': operationID,
  //     },
  //     options: chatTokenOptions,
  //     showErrorToast: false,
  //   );
  //   return (result as List).map((e) => UniMPInfo.fromJson(e)).toList();
  // }

  /// 查询tag组
  // static Future<TagGroup> getUserTags({String? userID}) => HttpUtil.post(
  //       ClientUrls.getUserTags,
  //       data: {'userID': userID},
  //       options: chatTokenOptions,
  //     ).then((value) => TagGroup.fromJson(value));

  /// 创建tag
  static createTag({
    required String tagName,
    required List<String> userIDList,
  }) =>
      HttpUtil.post(
        ClientUrls.createTag,
        data: {'tagName': tagName, 'userIDs': userIDList},
        options: chatTokenOptions,
      );

  /// 创建tag
  static deleteTag({required String tagID}) => HttpUtil.post(
        ClientUrls.deleteTag,
        data: {'tagID': tagID},
        options: chatTokenOptions,
      );

  /// 创建tag
  static updateTag({
    required String tagID,
    required String name,
    required List<String> increaseUserIDList,
    required List<String> reduceUserIDList,
  }) =>
      HttpUtil.post(
        ClientUrls.updateTag,
        data: {
          'tagID': tagID,
          'name': name,
          'addUserIDs': increaseUserIDList,
          'delUserIDs': reduceUserIDList,
        },
        options: chatTokenOptions,
      );

  /// 下发tag通知
  static sendTagNotification({
    // required int contentType,
    TextElem? textElem,
    SoundElem? soundElem,
    PictureElem? pictureElem,
    VideoElem? videoElem,
    FileElem? fileElem,
    CardElem? cardElem,
    LocationElem? locationElem,
    List<String> tagIDList = const [],
    List<String> userIDList = const [],
    List<String> groupIDList = const [],
  }) async {
    return HttpUtil.post(
      ClientUrls.sendTagNotification,
      data: {
        'tagIDs': tagIDList,
        'userIDs': userIDList,
        'groupIDs': groupIDList,
        'senderPlatformID': MitiUtils.getPlatform(),
        'content': json.encode({
          'data': json.encode({
            "customType": CustomMessageType.tag,
            "data": {
              // 'contentType': contentType,
              'pictureElem': pictureElem?.toJson(),
              'videoElem': videoElem?.toJson(),
              'fileElem': fileElem?.toJson(),
              'cardElem': cardElem?.toJson(),
              'locationElem': locationElem?.toJson(),
              'soundElem': soundElem?.toJson(),
              'textElem': textElem?.toJson(),
            },
          }),
          'extension': '',
          'description': '',
        }),
      },
      options: chatTokenOptions,
    );
  }

  /// 获取tag通知列表
  // static Future<List<TagNotification>> getTagNotificationLog({
  //   String? userID,
  //   required int pageNumber,
  //   required int showNumber,
  // }) async {
  //   final result = await HttpUtil.post(
  //     ClientUrls.getTagNotificationLog,
  //     data: {
  //       'userID': userID,
  //       'pagination': {'pageNumber': pageNumber, 'showNumber': showNumber},
  //     },
  //     options: chatTokenOptions,
  //   );
  //   final list = result['tagSendLogs'];
  //   if (list is List) {
  //     return list.map((e) => TagNotification.fromJson(e)).toList();
  //   }
  //   return [];
  // }

  static delTagNotificationLog({
    required List<String> ids,
  }) =>
      HttpUtil.post(
        ClientUrls.delTagNotificationLog,
        data: <String, dynamic>{'ids': ids},
        options: chatTokenOptions,
      );

  /// 翻译
  static Future<dynamic> translate(
      {required String userID,
      required String ClientMsgID,
      required String Query,
      String? TargetLang}) async {
    TargetLang =
        TargetLang ?? WidgetsBinding.instance.platformDispatcher.toString();
    Map<String, dynamic> param = {
      'userID': userID,
      'ClientMsgID': ClientMsgID,
      'Query': Query,
      'TargetLang': TargetLang
    };

    return HttpUtil.post(
      ClientUrls.translate,
      data: {
        ...param,
        'platform': MitiUtils.getPlatform(),
        'operationID': HttpUtil.operationID,
      },
      options: chatTokenOptions,
    );
  }

  /// 翻译查找
  static Future<dynamic> findTranslate(
      {required List<String> ClientMsgIDs, String? TargetLang}) async {
    TargetLang = TargetLang ??
        WidgetsBinding.instance.platformDispatcher.locale.toString();
    Map<String, dynamic> param = {
      'ClientMsgIDs': ClientMsgIDs,
      'TargetLang': TargetLang
    };

    return HttpUtil.post(
      ClientUrls.findTranslate,
      data: {
        ...param,
        'platform': MitiUtils.getPlatform(),
        'operationID': HttpUtil.operationID,
      },
      options: chatTokenOptions,
    );
  }

  /// 翻译配置
  static Future<dynamic> getConversationConfig(
      {required List<String> conversationIDs, String? ownerUserID}) async {
    ownerUserID = ownerUserID ?? OpenIM.iMManager.userID;

    Map<String, dynamic> param = {
      'conversationIDs': conversationIDs,
      'ownerUserID': ownerUserID
    };

    return HttpUtil.post(
      ClientUrls.getTranslateConfig,
      data: {
        ...param,
        'platform': MitiUtils.getPlatform(),
        'operationID': HttpUtil.operationID,
      },
      options: chatTokenOptions,
    );
  }

  static Future<dynamic> setConversationConfig(
      {List<String>? userIDs,
      required Map<String, dynamic> conversation}) async {
    userIDs = userIDs ?? [OpenIM.iMManager.userID];

    Map<String, dynamic> param = {
      'userIDs': userIDs,
      'conversation': conversation
    };

    return HttpUtil.post(
      ClientUrls.setTranslateConfig,
      data: {
        ...param,
        'platform': MitiUtils.getPlatform(),
        'operationID': HttpUtil.operationID,
      },
      options: chatTokenOptions,
    );
  }

  static put(Map<String, dynamic> param, String key, dynamic value) {
    if (null != value) {
      param[key] = value;
    }
  }

  static Future<dynamic> updateEmail({
    required String password,
    required String verificationCode,
    String? email,
  }) async {
    assert(email != null);
    try {
      var data = await HttpUtil.post(
        ClientUrls.updateEmail,
        data: {
          'email': email,
          'verifyCode': verificationCode,
          'password': MitiUtils.generateMD5(password),
          'platform': MitiUtils.getPlatform(),
          'operationID': HttpUtil.operationID,
        },
        options: chatTokenOptions,
      );
      return data;
    } catch (e, s) {
      myLogger.e({"error": e, "stack": s});
      return Future.error(e);
    }
  }

  static Future<dynamic> updatePhone({
    required String password,
    required String verificationCode,
    String? areaCode,
    String? phoneNumber,
  }) async {
    assert(phoneNumber != null);
    try {
      var data = await HttpUtil.post(
        ClientUrls.updatePhone,
        data: {
          'phoneNumber': phoneNumber,
          'areaCode': areaCode,
          'verifyCode': verificationCode,
          'password': MitiUtils.generateMD5(password),
          'platform': MitiUtils.getPlatform(),
          'operationID': HttpUtil.operationID,
        },
        options: chatTokenOptions,
      );
      return data;
    } catch (e, s) {
      myLogger.e({"error": e, "stack": s});
      return Future.error(e);
    }
  }

  // tts
  static Future<dynamic> tts({required String url}) async {
    Map<String, dynamic> param = {
      'url': url,
    };

    return HttpUtil.post(
      ClientUrls.tts,
      data: {
        ...param,
        'platform': MitiUtils.getPlatform(),
        'operationID': HttpUtil.operationID,
      },
      options: chatTokenOptions,
    );
  }

  // 删除用户
  static Future<dynamic> deleteUser({required String password}) async {
    return HttpUtil.post(
      ClientUrls.deleteUser,
      data: {
        'password': MitiUtils.generateMD5(password),
        'platform': MitiUtils.getPlatform(),
        'operationID': HttpUtil.operationID,
      },
      options: chatTokenOptions,
    );
  }

  static Future<dynamic> complain({
    required String userID,
    required String type,
    required String content,
    List<AssetEntity>? assets,
  }) async {
    final images = [];
    var result = [];
    if (null != assets && assets.length > 0) {
      result = await Future.wait(assets.map((e) async {
        final file = await e.file;
        final suffix = MitiUtils.getSuffix(file!.path);
        return OpenIM.iMManager.uploadFile(
          id: const Uuid().v4(),
          filePath: file!.path,
          fileName: "${const Uuid().v4()}$suffix",
        );
      }));
    }
    if (result.length > 0) {
      for (int i = 0; i < result.length; i += 1) {
        images.add(jsonDecode(result[i])['url']);
      }
    }

    Map<String, dynamic> param = {
      'userID': userID,
      'type': type,
      'content': content,
      'images': images,
    };

    return HttpUtil.post(
      ClientUrls.complain,
      data: {
        ...param,
        'platform': MitiUtils.getPlatform(),
        'operationID': HttpUtil.operationID,
      },
      options: chatTokenOptions,
    );
  }

  static Future<dynamic> complainXhs({
    required String workMomentID,
    required List<String> reason,
    required String content,
    List<AssetEntity>? assets,
  }) async {
    final images = [];
    var result = [];
    if (null != assets && assets.length > 0) {
      result = await Future.wait(assets.map((e) async {
        final file = await e.file;
        final suffix = MitiUtils.getSuffix(file!.path);
        return OpenIM.iMManager.uploadFile(
          id: const Uuid().v4(),
          filePath: file!.path,
          fileName: "${const Uuid().v4()}$suffix",
        );
      }));
    }
    if (result.length > 0) {
      for (int i = 0; i < result.length; i += 1) {
        images.add(jsonDecode(result[i])['url']);
      }
    }

    Map<String, dynamic> param = {
      'workMomentID': workMomentID,
      'reason': reason,
      'content': content,
      'images': images,
    };

    return HttpUtil.post(
      ClientUrls.complainXhs,
      data: {
        ...param,
        'platform': MitiUtils.getPlatform(),
        'operationID': HttpUtil.operationID,
      },
      options: chatTokenOptions,
    );
  }

  static Future<dynamic> blockMoment(
      {required String userID, required int operation}) async {
    Map<String, dynamic> param = {'userID': userID, 'operation': operation};

    return HttpUtil.post(
      ClientUrls.blockMoment,
      data: {
        ...param,
        'platform': MitiUtils.getPlatform(),
        'operationID': HttpUtil.operationID,
      },
      options: chatTokenOptions,
    );
  }

  static Future<dynamic> getBlockMoment({required String userID}) async {
    Map<String, dynamic> param = {'userID': userID};

    return HttpUtil.post(
      ClientUrls.getBlockMoment,
      data: {
        ...param,
        'platform': MitiUtils.getPlatform(),
        'operationID': HttpUtil.operationID,
      },
      options: chatTokenOptions,
    );
  }

  static Future<bool> checkServerValid(
      {required String serverWithProtocol}) async {
    var result = await HttpUtil.post(
      "${serverWithProtocol}${Config.targetIsDomainWithProtocol(serverWithProtocol) ? '/chat' : ':10008'}${ClientUrls.checkServerValid}",
      data: {},
      showErrorToast: false,
    );
    return true;
  }

  static Future<dynamic> getBots() async {
    return HttpUtil.post(
      ClientUrls.getBots,
      options: chatTokenOptions,
    );
  }

  static Future<dynamic> getMyAi() async {
    return HttpUtil.post(
      ClientUrls.getMyAi,
      options: chatTokenOptions,
    );
  }

  static Future<dynamic> getKnowledgeFiles({
    String? knowledgebaseID,
    String? botID,
  }) async {
    Map<String, dynamic> param = null != knowledgebaseID
        ? {'knowledgebaseID': knowledgebaseID}
        : {'botID': botID};

    return HttpUtil.post(
      ClientUrls.getKnowledgeFiles,
      data: {
        ...param,
      },
      options: chatTokenOptions,
    );
  }

  static Future<dynamic> addKnowledge(
      {String? knowledgebaseID,
      String? botID,
      String? text,
      List<String>? filePathList}) async {
    FormData formData = FormData.fromMap({});
    if (null != knowledgebaseID) {
      formData.fields.add(MapEntry("knowledgebase_id", knowledgebaseID));
    }
    if (null != botID) {
      formData.fields.add(MapEntry("knowledgebase_id", botID));
    }
    if (null != text) {
      formData.fields.add(MapEntry("text", text));
    }
    if (null != filePathList) {
      final multipartFile = await Future.wait(filePathList
          .map((path) async => await MultipartFile.fromFile(path,
              filename: path.split('/').last))
          .toList());
      if (multipartFile.isNotEmpty) {
        formData.files
            .addAll(multipartFile.map((file) => MapEntry("files", file)));
      }
    }

    return HttpUtil.post(
      ClientUrls.addKnowledge,
      data: formData,
      options: chatTokenOptions,
    );
  }

  static Future<dynamic> getMyAiTask() async {
    return HttpUtil.post(
      ClientUrls.getMyAiTask,
      options: chatTokenOptions,
    );
  }

  static Future<dynamic> getBotKnowledgebases({required String botID}) async {
    return HttpUtil.post(
      data: {"botID": botID},
      ClientUrls.getBotKnowledgebases,
      options: chatTokenOptions,
    );
  }

  // 埋点
  static Future<dynamic> addActionRecord(
      {required List<ActionRecord> actionRecordList}) async {
    return HttpUtil.post(
      data: {
        "actionList": List.generate(actionRecordList.length,
            (index) => actionRecordList[index].toJson())
      },
      ClientUrls.addActionRecord,
      options: chatTokenOptions,
    );
  }

  static Future updateMitiID({
    required String mitiID,
    required String userID,
  }) async {
    return HttpUtil.post(
      ClientUrls.updateMitiID,
      data: {"mitiID": mitiID, "userID": userID},
      options: chatTokenOptions,
    );
  }

  static Future queryUpdateMitiIDRecords({
    required String userID,
  }) async {
    return HttpUtil.post(
      ClientUrls.queryUpdateMitiIDRecords,
      data: {"userID": userID},
      options: chatTokenOptions,
    );
  }

  static Future applyActive(
      {required String userID, required String inviteMitiID}) async {
    return HttpUtil.post(
      ClientUrls.applyActive,
      data: {"userID": userID, "inviteMitiID": inviteMitiID},
      options: chatTokenOptions,
    );
  }

  static Future responseApplyActive(
      {required String invtedUserID,
      required String userID,
      required int result}) async {
    return HttpUtil.post(
      ClientUrls.responseApplyActive,
      data: {"userID": userID, "invtedUserID": invtedUserID, "result": result},
      options: chatTokenOptions,
    );
  }

  static Future directActive({
    required String userID,
    required String invteUserID,
  }) async {
    return HttpUtil.post(
      ClientUrls.directActive,
      data: {"userID": userID, "invteUserID": invteUserID},
      options: chatTokenOptions,
    );
  }

  static Future queryApplyActiveList(
      {required String userID, pageNumber = 1, showNumber = 999}) async {
    return HttpUtil.post(
      ClientUrls.queryApplyActiveList,
      data: {
        "userID": userID,
        'pagination': {'pageNumber': pageNumber, 'showNumber': showNumber}
      },
      options: chatTokenOptions,
    );
  }

  static Future querySelfApplyActive({
    required String userID,
  }) async {
    return HttpUtil.post(
      ClientUrls.querySelfApplyActive,
      data: {"userID": userID},
      options: chatTokenOptions,
    );
  }

  static Future queryInvitedUsers(
      {required String userID, pageNumber = 1, showNumber = 999}) async {
    return HttpUtil.post(
      ClientUrls.queryInvitedUsers,
      data: {
        "userID": userID,
        'pagination': {'pageNumber': pageNumber, 'showNumber': showNumber},
      },
      options: chatTokenOptions,
    );
  }

  static Future querySupportRegistTypes() async {
    return HttpUtil.post(
      ClientUrls.querySupportRegistTypes,
    );
  }
}
