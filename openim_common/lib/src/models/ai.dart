import 'dart:convert';

class Ai {
  String key;
  String userID;
  String botID;
  String nickName;
  int createTime;
  String createdBy;

  Ai.fromJson(Map<String, dynamic> map)
      : key = map["key"] ?? '',
        userID = map["userID"] ?? '',
        botID = map["botID"] ?? '',
        nickName = map["nickName"] ?? '',
        createTime = map["createTime"] ?? 0,
        createdBy = map["createdBy"] ?? '';

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['key'] = key;
    data['userID'] = userID;
    data['botID'] = botID;
    data['nickName'] = nickName;
    data['createTime'] = createTime;
    data['createdBy'] = createdBy;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
