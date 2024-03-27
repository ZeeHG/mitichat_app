import 'dart:async';

import 'package:get/get.dart';
import 'package:miti/core/ctrl/app_ctrl.dart';
import 'package:miti/core/ctrl/im_ctrl.dart';
import 'package:miti/core/ctrl/push_ctrl.dart';
import 'package:miti/core/im_callback.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';

/*
  切换
    // 0. 暂停掉线监听(页面初始化或者执行函数时)(已退出登录不需要)
    1. 退出登录
    2. 注销sdk
    3. 修改服务器
    4. 重新初始化sdk
    5. 登录新服务器账号, chat, im
    6. 失败使用密码重新登录, 退出chat, im
    7. 恢复踢出监听(修改返回按钮回到home, 刷新当前页面如果有特殊数据, 重置页面历史回到home, 重新监听)
*/
class AccountUtil extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
  final pushCtrl = Get.find<PushCtrl>();
  final appCtrl = Get.find<AppCtrl>();
  final statusChangeCount = 0.obs;
  final imTimeout = 30;

  checkServerWithProtocolValid(String serverWithProtocol) {
    return serverWithProtocol.isNotEmpty &&
        Config.targetIsDomainOrIPWithProtocol(serverWithProtocol);
  }

  Future<bool> checkServerValid({required String serverWithProtocol}) async {
    if (!checkServerWithProtocolValid(serverWithProtocol)) return false;
    return await Apis.checkServerValid(serverWithProtocol: serverWithProtocol);
  }

  Future<void> delAccount(String loginInfoId,
      {bool finishLogout = false}) async {
    myLogger.i({
      "message": "删除账户",
      "data": {"loginInfoId": loginInfoId, "finishLogout": finishLogout}
    });
    await DataSp.removeAccountLoginInfoByKey(loginInfoId);
    if (finishLogout) {
      await tryLogout();
      AppNavigator.startLogin();
    }
  }

  Future<void> tryLogout({bool needLogoutIm = true}) async {
    try {
      if (DataSp.getCurAccountLoginInfoKey().isNotEmpty) {
        if (needLogoutIm && imCtrl.isLogined()) {
          myLogger.e({"message": "tryLogout开始"});
          await imCtrl.logout();
          imCtrl.reBuildSubject();
        }
        await DataSp.removeLoginCertificate();
        // Get.find<CacheController>().resetCache();
        // OpenIM.iMManager.userID
        pushCtrl.logout();
      }
    } catch (e, s) {
      myLogger.e({"message": "tryLogout失败", "error": e, "stack": s});
    }
  }

  Future<void> setServerConf(String serverWithProtocol) async {
    if (!checkServerWithProtocolValid(serverWithProtocol)) return;
    final uri = Uri.parse(serverWithProtocol);
    final tls = uri.scheme == "https";
    await DataSp.putServerConfig({
      'serverIP': uri.host,
      'authUrl': Config.targetIsIPWithProtocol(serverWithProtocol)
          ? "$serverWithProtocol:10008"
          : "${serverWithProtocol}/chat",
      'apiUrl': Config.targetIsIPWithProtocol(serverWithProtocol)
          ? "${serverWithProtocol}:10002"
          : "${serverWithProtocol}/api",
      'wsUrl': Config.targetIsIPWithProtocol(serverWithProtocol)
          ? "${tls ? 'wss' : 'ws'}://${uri.host}:10001"
          : "${tls ? 'wss' : 'ws'}://${uri.host}/msg_gateway",
    });
    DataSp.putCurServerKey(serverWithProtocol);
  }

  Future<void> reloadServerConf([String? serverWithProtocol]) async {
    serverWithProtocol = serverWithProtocol ?? Config.hostWithProtocol;
    if (!checkServerWithProtocolValid(serverWithProtocol)) return;
    final curKey = DataSp.getCurServerKey();
    final needReload = curKey.isNotEmpty && serverWithProtocol != curKey ||
        curKey.isEmpty && serverWithProtocol != Config.hostWithProtocol;
    if (needReload) {
      myLogger.i({
        "message": "reloadServerConf 准备重新加载服务配置",
        "data": {"needReload": needReload, "server": serverWithProtocol}
      });
      // FIXME 一直没有返回
      // await imCtrl.disposeIMSdk();
      imCtrl.disposeIMSdk();
      await setServerConf(serverWithProtocol);
      HttpUtil.init();
      statusChangeCount.value++;
      // FIXME 需要等到连接成功或者失败回调, 而不是函数执行完。否则无法登录im，只能登录chat。
      // FIXME initOpenIM不会出现超时, 只有login im后才会出现
      await imCtrl.initIMSdk();
      await appCtrl.getClientConfig();
    }
  }

  Future<void> switchServer(String serverWithProtocol,
      {bool needLogoutIm = true, bool needLogout = true}) async {
    if (!checkServerWithProtocolValid(serverWithProtocol)) return;
    try {
      if (needLogout) {
        await tryLogout(needLogoutIm: needLogoutIm);
        statusChangeCount.value++;
      }
      await reloadServerConf(serverWithProtocol);
    } catch (e, s) {
      myLogger.e({
        "message": "switchServer失败",
        "error": {"server": serverWithProtocol, "error": e},
        "stack": s
      });
      rethrow;
    }
  }

  // 切换服务器后调用
  Future<void> login(
      {String? areaCode,
      String? phoneNumber,
      String? email,
      required String password,
      String? verificationCode,
      bool encryptPwdRequest = true}) async {
    late LoginCertificate data;
    final curServerKey = DataSp.getCurServerKey();
    try {
      data = await Apis.login(
        encryptPwdRequest: encryptPwdRequest,
        areaCode: areaCode,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
        verificationCode: verificationCode,
      );
    } catch (e, s) {
      myLogger.e({
        "message": "chat登录失败",
        "error": {"curServerKey": curServerKey, "error": e},
        "stack": s
      });
      rethrow;
    }
    // final account = {
    //   "areaCode": areaCode,
    //   "phoneNumber": phoneNumber,
    //   'email': email
    // };
    await DataSp.putLoginCertificate(data);
    try {
      await imCtrl.login(data.userID, data.imToken);
      // 超时没有结果或者不是success
      final completer = Completer();
      StreamSubscription? sub;
      sub = imCtrl.imSdkStatusSubject.listen((value) {
        // [IMSdkStatus.connectionSucceeded, IMSdkStatus.syncEnded].contains(value)
        if (![
          IMSdkStatus.connecting,
          IMSdkStatus.connectionFailed,
          IMSdkStatus.syncFailed
        ].contains(value)) {
          if (!completer.isCompleted) {
            completer.complete(true);
          }
          sub?.cancel();
        }
      });
      Future.delayed(Duration(seconds: imTimeout)).then((_) {
        if (!completer.isCompleted) {
          completer.complete(false);
        }
        sub?.cancel();
      });
      final imOK = await completer.future;
      if (!imOK) {
        myLogger
            .e({"message": "登录im超时, ${imCtrl.imSdkStatusSubject.valueOrNull}"});
        throw Exception("登录im超时");
      }
    } catch (e, s) {
      showToast(StrLibrary.fail);
      myLogger.e({
        "message": "im登录失败",
        "error": {"curServerKey": curServerKey, "error": e},
        "stack": s
      });
      rethrow;
    }
    Get.find<CacheController>().resetCache();
    await setAccountLoginInfo(
        serverWithProtocol: curServerKey,
        userID: data.userID,
        imToken: data.imToken,
        chatToken: data.chatToken,
        email: email,
        phoneNumber: phoneNumber,
        areaCode: areaCode,
        password: encryptPwdRequest
            ? MitiUtils.generateMD5(password ?? "")!
            : password,
        faceURL: imCtrl.userInfo.value.faceURL,
        nickname: imCtrl.userInfo.value.nickname);
    final translateLogic = Get.find<TranslateLogic>();
    final ttsLogic = Get.find<TtsLogic>();
    translateLogic.init(data.userID);
    ttsLogic.init(data.userID);
    pushCtrl.login(data.userID);
  }

  // 切换服务器后调用
  Future<void> register(
      {bool switchBack = true,
      required String nickname,
      String? areaCode,
      String? phoneNumber,
      String? email,
      required password,
      required String verificationCode,
      String? invitationCode}) async {
    late LoginCertificate data;
    final curServerKey = DataSp.getCurServerKey();
    try {
      data = await Apis.register(
          nickname: nickname,
          areaCode: areaCode,
          phoneNumber: phoneNumber,
          email: email,
          password: password,
          verificationCode: verificationCode,
          invitationCode: invitationCode);
    } catch (e, s) {
      myLogger.e({
        "message": "chat注册失败",
        "error": {"curServerKey": curServerKey, "error": e},
        "stack": s
      });
      rethrow;
    }
    // final account = {
    //   "areaCode": areaCode,
    //   "phoneNumber": phoneNumber,
    //   'email': email
    // };
    await DataSp.putLoginCertificate(data);
    try {
      await imCtrl.login(data.userID, data.imToken);
      // imTimeout没有结果或者不是success
      final completer = Completer();
      StreamSubscription? sub;
      sub = imCtrl.imSdkStatusSubject.listen((value) {
        // [IMSdkStatus.connectionSucceeded, IMSdkStatus.syncEnded].contains(value)
        if (![
          IMSdkStatus.connecting,
          IMSdkStatus.connectionFailed,
          IMSdkStatus.syncFailed
        ].contains(value)) {
          if (!completer.isCompleted) {
            completer.complete(true);
          }
          sub?.cancel();
        }
      });
      Future.delayed(Duration(seconds: imTimeout)).then((_) {
        if (!completer.isCompleted) {
          completer.complete(false);
        }
        sub?.cancel();
      });
      final imOK = await completer.future;
      if (!imOK) {
        myLogger
            .e({"message": "登录im超时, ${imCtrl.imSdkStatusSubject.valueOrNull}"});
        throw Exception("登录im超时");
      }
    } catch (e, s) {
      showToast(StrLibrary.fail);
      myLogger.e({
        "message": "im登录失败",
        "error": {"curServerKey": curServerKey, "error": e},
        "stack": s
      });
      rethrow;
    }
    Get.find<CacheController>().resetCache();
    await setAccountLoginInfo(
        serverWithProtocol: curServerKey,
        userID: data.userID,
        imToken: data.imToken,
        chatToken: data.chatToken,
        email: email,
        phoneNumber: phoneNumber,
        areaCode: areaCode,
        password: MitiUtils.generateMD5(password ?? "")!,
        faceURL: imCtrl.userInfo.value.faceURL,
        nickname: imCtrl.userInfo.value.nickname);
    final translateLogic = Get.find<TranslateLogic>();
    final ttsLogic = Get.find<TtsLogic>();
    translateLogic.init(data.userID);
    ttsLogic.init(data.userID);
    pushCtrl.login(data.userID);
  }

  Future<bool> switchAccount(
      {required String serverWithProtocol,
      required String userID,
      bool switchBack = true,
      bool useToken = false}) async {
    if (!checkServerWithProtocolValid(serverWithProtocol)) return false;
    final targetLoginInfoKey =
        getLoginInfoKey(serverWithProtocol: serverWithProtocol, userID: userID);
    final curLoginInfoKey = DataSp.getCurAccountLoginInfoKey();
    AccountLoginInfo? targetAccountLoginInfo =
        DataSp.getAccountLoginInfoByKey(targetLoginInfoKey);
    AccountLoginInfo? curAccountLoginInfo = curLoginInfoKey.isNotEmpty
        ? DataSp.getAccountLoginInfoByKey(curLoginInfoKey)
        : null;
    if (null == targetAccountLoginInfo || null == curAccountLoginInfo) {
      return false;
    }
    try {
      if (!useToken) {
        await switchServer(targetAccountLoginInfo.server);
        // 用密码登录
        await login(
            areaCode: targetAccountLoginInfo.areaCode,
            phoneNumber: targetAccountLoginInfo.phoneNumber,
            email: targetAccountLoginInfo.email,
            password: targetAccountLoginInfo.password,
            encryptPwdRequest: false);
      } else {
        pushCtrl.logout();
        await switchServer(targetAccountLoginInfo.server, needLogout: false);
        // 用token登录
        await DataSp.putLoginCertificate(LoginCertificate.fromJson({
          "userID": userID,
          "imToken": targetAccountLoginInfo.imToken,
          "chatToken": targetAccountLoginInfo.chatToken
        }));
        // FIXME im没有退出, 直接用token登录, 导致OpenIM.iMManager.xx还是旧的用户, 出现bug
        await imCtrl.login(userID, targetAccountLoginInfo.imToken);
        await DataSp.putCurAccountLoginInfoKey(targetAccountLoginInfo.id);
        await DataSp.putCurServerKey(serverWithProtocol);
        final translateLogic = Get.find<TranslateLogic>();
        final ttsLogic = Get.find<TtsLogic>();
        translateLogic.init(userID);
        ttsLogic.init(userID);
        pushCtrl.login(userID);
      }
      showToast(StrLibrary.switchSuccess);
      return true;
    } catch (e, s) {
      myLogger.e({
        "message": "多服务器切换账号时登录账号失败, 尝试回退($switchBack)",
        "error": {
          "targetAccount":
              targetAccountLoginInfo.toJson(delSensitiveFields: true),
          "originAccount": curAccountLoginInfo.toJson(delSensitiveFields: true),
          "server": serverWithProtocol,
          "userID": userID,
          "error": e
        },
        "stack": s
      });
      if (switchBack) {
        // 回退服务器和账号
        try {
          await switchServer(curAccountLoginInfo.server, needLogoutIm: true);
          await login(
              areaCode: curAccountLoginInfo.areaCode,
              phoneNumber: curAccountLoginInfo.phoneNumber,
              email: curAccountLoginInfo.email,
              password: curAccountLoginInfo.password,
              encryptPwdRequest: false);
        } catch (e, s) {
          myLogger.e({
            "message": "回退账号失败",
            "error": {
              "targetAccount":
                  targetAccountLoginInfo.toJson(delSensitiveFields: true),
              "originAccount":
                  curAccountLoginInfo.toJson(delSensitiveFields: true),
              "server": serverWithProtocol,
              "userID": userID,
              "error": e
            },
            "stack": s
          });
        }
        showToast(StrLibrary.fail);
        return false;
      }
      return false;
    }
  }

  // 缺少chat的登出接口, 如果chat成功但im登录失败, 直接访问会有bug, 需要登出chat再switch, 不登出可能有bug
  Future<bool> loginAccount(
      {required String serverWithProtocol,
      bool switchBack = true,
      String? areaCode,
      String? phoneNumber,
      String? email,
      required password,
      String? verificationCode}) async {
    if (!checkServerWithProtocolValid(serverWithProtocol)) return false;
    try {
      // 重复账号重新登录覆盖, 失败了返回页面时再switchAccount
      await switchServer(serverWithProtocol);
      await login(
          areaCode: areaCode,
          phoneNumber: phoneNumber,
          email: email,
          password: password);
      showToast(StrLibrary.loginSuccess);
      return true;
    } catch (e, s) {
      myLogger.e({
        "message": "多服务器登录账号失败, 尝试回退($switchBack)",
        "error": {
          "argument": {
            "server": serverWithProtocol,
            "areaCode": areaCode,
            "phoneNumber": phoneNumber,
            "email": email,
            // "password": password
          },
          "error": e
        },
        "stack": s
      });
      if (switchBack) {
        await backCurAccount();
      }
      return false;
    }
  }

  Future<bool> registerAccount(
      {required String serverWithProtocol,
      bool switchBack = true,
      required String nickname,
      String? areaCode,
      String? phoneNumber,
      String? email,
      required password,
      required String verificationCode,
      String? invitationCode}) async {
    if (!checkServerWithProtocolValid(serverWithProtocol)) return false;
    try {
      await switchServer(serverWithProtocol);
      await register(
          areaCode: areaCode,
          phoneNumber: phoneNumber,
          email: email,
          password: password,
          nickname: nickname,
          verificationCode: verificationCode,
          invitationCode: invitationCode);
      showToast(StrLibrary.registerSuccess);
      return true;
    } catch (e, s) {
      myLogger.e({
        "message": "多服务器注册账号失败, 尝试回退($switchBack)",
        "error": {
          "argument": {
            "server": serverWithProtocol,
            "areaCode": areaCode,
            "phoneNumber": phoneNumber,
            "email": email,
            // "password": password,
            "nickname": nickname,
            "verificationCode": verificationCode,
            "invitationCode": invitationCode
          },
          "error": e
        },
        "stack": s
      });
      if (switchBack) {
        await backCurAccount();
      }
      return false;
    }
  }

  Future<bool> backCurAccount() async {
    final curLoginInfoKey = DataSp.getCurAccountLoginInfoKey();
    AccountLoginInfo? curAccountLoginInfo = curLoginInfoKey.isNotEmpty
        ? DataSp.getAccountLoginInfoByKey(curLoginInfoKey)
        : null;
    if (null != curAccountLoginInfo) {
      // 回退服务器和账号
      myLogger.w({
        "message": "回退账号",
        "data": {
          "curAccountLoginInfo":
              curAccountLoginInfo.toJson(delSensitiveFields: true),
        },
      });
      try {
        await switchServer(curAccountLoginInfo.server, needLogoutIm: true);
        await login(
            areaCode: curAccountLoginInfo.areaCode,
            phoneNumber: curAccountLoginInfo.phoneNumber,
            email: curAccountLoginInfo.email,
            password: curAccountLoginInfo.password,
            encryptPwdRequest: false);
      } catch (e, s) {
        myLogger.e({
          "message": "回退账号失败",
          "error": {
            "curAccountLoginInfo":
                curAccountLoginInfo.toJson(delSensitiveFields: true),
            "error": e
          },
          "stack": s
        });
        showToast(StrLibrary.accountErr);
        return false;
      }
      return true;
    }
    return true;
  }

  Future<void> backMain(int originStatusChangeCount) async {
    if (statusChangeCount.value > originStatusChangeCount) {
      LoadingView.singleton.start(
          topBarHeight: 0,
          fn: () async {
            await backCurAccount();
            AppNavigator.startMain();
          });
    } else {
      Get.back();
    }
  }
}
