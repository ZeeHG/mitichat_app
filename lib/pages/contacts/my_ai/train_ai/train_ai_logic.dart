import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class TrainAiLogic extends GetxController {
  @override
  void onInit() {
    inputCtrl.addListener(() {
      text.value = inputCtrl.text;
    });
    super.onInit();
  }

  @override
  void onReady() {
    getBotKnowledgebases();
    super.onReady();
  }

  @override
  void onClose() {
    inputCtrl.dispose();
    super.onClose();
  }

  final arguments = Get.arguments;
  final faceURL = Rx<String>(Get.arguments['faceURL']);
  final showName = Rx<String>(Get.arguments['showName']);
  final ai = Rx<Ai>(Get.arguments['ai']);
  final assetsList = <AssetEntity>[].obs;
  final maxLength = 3200.obs;
  final inputCtrl = TextEditingController();
  final text = "".obs;
  final files = <String>[].obs;
  final knowledgebaseList = <Knowledgebase>[].obs;
  final selectedKnowledgebase = Rx<Knowledgebase?>(null);
  final maxFilesCount = 8;

  String get count => "${text.value.length}/${maxLength.value}";

  bool get canTain =>
      (text.value.length > 0 || files.value.length > 0) &&
      (null != selectedKnowledgebase.value);

  bool get canSeeFiles => null != selectedKnowledgebase.value;

  List<String> get fileNames => files.map((e) => e.split('/').last).toList();

  void startKnowledgeFiles() => AppNavigator.startKnowledgeFiles(
      knowledgebase: selectedKnowledgebase.value!);

  void getBotKnowledgebases() {
    LoadingView.singleton.start(fn: () async {
      final knowledgebases =
          (await Apis.getBotKnowledgebases(botID: ai.value.botID))["data"] ??
              [];
      knowledgebaseList.value = knowledgebases
          .map((e) => Knowledgebase.fromJson({
                "key": e["knowledgebaseID"],
                "knowledgebaseID": e["knowledgebaseID"],
                "knowledgebaseName": e["knowledgebaseName"],
                "documentContentDescription": e["documentContentDescription"],
              }))
          .toList()
          .cast<Knowledgebase>();
      if (knowledgebaseList.length == 0) {
        showToast(StrLibrary.pleaseUpgradeAiOrOpenKnowledgebase);
      }
    });
  }

  void train() async {
    await LoadingView.singleton.start(fn: () async {
      await Apis.addKnowledge(
          knowledgebaseID: selectedKnowledgebase.value!.knowledgebaseID,
          text: text.value,
          filePathList: files.value);
      inputCtrl.text = '';
      text.value = '';
      files.value = [];
    });
    // await Apis.getMyAiTask();
    final confirm = await Get.dialog(SuccessDialog(
      text: StrLibrary.trainSuccessTips,
      onTapConfirm: () => Get.back(),
    ));
  }

  void selectFile() async {
    await FilePicker.platform.clearTemporaryFiles();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf', 'json', 'md', 'zip'],
    );

    if (result != null) {
      final canAddCount = maxFilesCount - files.length;
      final list = result.files
          .where((item) => File(item.path!).lengthSync() < 20 * 1024 * 1024)
          .map((item) => item.path!)
          .take(canAddCount)
          .toList();
      files.addAll(list);
    }
  }

  void selectKnowledgebase() async {
    if (knowledgebaseList.length == 0) return;
    IMViews.showSinglePicker(
      title: StrLibrary.selectKnowledgebase,
      description: "",
      pickerData: knowledgebaseList
          .map((element) => element.knowledgebaseName)
          .toList(),
      onConfirm: (indexList, valueList) {
        final index = indexList.firstOrNull;
        if (null != index) {
          selectedKnowledgebase.value = knowledgebaseList[index];
        }
      },
    );
  }
}
