import 'dart:ffi';
import 'dart:io';
import 'package:sprintf/sprintf.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:miti_circle/miti_circle.dart';
import 'package:miti_circle/src/w_apis.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../work_moments_list/work_moments_list_logic.dart';

enum PublishType {
  picture,
  video,
}

class AssetFile {
  File? file;
  String? path;
}

class Tag {
  String label;
  String value;

  Tag({required String this.label, required String this.value});
}

class PublishLogic extends GetxController {
  final inputCtrl = TextEditingController();
  final text = "".obs;
  final focusNode = FocusNode();
  late Rx<PublishType> type;
  final assetsList = <AssetEntity>[].obs;
  BaseDeviceInfo? deviceInfo;
  final watchList = <dynamic>[].obs;
  final remindList = <dynamic>[].obs;
  final permission = 0.obs;
  final isPublishXhs = false.obs;
  final isReprintArticle = false.obs;
  final authorCtrl = TextEditingController();
  final originUrlCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  final title = "".obs;
  Rx<Tag> activeTag = Rx(Tag(label: StrLibrary.life, value: ""));
  List<Tag> get tags => [
        Tag(label: StrLibrary.life, value: "life"),
        Tag(label: StrLibrary.aigc, value: "aigc"),
        Tag(label: StrLibrary.web3, value: "web3"),
        Tag(label: StrLibrary.news, value: "news"),
      ];

  void selectTag(int index) {
    if (activeTag.value.value == tags[index].value) {
      activeTag.value = Tag(label: StrLibrary.life, value: "");
    } else {
      activeTag.value = tags[index];
    }
  }

  WorkingCircleBridge? get bridge => PackageBridge.workingCircleBridge;

  SelectContactsBridge? get contactsBridge =>
      PackageBridge.selectContactsBridge;

  @override
  void onClose() {
    authorCtrl.dispose();
    originUrlCtrl.dispose();
    titleCtrl.dispose();
    inputCtrl.dispose();
    focusNode.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    type = Rx(Get.arguments['type']);
    _initDeviceInfo();
    inputCtrl.addListener(() {
      text.value = inputCtrl.text.trim();
    });
    titleCtrl.addListener(() {
      title.value = titleCtrl.text.trim();
    });
    super.onInit();
  }

  void changePublish() {
    isPublishXhs.value = !isPublishXhs.value;
  }

  void changeReprintArticle() {
    isReprintArticle.value = !isReprintArticle.value;
  }

  _initDeviceInfo() async {
    if (null == deviceInfo) {
      final deviceInfoPlugin = DeviceInfoPlugin();
      deviceInfo = await deviceInfoPlugin.deviceInfo;
    }
    return deviceInfo;
  }

  bool get isPicture => !hasAssets || type.value == PublishType.picture;

  bool get hasAssets => assetsList.isNotEmpty;

  int get maxAssetsCount => isPicture ? 9 : 1;

  int get btnLength => isPicture
      ? (assetsList.length < maxAssetsCount ? 1 : 0)
      : (assetsList.isEmpty ? 1 : 0);

  bool showAddAssetsBtn(index) =>
      (assetsList.length < maxAssetsCount) &&
      (index == (assetsList.length + btnLength) - 1);

  bool get canPublish {
    if (!isPublishXhs.value) {
      return assetsList.isNotEmpty || text.isNotEmpty;
    } else {
      return assetsList.isNotEmpty && title.value.isNotEmpty;
    }
  }

  void back() async {
    // if (canPublish) {
    //   var confirm = await Get.dialog(CustomDialog(
    //     bigTitle: StrLibrary .tips,
    //     title: StrLibrary .momentsDraftTips,
    //     leftText: StrLibrary .noSaveAlias,
    //     rightText: StrLibrary .saveAlias,
    //   ));
    //   if (confirm == true) {
    //     IMViews.showToast(StrLibrary .saveSuccessfully);
    //     Get.back();
    //   } else {
    //     Get.back();
    //   }
    // }else{
    //   Get.back();
    // }
    Get.back();
  }

  void selectAssets() => Get.bottomSheet(
        barrierColor: Styles.c_191919_opacity50,
        BottomSheetView(
          items: [
            SheetItem(
              label: StrLibrary.selectAssetsFromCamera,
              onTap: _selectAssetsFromCamera,
            ),
            SheetItem(
              label: StrLibrary.selectAssetsFromAlbum,
              onTap: _selectAssetsFromAlbum,
            ),
          ],
        ),
      );

  _selectAssetsFromAlbum() async {
    Permissions.storage(permissions: [
      Permissions.photosPermission,
      Permissions.videosPermission
    ], () async {
      final assets2 = assetsList;
      final count = maxAssetsCount - assetsList.length;
      AssetType? firstAssetType =
          assetsList.isEmpty ? null : assetsList[0].type;
      int curSelectCount = assetsList.length;

      final List<AssetEntity>? assets = await AssetPicker.pickAssets(
        Get.context!,
        pickerConfig: AssetPickerConfig(
          selectedAssets: assetsList,
          maxAssets: maxAssetsCount,
          requestType: !hasAssets
              ? RequestType.common
              : isPicture
                  ? RequestType.image
                  : RequestType.video,
          selectPredicate: (_, entity, isSelected) {
            if (!isSelected) {
              // 多个图片, 一个视频
              if (null != firstAssetType && entity.type != firstAssetType) {
                showToast(StrLibrary.pleaseSelectFirstType);
                return false;
              }

              if (null != firstAssetType && entity.type == AssetType.video) {
                showToast(StrLibrary.onlySupportOneVideo);
                return false;
              }

              // 视频限制15s的时长
              if (entity.type == AssetType.video &&
                  entity.videoDuration > const Duration(seconds: 15)) {
                IMViews.showToast(sprintf(StrLibrary.selectVideoLimit, [15]) +
                    StrLibrary.seconds);
                return false;
              }

              curSelectCount++;
              firstAssetType = entity.type;
              return true;
            } else {
              curSelectCount--;
              if (curSelectCount == 0) {
                firstAssetType = null;
              }
              return true;
            }
          },
        ),
      );
      if (null != assets) {
        if (assets[0].type == AssetType.video) {
          type.value = PublishType.video;
          assetsList.assignAll([assets[0]]);
        } else {
          type.value = PublishType.picture;
          assetsList.assignAll(assets.where((e) => e.type == AssetType.image));
        }
      }
    });
  }

  _selectAssetsFromCamera() async {
    Permissions.camera(() async {
      final AssetEntity? assetEntity = await CameraPicker.pickFromCamera(
        Get.context!,
        locale: Get.locale,
        pickerConfig: CameraPickerConfig(
          enableAudio: true,
          enableScaledPreview: true,
          resolutionPreset: ResolutionPreset.medium,
          maximumRecordingDuration: 15.seconds,
          onlyEnableRecording: hasAssets && !isPicture,
          enableRecording: !hasAssets || !isPicture,
          onMinimumRecordDurationNotMet: () {
            IMViews.showToast(StrLibrary.tapTooShort);
          },
        ),
      );
      if (null != assetEntity) {
        type.value = assetEntity.type == AssetType.video
            ? PublishType.video
            : PublishType.picture;
        assetsList.add(assetEntity);
      }
    });
  }

  previewSelectedPicture(int index) => isPicture
      ? WNavigator.startPreviewSelectedPicture(currentIndex: index)
      : WNavigator.startPreviewSelectedVideo();

  deleteAssets(int index) {
    assetsList.removeAt(index);
  }

  /// 0/1/2/3, 公开/私密/部分可见/不给谁看
  whoCanWatch() async {
    final result = await WNavigator.startWhoCanWatch(
      permission: permission.value,
      checkedList: watchList.value,
    );
    if (result is Map) {
      permission.value = result['permission'];
      watchList.assignAll(result['checkedList']);
    }
  }

  remindWhoToWatch() async {
    final result =
        await contactsBridge?.selectContacts(1, checkedList: remindList);
    if (result is Map) {
      final values = result.values;
      remindList.assignAll(values);
    }
  }

  String get whoCanWatchLabel {
    if (permission.value == 3) {
      return StrLibrary.partiallyInvisible;
    }
    return StrLibrary.whoCanWatch;
  }

  String get whoCanWatchValue {
    if (permission.value == 0) {
      return StrLibrary.public;
    } else if (permission.value == 1) {
      return StrLibrary.private;
    } else if (permission.value == 2) {
      return watchList.map((e) => parseName(e)).join('、');
    } else if (permission.value == 3) {
      return watchList.map((e) => parseName(e)).join('、');
    }
    return '';
  }

  String get remindWhoToWatchValue {
    return remindList.map((e) => parseName(e)).join('、');
  }

  String? parseName(value) {
    if (value is UserInfo) {
      return value.nickname;
    } else if (value is GroupInfo) {
      return value.groupName;
    } else if (value is ISUserInfo) {
      return value.nickname;
    }
    return null;
  }

  publish() async {
    // if (inputCtrl.text.trim().isEmpty) {
    //   focusNode.requestFocus();
    //   IMViews.showToast(StrLibrary .plsEnterDescription);
    //   return;
    // }
    if (isPublishXhs.value &&
        originUrlCtrl.text.trim().isNotEmpty &&
        !RegExp(regexUrl).hasMatch(originUrlCtrl.text.trim())) {
      showToast(StrLibrary.pleaseInputValidUrl);
      return;
    }

    await LoadingView.singleton.start(fn: () async {
      final permissionUserList = <UserInfo>[];
      final permissionGroupList = <GroupInfo>[];
      final atUserList = <UserInfo>[];
      for (final info in watchList) {
        if (info is GroupInfo) {
          permissionGroupList.add(info);
        } else {
          permissionUserList.add(UserInfo(
              userID: info.userID,
              nickname: info.nickname,
              faceURL: info.faceURL));
        }
      }
      for (final info in remindList) {
        atUserList.add(UserInfo(
            userID: info.userID,
            nickname: info.nickname,
            faceURL: info.faceURL));
      }

      List<Map<String, String>> metas = [];

      // 处理图片的压缩
      await Future.forEach<AssetEntity>(assetsList.value, (element) async {
        var file = await element.file;
        // var original = await element.originFile;
        // 图片需要压缩
        final mime = MitiUtils.getMediaType(file!.path);
        if (element.type == AssetType.image) {
          // final mime = MitiUtils.getMediaType(file!.path);
          if (mime == 'image/gif') {
            metas.add({'thumb': file.path, 'original': file.path});
          } else {
            file = await MitiUtils.compressImageAndGetFile(file);
            metas.add({'thumb': file!.path, 'original': file.path});
          }
        } else {
          // file = await MitiUtils.compressVideoAndGetFile(file!);
          final thumbPic = await MitiUtils.getVideoThumbnail(file!);
          metas.add({'thumb': thumbPic.path, 'original': file.path});
        }
      });
      await WApis.publishMoments(
          text: inputCtrl.text.trim(),
          type: isPicture ? 0 : 1,
          permissionUserList: !isPublishXhs.value ? permissionUserList : [],
          permissionGroupList: !isPublishXhs.value ? permissionGroupList : [],
          atUserList: !isPublishXhs.value ? atUserList : [],
          metas: metas,
          permission: !isPublishXhs.value ? permission.value : 0,
          momentType: !isPublishXhs.value ? 1 : 2,
          title: !isPublishXhs.value ? null : titleCtrl.text.trim(),
          author: !isPublishXhs.value ? null : authorCtrl.text.trim(),
          category: !isPublishXhs.value ? null : activeTag.value.value,
          originLink: !isPublishXhs.value ? null : originUrlCtrl.text.trim());
    });
    bridge?.opEventSub.add({'opEvent': OpEvent.publish});
    Get.back();
  }
}
