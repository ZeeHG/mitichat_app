import 'dart:convert';

import 'package:dart_date/dart_date.dart';

enum ActionCategory { chat, discover, circle, me }

extension ActionCategoryExtension on ActionCategory {
  String get value {
    switch (this) {
      case ActionCategory.chat:
        return "chat";
      case ActionCategory.discover:
        return "discover";
      case ActionCategory.circle:
        return "circle";
      case ActionCategory.me:
        return "me";
      default:
        return "";
    }
  }
}

enum ActionName { empty, enter_discover, read, read_origin, click_like, click_comment, publish_comment }

extension ActionNameExtension on ActionName {
  String get value {
    switch (this) {
      case ActionName.enter_discover:
        return "enter_discover";
      case ActionName.read:
        return "read";
      case ActionName.read_origin:
        return "read_origin";
      case ActionName.click_like:
        return "click_like";
      case ActionName.click_comment:
        return "click_comment";
      case ActionName.publish_comment:
        return "publish_comment";
      default:
        return "";
    }
  }
}

class ActionRecord {
  ActionCategory category;
  ActionName actionName;
  String? workMomentID;
  int actionTime;

  ActionRecord({
    required this.category,
    this.actionName = ActionName.empty,
    this.workMomentID = "",
    int? actionTime,
  }): actionTime = actionTime ?? DateTime.now().microsecondsSinceEpoch;

  ActionRecord.fromJson(Map<String, dynamic> map)
      : category = map["category"] ?? '',
        actionName = map["actionName"] ?? '',
        workMomentID = map["workMomentID"] ?? '',
        actionTime = map["actionTime"] ?? DateTime.now().microsecondsSinceEpoch;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['category'] = category.value;
    data['actionName'] = actionName.value;
    data['workMomentID'] = workMomentID;
    data['actionTime'] = actionTime;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
