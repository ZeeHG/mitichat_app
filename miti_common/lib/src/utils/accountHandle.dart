import 'package:miti_common/miti_common.dart';

Future<void> setAccountLoginInfo(
    {required String userID,
    String? serverWithProtocol,
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
  serverWithProtocol = serverWithProtocol ??
      (DataSp.getCurServerKey().isNotEmpty
          ? DataSp.getCurServerKey()
          : Config.hostWithProtocol);
  final loginType =
      (null != email && email.isNotEmpty) ? "emailWithPwd" : "phoneWithPwd";
  final loginInfoKey =
      getLoginInfoKey(serverWithProtocol: serverWithProtocol, userID: userID);
  await DataSp.putAccountLoginInfoMap({
    loginInfoKey: AccountLoginInfo.fromJson({
      "id": loginInfoKey,
      "userID": userID,
      "server": serverWithProtocol,
      // "tls": uri.scheme == 'https',
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
  await DataSp.putCurServerKey(serverWithProtocol);
}

// String getTlsKey({required String server}) {
//   return Config.targetIsIP(server) ? "0" : "1";
// }

// String getServerKey({required String server}) {
//   final tlsKey = getTlsKey(server: server);
//   return "${server}__${tlsKey}";
// }

String getLoginInfoKey(
    {required String serverWithProtocol, required String userID}) {
  return "${serverWithProtocol}__$userID";
}
