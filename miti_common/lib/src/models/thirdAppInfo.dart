import 'dart:convert';

// {
//   "errCode": 0,
//   "errMsg": "",
//   "errDlt": "",
//   "data": {
//     "platforms": [
//       {
//         "platformId": 1,
//         "googleApp": {
//           "appGoolgeID": "940547054713-9n4cgc7psl79di4ru3osa4amnll6h6u1.apps.googleusercontent.com",
//           "webGoolgeID": "940547054713-9oaa6sd4sr5mq31gb44ssskkr3fcjej0.apps.googleusercontent.com"
//         },
//         "appleApp": {
//           "serviceID": "chat.miti.ios",
//           "clientID": "chat.miti.service"
//         }
//       },
//       {
//         "platformId": 2,
//         "googleApp": {
//           "webGoolgeID": "940547054713-9oaa6sd4sr5mq31gb44ssskkr3fcjej0.apps.googleusercontent.com"
//         },
//         "appleApp": {
//           "serviceID": "chat.miti.ios",
//           "clientID": "chat.miti.service"
//         }
//       },
//       {
//         "platformId": 5,
//         "googleApp": {
//           "webGoolgeID": "940547054713-9oaa6sd4sr5mq31gb44ssskkr3fcjej0.apps.googleusercontent.com"
//         },
//         "appleApp": {
//           "serviceID": "chat.miti.ios",
//           "clientID": "chat.miti.service"
//         }
//       }
//     ]
//   }
// }

class ThirdAppInfoMap {
  ThirdAppInfo? android;
  ThirdAppInfo? ios;
  ThirdAppInfo? web;

  ThirdAppInfoMap({this.android, this.ios, this.web});

}

// 无fb
class ThirdAppInfo {
  int platformId;
  Map<String, dynamic>? googleApp;
  Map<String, dynamic>? appleApp;

  ThirdAppInfo.fromJson(Map<String, dynamic> map)
      : platformId = map["platformId"],
        googleApp = map["googleApp"],
        appleApp = map["appleApp"];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['platformId'] = platformId;
    data['googleApp'] = googleApp;
    data['appleApp'] = appleApp;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
