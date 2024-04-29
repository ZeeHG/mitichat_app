import 'dart:convert';

class GoogleAuth {
  String accessToken;
  int expiresIn;
  String refreshToken;
  String scope;
  String idToken;
  String tokenType;

  GoogleAuth.fromJson(Map<String, dynamic> map)
      : accessToken = map["accessToken"] ?? '',
        expiresIn = map["expiresIn"] ?? 0,
        refreshToken = map["refreshToken"] ?? '',
        scope = map["scope"] ?? '',
        idToken = map["idToken"] ?? '',
        tokenType = map["tokenType"] ?? '';

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['expiresIn'] = expiresIn;
    data['refreshToken'] = refreshToken;
    data['scope'] = scope;
    data['idToken'] = idToken;
    data['tokenType'] = tokenType;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
