import 'dart:async';

import 'package:get/get.dart';
import 'package:miti/core/controller/app_controller.dart';
import 'package:miti/core/controller/im_controller.dart';
import 'package:miti/core/controller/push_controller.dart';
import 'package:miti/core/im_callback.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';

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
class MiscUtil extends GetxController {
  final imLogic = Get.find<IMController>();
  final pushLogic = Get.find<PushController>();
  final appLogic = Get.find<AppController>();
  final switchCount = 0.obs;
  final imTimeout = 30;

  Future<void> tryLogout({bool needLogoutIm = true}) async {
    try {
      if (needLogoutIm && imLogic.isLogined()) {
        myLogger.e({"message": "tryLogout开始"});
        await imLogic.logout();
      }
    } catch (e, s) {
      myLogger.e({"message": "tryLogout失败", "error": e, "stack": s});
    }
    await DataSp.removeLoginCertificate();
    pushLogic.logout();
  }

  Future<void> setServerConf(String server) async {
    if (server.isEmpty || !Config.targetIsDomainOrIP(server)) return;
    await DataSp.putServerConfig({
      'serverIP': server,
      'authUrl': Config.targetIsIP(server)
          ? "http://${server}:10008"
          : "https://${server}/chat",
      'apiUrl': Config.targetIsIP(server)
          ? "http://${server}:10002"
          : "https://${server}/api",
      'wsUrl': Config.targetIsIP(server)
          ? "ws://${server}:10001"
          : "wss://${server}/msg_gateway",
    });
    DataSp.putCurServerKey(getServerKey(server: server));
  }

  Future<void> reloadServerConf([String server = Config.host]) async {
    if (!Config.targetIsDomainOrIP(server)) return;
    final key = getServerKey(server: server);
    final curKey = DataSp.getCurServerKey();
    final needReload = curKey.isNotEmpty && key != curKey ||
        curKey.isEmpty && key != getServerKey(server: Config.host);
    if (needReload) {
      myLogger.i({
        "message": "reloadServerConf 准备重新加载服务配置",
        "data": {"needReload": needReload, "server": server}
      });
      switchCount.value++;
      // FIXME 一直没有返回
      // await imLogic.unInitOpenIM();
      imLogic.unInitOpenIM();
      await setServerConf(server);
      HttpUtil.init();
      // FIXME 需要等到连接成功或者失败回调, 而不是函数执行完。否则无法登录im，只能登录chat。
      // FIXME initOpenIM不会出现超时, 只有login im后才会出现
      await imLogic.initOpenIM();
      await appLogic.queryClientConfig();
    }
  }

  Future<void> switchServer(String server,
      {bool needLogoutIm = true, bool needLogout = true}) async {
    if (server.isEmpty || !Config.targetIsDomainOrIP(server)) return;
    try {
      if (needLogout) {
        await tryLogout(needLogoutIm: needLogoutIm);
      }
      await reloadServerConf(server);
    } catch (e, s) {
      myLogger.e({
        "message": "switchServer失败",
        "error": {"server": server, "error": e},
        "stack": s
      });
      rethrow;
    }
  }

  Future<void> login(
      {String? areaCode,
      String? phoneNumber,
      String? email,
      required String password,
      String? verificationCode,
      bool encryptPwdRequest = true}) async {
    late LoginCertificate data;
    final curKey = DataSp.getCurServerKey();
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
        "error": {"curKey": curKey, "error": e},
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
      await imLogic.login(data.userID, data.imToken);
      // 超时没有结果或者不是success
      final completer = Completer();
      StreamSubscription? sub;
      sub = imLogic.imSdkStatusSubject.listen((value) {
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
        myLogger.e(
            {"message": "登录im超时, ${imLogic.imSdkStatusSubject.valueOrNull}"});
        throw Exception("登录im超时");
      }
    } catch (e, s) {
      showToast(StrRes.fail);
      myLogger.e({
        "message": "im登录失败",
        "error": {"curKey": curKey, "error": e},
        "stack": s
      });
      rethrow;
    }
    Get.find<CacheController>().resetCache();
    await setAccountLoginInfo(
        userID: data.userID,
        imToken: data.imToken,
        chatToken: data.chatToken,
        email: email,
        phoneNumber: phoneNumber,
        areaCode: areaCode,
        password:
            encryptPwdRequest ? IMUtils.generateMD5(password ?? "")! : password,
        faceURL: imLogic.userInfo.value.faceURL,
        nickname: imLogic.userInfo.value.nickname);
    final translateLogic = Get.find<TranslateLogic>();
    final ttsLogic = Get.find<TtsLogic>();
    translateLogic.init(data.userID);
    ttsLogic.init(data.userID);
    pushLogic.login(data.userID);
  }

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
    final curKey = DataSp.getCurServerKey();
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
        "error": {"curKey": curKey, "error": e},
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
      await imLogic.login(data.userID, data.imToken);
      // imTimeout没有结果或者不是success
      final completer = Completer();
      StreamSubscription? sub;
      sub = imLogic.imSdkStatusSubject.listen((value) {
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
        myLogger.e(
            {"message": "登录im超时, ${imLogic.imSdkStatusSubject.valueOrNull}"});
        throw Exception("登录im超时");
      }
    } catch (e, s) {
      showToast(StrRes.fail);
      myLogger.e({
        "message": "im登录失败",
        "error": {"curKey": curKey, "error": e},
        "stack": s
      });
      rethrow;
    }
    Get.find<CacheController>().resetCache();
    await setAccountLoginInfo(
        userID: data.userID,
        imToken: data.imToken,
        chatToken: data.chatToken,
        email: email,
        phoneNumber: phoneNumber,
        areaCode: areaCode,
        password: IMUtils.generateMD5(password ?? "")!,
        faceURL: imLogic.userInfo.value.faceURL,
        nickname: imLogic.userInfo.value.nickname);
    final translateLogic = Get.find<TranslateLogic>();
    final ttsLogic = Get.find<TtsLogic>();
    translateLogic.init(data.userID);
    ttsLogic.init(data.userID);
    pushLogic.login(data.userID);
  }

  Future<bool> switchAccount(
      {required String server,
      required String userID,
      bool switchBack = true,
      bool useToken = false}) async {
    final targetLoginInfoKey = getLoginInfoKey(server: server, userID: userID);
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
        await login(
            areaCode: targetAccountLoginInfo.areaCode,
            phoneNumber: targetAccountLoginInfo.phoneNumber,
            email: targetAccountLoginInfo.email,
            password: targetAccountLoginInfo.password,
            encryptPwdRequest: false);
      } else {
        pushLogic.logout();
        await switchServer(targetAccountLoginInfo.server, needLogout: false);
        await DataSp.putLoginCertificate(LoginCertificate.fromJson({
          "userID": userID,
          "imToken": targetAccountLoginInfo.imToken,
          "chatToken": targetAccountLoginInfo.chatToken
        }));
        // FIXME im没有退出, 直接用token登录, 导致OpenIM.iMManager.xx还是旧的用户, 出现bug
        await imLogic.login(userID, targetAccountLoginInfo.imToken);
        await DataSp.putCurAccountLoginInfoKey(targetAccountLoginInfo.id);
        await DataSp.putCurServerKey(
            getServerKey(server: targetAccountLoginInfo.server));
        final translateLogic = Get.find<TranslateLogic>();
        final ttsLogic = Get.find<TtsLogic>();
        translateLogic.init(userID);
        ttsLogic.init(userID);
        pushLogic.login(userID);
      }
      showToast(StrRes.success);
      return true;
    } catch (e, s) {
      myLogger.e({
        "message": "多服务器切换账号时登录账号失败, 尝试回退($switchBack)",
        "error": {
          "targetAccount": targetAccountLoginInfo.toJson(),
          "originAccount": curAccountLoginInfo.toJson(),
          "server": server,
          "userID": userID,
          "error": e
        },
        "stack": s
      });
      if (switchBack) {
        // 回退服务器和账号
        await switchServer(curAccountLoginInfo.server, needLogoutIm: true);
        await login(
            areaCode: curAccountLoginInfo.areaCode,
            phoneNumber: curAccountLoginInfo.phoneNumber,
            email: curAccountLoginInfo.email,
            password: curAccountLoginInfo.password,
            encryptPwdRequest: false);
        showToast(StrRes.fail);
        return false;
      }
      return false;
    }
  }

  // 缺少chat的登出接口, 如果chat成功但im登录失败, 直接访问会有bug, 需要登出chat再switch, 不出可能有bug
  Future<bool> loginAccount(
      {required String server,
      bool switchBack = true,
      String? areaCode,
      String? phoneNumber,
      String? email,
      required password,
      String? verificationCode}) async {
    try {
      // 重复账号重新登录覆盖, 失败了返回页面时再switchAccount
      await switchServer(server);
      await login(
          areaCode: areaCode,
          phoneNumber: phoneNumber,
          email: email,
          password: password);
      showToast(StrRes.success);
      return true;
    } catch (e, s) {
      myLogger.e({
        "message": "多服务器登录账号失败, 尝试回退($switchBack)",
        "error": {
          "argument": {
            "server": server,
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
      {required String server,
      bool switchBack = true,
      required String nickname,
      String? areaCode,
      String? phoneNumber,
      String? email,
      required password,
      required String verificationCode,
      String? invitationCode}) async {
    try {
      await switchServer(server);
      await register(
          areaCode: areaCode,
          phoneNumber: phoneNumber,
          email: email,
          password: password,
          nickname: nickname,
          verificationCode: verificationCode,
          invitationCode: invitationCode);
      showToast(StrRes.success);
      return true;
    } catch (e, s) {
      myLogger.e({
        "message": "多服务器注册账号失败, 尝试回退($switchBack)",
        "error": {
          "argument": {
            "server": server,
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
          "curAccountLoginInfo": curAccountLoginInfo.toJson(),
        },
      });
      await switchServer(curAccountLoginInfo.server, needLogoutIm: true);
      await login(
          areaCode: curAccountLoginInfo.areaCode,
          phoneNumber: curAccountLoginInfo.phoneNumber,
          email: curAccountLoginInfo.email,
          password: curAccountLoginInfo.password,
          encryptPwdRequest: false);
      showToast(StrRes.fail);
      return false;
    }
    return true;
  }

  Future<void> backMain(int originSwitchCount) async {
    if (switchCount.value > originSwitchCount) {
      LoadingView.singleton.wrap(
          navBarHeight: 0,
          asyncFunction: () async {
            await backCurAccount();
            AppNavigator.startMain();
          });
    } else {
      Get.back();
    }
  }
}
