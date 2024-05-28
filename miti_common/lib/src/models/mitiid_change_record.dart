import 'dart:convert';

class MitiIDChangeRecord {
  String userID;
  String mitiID;
  int updateTime;

  MitiIDChangeRecord.fromJson(Map<String, dynamic> map)
      : userID = map["userID"] ?? '',
        mitiID = map["mitiID"] ?? '',
        updateTime = map["updateTime"] ?? 0;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userID'] = userID;
    data['mitiID'] = mitiID;
    data['updateTime'] = updateTime;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
