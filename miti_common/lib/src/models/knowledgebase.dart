import 'dart:convert';

class Knowledgebase {
  String key;
  String knowledgebaseID;
  String knowledgebaseName;
  String documentContentDescription;

  Knowledgebase.fromJson(Map<String, dynamic> map)
      : key = map["key"] ?? '',
        knowledgebaseID = map["knowledgebaseID"] ?? '',
        knowledgebaseName = map["knowledgebaseName"] ?? '',
        documentContentDescription = map["documentContentDescription"] ?? '';

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['key'] = key;
    data['knowledgebaseID'] = knowledgebaseID;
    data['knowledgebaseName'] = knowledgebaseName;
    data['documentContentDescription'] = documentContentDescription;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
