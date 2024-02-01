import 'dart:convert';

class Ai {
  String key;
  String userID;
  String botID;
  String nickName;

  Ai.fromJson(Map<String, dynamic> map)
      : key = map["key"] ?? '',
        userID = map["userID"] ?? '',
        botID = map["botID"] ?? '',
        nickName = map["nickName"] ?? '';

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['key'] = key;
    data['userID'] = userID;
    data['botID'] = botID;
    data['nickName'] = nickName;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
