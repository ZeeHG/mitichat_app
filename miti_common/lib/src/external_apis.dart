import 'package:miti_common/miti_common.dart';

class ExternalApis {
  static Future<dynamic> getGoogleOAuth({
    required String clientID,
    required String redirectUri,
    String grantType = 'authorization_code',
    required String code,
  }) async {
    final data = await HttpUtil.post(ExternalUrls.googleAuth,
        returnOriginResp: true,
        data: {
          'client_id': clientID,
          'redirect_uri': redirectUri,
          'grant_type': grantType,
          'code': code,
        });
    return GoogleAuth.fromJson({
      "accessToken": data["access_token"],
      "expiresIn": data["expires_in"],
      "refreshToken": data["refresh_token"],
      "scope": data["scope"],
      "idToken": data["id_token"],
      "tokenType": data["token_type"]
    });
  }
}
