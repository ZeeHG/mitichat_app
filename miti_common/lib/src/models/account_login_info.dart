import 'dart:convert';

enum SupportLoginType {
  email,
  phone,
  google,
  apple,
  facebook,
  localJwt,
}

Map<int, SupportLoginType> SupportLoginTypeMap = {
  1: SupportLoginType.email,
  2: SupportLoginType.phone,
  3: SupportLoginType.google,
  4: SupportLoginType.apple,
  5: SupportLoginType.facebook,
  6: SupportLoginType.localJwt,
};

// enum UserLoginType { emailWithPwd, phoneWithPwd }

class AccountLoginInfo {
  String id;
  String userID;
  String server;
  // String tls;
  String email;
  String areaCode;
  String phoneNumber;
  // "phoneWithPwd", "emailWithPwd"
  String loginType;
  String password;
  String faceURL;
  String nickname;
  String imToken;
  String chatToken;

  AccountLoginInfo.fromJson(Map<String, dynamic> map)
      : id = map["id"] ?? '',
        userID = map["userID"] ?? '',
        server = map["server"] ?? '',
        // tls = map["tls"] ?? "1",
        email = map["email"] ?? '',
        areaCode = map["areaCode"] ?? '',
        phoneNumber = map["phoneNumber"] ?? '',
        loginType = map["loginType"] ?? "phoneWithPwd",
        password = map["password"] ?? '',
        faceURL = map["faceURL"] ?? '',
        nickname = map["nickname"] ?? '',
        imToken = map["imToken"] ?? '',
        chatToken = map['chatToken'] ?? '';

  Map<String, dynamic> toJson({bool delSensitiveFields = false}) {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userID'] = userID;
    data['server'] = server;
    // data['tls'] = tls;
    data['email'] = email;
    data['areaCode'] = areaCode;
    data['phoneNumber'] = phoneNumber;
    data['loginType'] = loginType;
    data['faceURL'] = faceURL;
    data['nickname'] = nickname;
    if(!delSensitiveFields){
      data['password'] = password;
      data['imToken'] = imToken;
      data['chatToken'] = chatToken;
    }
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
