import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

Future<void> setAccountLoginInfo(
    {required String userID,
    // required String server,
    // required String tls,
    String? email,
    String? areaCode,
    String? phoneNumber,
    // required UserLoginType loginType,
    required String password,
    String? faceURL,
    String? nickname,
    required String imToken,
    required String chatToken}) async {
  final server = Config.serverIp;
  final tls = Config.serverIpIsIP ? "0" : "1";
  final loginType =
      (null != email && email.isNotEmpty) ? "emailWithPwd" : "phoneWithPwd";
  final loginInfoKey = getLoginInfoKey(server: server, userID: userID);
  final serverKey = getServerKey(server: server);
  await DataSp.putAccountLoginInfoMap({
    loginInfoKey: AccountLoginInfo.fromJson({
      "id": loginInfoKey,
      "userID": userID,
      "server": server,
      "tls": tls,
      "email": email,
      "areaCode": areaCode,
      "phoneNumber": phoneNumber,
      "loginType": loginType,
      "password": password,
      "faceURL": faceURL,
      "nickname": nickname,
      "imToken": imToken,
      "chatToken": chatToken,
    })
  });
  await DataSp.putCurAccountLoginInfoKey(loginInfoKey);
  await DataSp.putCurServerKey(serverKey);
}

String getTlsKey({required String server}) {
  return Config.targetIsIP(server) ? "0" : "1";
}

String getServerKey({required String server}) {
  final tlsKey = getTlsKey(server: server);
  return "${server}__${tlsKey}";
}

String getLoginInfoKey({required String server, required String userID}) {
  final serverKey = getServerKey(server: server);
  return "${userID}__${serverKey}";
}
