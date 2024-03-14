import 'dart:convert';
import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import '../miti_common.dart';
// import 'package:flutter_langdetect/flutter_langdetect.dart' as langdetect;

class TranslateLogic extends GetxController {
  TranslateLogic() {
    // init();
  }

  String userID = "";
  RxMap<String, dynamic> msgTranslate = <String, dynamic>{}.obs;
  RxMap<String, dynamic> langConfig = <String, dynamic>{}.obs;
  // final detect = langdetect.detect;
  final onLangConfigChangeSub = PublishSubject();

  get langMap => {
        "auto": StrLibrary.auto,
        "English": StrLibrary.English,
        "Spanish": StrLibrary.Spanish,
        "French": StrLibrary.French,
        "German": StrLibrary.German,
        "Italian": StrLibrary.Italian,
        "Portuguese": StrLibrary.Portuguese,
        "Dutch": StrLibrary.Dutch,
        "Russian": StrLibrary.Russian,
        "Swedish": StrLibrary.Swedish,
        "Polish": StrLibrary.Polish,
        "Danish": StrLibrary.Danish,
        "Norwegian": StrLibrary.Norwegian,
        "Irish": StrLibrary.Irish,
        "Greek": StrLibrary.Greek,
        "Finnish": StrLibrary.Finnish,
        "Czech": StrLibrary.Czech,
        "Hungarian": StrLibrary.Hungarian,
        "Romanian": StrLibrary.Romanian,
        "Bulgarian": StrLibrary.Bulgarian,
        "Slovak": StrLibrary.Slovak,
        "Slovenian": StrLibrary.Slovenian,
        "Estonian": StrLibrary.Estonian,
        "Latvian": StrLibrary.Latvian,
        "Lithuanian": StrLibrary.Lithuanian,
        "Maltese": StrLibrary.Maltese,
        "Icelandic": StrLibrary.Icelandic,
        "Albanian": StrLibrary.Albanian,
        "Croatian": StrLibrary.Croatian,
        "Serbian": StrLibrary.Serbian,
        "SimplifiedChinese": StrLibrary.SimplifiedChinese,
        "TraditionalChinese": StrLibrary.TraditionalChinese,
        "Japanese": StrLibrary.Japanese,
        "Korean": StrLibrary.Korean,
        "Arabic": StrLibrary.Arabic,
        "Hindi": StrLibrary.Hindi,
        "Bengali": StrLibrary.Bengali,
        "Thai": StrLibrary.Thai,
        "Vietnamese": StrLibrary.Vietnamese,
        "Indonesian": StrLibrary.Indonesian,
        "Malay": StrLibrary.Malay,
        "Tamil": StrLibrary.Tamil,
        "Urdu": StrLibrary.Urdu,
        "Filipino": StrLibrary.Filipino,
        "Persian": StrLibrary.Persian,
        "Hebrew": StrLibrary.Hebrew,
        "Turkish": StrLibrary.Turkish,
        "Kannada": StrLibrary.Kannada,
        "Malayalam": StrLibrary.Malayalam,
        "Sindhi": StrLibrary.Sindhi,
        "Punjabi": StrLibrary.Punjabi,
        "Nepali": StrLibrary.Nepali,
        "Swahili": StrLibrary.Swahili,
        "Amharic": StrLibrary.Amharic,
        "Zulu": StrLibrary.Zulu,
        "Somali": StrLibrary.Somali,
        "Hausa": StrLibrary.Hausa,
        "Igbo": StrLibrary.Igbo,
        "Yoruba": StrLibrary.Yoruba,
        "Quechua": StrLibrary.Quechua,
        "Guarani": StrLibrary.Guarani,
        "Maori": StrLibrary.Maori,
        "Esperanto": StrLibrary.Esperanto,
        "Latin": StrLibrary.Latin,
      };

  bool isAutoTranslate(String conversationID) {
    final config = langConfig[conversationID];
    final autoTranslate = (null == config || null == config["autoTranslate"])
        ? false
        : config["autoTranslate"];
    return autoTranslate;
  }

  String? getTargetLang(String conversationID) {
    final config = langConfig[conversationID];
    return (null == config || null == config["targetLang"])
        ? null
        : config["targetLang"];
  }

  String getTargetLangStr(String? targetLang) {
    return null != targetLang
        ? (langMap[targetLang] ?? langMap["auto"]!)
        : langMap["auto"]!;
  }

  void setTargetLang(ConversationInfo conversation) {
    final pickerData = langMap.values.toList();
    final pickerKeys = langMap.keys.toList();
    IMViews.showSinglePicker(
      title: StrLibrary.targetLang,
      description: "",
      pickerData: pickerData,
      onConfirm: (indexList, valueList) {
        final index = indexList.firstOrNull;
        if (index == 0) {
          updateLangConfig(
              conversation: conversation, data: {"targetLang": null});
        } else {
          updateLangConfig(
              conversation: conversation,
              data: {"targetLang": pickerKeys[index!]});
        }
      },
    );
  }

  void setTargetLangAndAutoTranslate(ConversationInfo conversation) async {
    final pickerData = langMap.values.toList();
    final pickerKeys = langMap.keys.toList();
    final useAutoTranslate = isAutoTranslate(conversation.conversationID).obs;
    final targetLang = getTargetLang(conversation.conversationID);
    final index = pickerKeys.indexWhere((key) => key == targetLang);

    onConfirm(List<int> indexList, List valueList) {
      final index = indexList.firstOrNull;
      if (index == 0) {
        updateLangConfig(conversation: conversation, data: {
          "targetLang": null,
          "autoTranslate": useAutoTranslate.value
        });
      } else {
        updateLangConfig(conversation: conversation, data: {
          "targetLang": pickerKeys[index!],
          "autoTranslate": useAutoTranslate.value
        });
      }
    }

    onChanged(bool val) {
      useAutoTranslate.value = val;
    }

    final picker = Picker(
      adapter: PickerDataAdapter<String>(
        pickerData: pickerData,
        isArray: false,
      ),
      changeToFirst: true,
      hideHeader: true,
      containerColor: Styles.c_FFFFFF,
      textStyle: Styles.ts_333333_17sp,
      selectedTextStyle: Styles.ts_333333_17sp,
      itemExtent: 45.h,
      selecteds: index != null ? [index] : [0],
      selectionOverlay: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(color: Styles.c_E8EAEF, width: 1),
            top: BorderSide(color: Styles.c_E8EAEF, width: 1),
          ),
        ),
      ),
    ).getInstance();
    final confirm = await Get.dialog(CustomDialog(
      body: Padding(
          padding: EdgeInsets.only(
            top: 16.w,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                child: Text(
                  StrLibrary.autoTranslate,
                  textAlign: TextAlign.center,
                  style: Styles.ts_333333_16sp_medium,
                ),
              ),
              7.verticalSpace,
              Obx(() => CupertinoSwitch(
                    value: useAutoTranslate.value,
                    activeColor: Styles.c_07C160,
                    onChanged: onChanged,
                  )),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 16.w,
                ),
                child: Text(
                  StrLibrary.targetLang,
                  textAlign: TextAlign.center,
                  style: Styles.ts_333333_14sp,
                ),
              ),
              picker.widget!
            ],
          )),
    ));
    if (confirm) {
      onConfirm.call(picker.selecteds, picker.getSelectedValues());
    }
  }

  init(String id) {
    userID = id;
    // langdetect.initLangDetect();

    Map<String, dynamic>? _msgTranslate = getMsgTranslate();
    if (null == _msgTranslate) {
      setMsgTranslate({});
    } else {
      // 清除status==loading的状态
      _msgTranslate.values.forEach((item) {
        if (item?["status"] == "loading") {
          item.remove("status");
        }
      });
      msgTranslate.addAll(_msgTranslate);
    }

    final _langConfig = getLangConfig();
    if (null == _langConfig) {
      setLangConfig({});
    } else {
      langConfig.addAll(_langConfig);
    }

    msgTranslate.refresh();
    langConfig.refresh();
  }

  getLangConfig() {
    return SpUtil().getObject("${userID}_langConfig");
  }

  setLangConfig(Map<String, dynamic> data) {
    SpUtil().putObject("${userID}_langConfig", data);
  }

  getMsgTranslate() {
    return SpUtil().getObject("${userID}_msgTranslate");
  }

  setMsgTranslate(Map<String, dynamic> data) {
    SpUtil().putObject("${userID}_msgTranslate", data);
  }

  // {targetLang, autoTranslate}
  updateLangConfig(
      {required ConversationInfo conversation,
      required Map<String, dynamic> data,
      String mode = "assign"}) {
    LoadingView.singleton.start(
        fn: () => updateLangConfigAll(
            conversation: conversation, data: data, mode: mode));
  }

  // assign/cover
  updateLangConfigAll(
      {required ConversationInfo conversation,
      required Map<String, dynamic> data,
      String mode = "assign"}) async {
    final conversationID = conversation.conversationID;
    langConfig[conversationID] = langConfig[conversationID] ?? {};
    Map<String, dynamic>? item =
        Map<String, dynamic>.from(langConfig[conversationID]);
    final ex = conversation.ex;
    Map<String, dynamic> newLangConfig = {};
    Map<String, dynamic> exJson =
        (null != ex && ex.isNotEmpty) ? json.decode(ex) : {};
    // newLangConfig = exJson["langConfig"] ?? {};
    if (mode == "assign") {
      newLangConfig = json.decode(json.encode(item));
      newLangConfig.addAll(data);
    } else if (mode == "cover") {
      newLangConfig = data;
    }
    exJson["langConfig"] = newLangConfig;
    final exJsonStr = json.encode(exJson);
    final requestConversation = {
      "conversationID": conversation.conversationID,
      "conversationType": conversation.conversationType,
      "userID": conversation.userID,
      "ex": exJsonStr,
      "groupID": conversation.groupID
    };
    final result =
        await Apis.setConversationConfig(conversation: requestConversation);
    conversation.ex = exJsonStr;
    updateLangConfigLocal(conversation: conversation, data: data, mode: mode);
  }

  updateLangConfigLocal(
      {required ConversationInfo conversation,
      required Map<String, dynamic> data,
      String mode = "assign"}) async {
    final conversationID = conversation.conversationID;
    langConfig[conversationID] = langConfig[conversationID] ?? {};
    Map<String, dynamic>? item =
        Map<String, dynamic>.from(langConfig[conversationID]);
    if (mode == "assign") {
      if (null == item) {
        langConfig.addAll({conversationID: data});
      } else {
        item.addAll(data);
        langConfig.addAll({conversationID: item});
      }
    } else if (mode == "cover") {
      langConfig.addAll({conversationID: data});
    }
    langConfig.refresh();
    setLangConfig(langConfig.value);
    onLangConfigChangeSub.add("update");
  }

  // {targetLang, lang, clientMsgID, origin, status/hide/show/loading/fail}
  updateMsgLocalTranslate(String clientMsgID, Map<String, String> data) {
    final item = msgTranslate[clientMsgID];
    if (null == item) {
      msgTranslate.addAll({clientMsgID: data});
    } else {
      item.addAll(data);
      msgTranslate.addAll({clientMsgID: item});
    }
    msgTranslate.refresh();
    setMsgTranslate(msgTranslate.value);
    myLogger.i({
      "message": "本地翻译更新, clientMsgID=${clientMsgID}",
      "data": msgTranslate[clientMsgID]
    });
  }

  updateMsgExTranslate(Message message, Map<String, String> data) {
    message.ex = message.ex ?? "{}";
    Map<String, dynamic>? exJson;
    try {
      exJson = json.decode(message.ex!);
    } finally {
      exJson = exJson ?? {};
      exJson["translate"] = exJson["translate"] ?? {};
      exJson["translate"].addAll(data);
      message.ex = json.encode(exJson);
    }
  }

  updateMsgAllTranslate(Message message, Map<String, String> data) {
    // Map<String, String> newData = Map<String, String>.from(data);
    // updateMsgExTranslate(message, data);
    if (null != message.clientMsgID) {
      updateMsgLocalTranslate(message.clientMsgID!, data);
    }
  }

  clearAllTranslateMsgCache() {
    msgTranslate.value = {};
    setMsgTranslate({});
    IMViews.showToast(StrLibrary.success);
  }

  clearAllTranslateConfig() {
    LoadingView.singleton.start(fn: () async {
      List<ConversationInfo> conversationList =
          await OpenIM.iMManager.conversationManager.getConversationListSplit(
        offset: 0,
        count: 999,
      );
      await Future.wait(
          conversationList.map((conversation) async {
            await updateLangConfig(
                conversation: conversation, data: {}, mode: "cover");
          }).toList(), cleanUp: (value) {
        if (value == null) {
          IMViews.showToast(StrLibrary.someFail);
        }
      });
      langConfig.value = {};
      setLangConfig({});
      IMViews.showToast(StrLibrary.allSuccess);
    });
  }
}
