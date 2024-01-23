import 'dart:convert';
import 'dart:typed_data';

class ConversationConfig {
  String id;
  // bool? waitingReply;
  int? waitingST;

  ConversationConfig.fromJson(Map<String, dynamic> map)
      : id = map["id"] ?? '',
        // waitingReply = map["waitingReply"] ?? false,
        waitingST = map["waitingST"] ?? 0;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    // data['waitingReply'] = waitingReply;
    data['waitingST'] = waitingST;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
