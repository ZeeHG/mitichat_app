import 'dart:convert';

class ConversationConfig {
  String key;
  String conversationID;
  int? waitingST;

  ConversationConfig.fromJson(Map<String, dynamic> map)
      : key = map["key"] ?? '',
        conversationID = map["conversationID"] ?? '',
        waitingST = map["waitingST"] ?? 0;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['key'] = key;
    data['conversationID'] = conversationID;
    data['waitingST'] = waitingST;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
