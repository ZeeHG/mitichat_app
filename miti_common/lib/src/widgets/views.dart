import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miti_common/miti_common.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:uuid/uuid.dart';

class IMViews {
  IMViews._();

  static final ImagePicker _picker = ImagePicker();

  static Future showToast(String msg, {Duration? duration}) {
    if (msg.trim().isNotEmpty) {
      return EasyLoading.showToast(msg, duration: duration);
    } else {
      return Future.value();
    }
  }

  static Widget buildHeader() => WaterDropMaterialHeader(
        backgroundColor: StylesLibrary.c_8443F8,
      );

  static Widget buildFooter() => CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            // body = Text("pull up load");
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            // body = Text("Load Failed!Click retry!");
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.canLoading) {
            // body = Text("release to load more");
            body = const CupertinoActivityIndicator();
          } else {
            // body = Text("No more Data");
            body = const SizedBox();
          }
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      );

  static openIMCallSheet(
    String label,
    Function(int index) onTapSheetItem,
  ) {
    return Get.bottomSheet(
      barrierColor: StylesLibrary.c_191919_opacity50,
      BottomSheetView(
        items: [
          SheetItem(
            label: StrLibrary.callVideo,
            icon: ImageLibrary.callVideo2.toImage
              ..width = 24.w
              ..height = 15.h,
            onTap: () => onTapSheetItem.call(1),
          ),
          SheetItem(
            label: StrLibrary.callVoice,
            icon: ImageLibrary.callVoice2.toImage
              ..width = 20.w
              ..height = 21.h,
            onTap: () => onTapSheetItem.call(0),
          ),
        ],
      ),
    );
  }

  static openXhsDetailMoreSheet(
      {required Function(String action) onTapSheetItem,
      bool showDelete = false}) {
    return Get.bottomSheet(
      barrierColor: StylesLibrary.c_191919_opacity50,
      BottomSheetView(
        items: [
          if (showDelete)
            SheetItem(
              label: StrLibrary.delete,
              onTap: () => onTapSheetItem.call('delete'),
            ),
          SheetItem(
            label: StrLibrary.complaint2,
            textStyle: StylesLibrary.ts_FC4D4D_16sp,
            onTap: () => onTapSheetItem.call('complaint'),
          ),
        ],
      ),
    );
  }

  static openIMGroupCallSheet(
    String groupID,
    Function(int index) onTapSheetItem,
  ) {
    return Get.bottomSheet(
      barrierColor: StylesLibrary.c_191919_opacity50,
      BottomSheetView(
        items: [
          SheetItem(
            label: StrLibrary.callVideo,
            icon: ImageLibrary.callVideo2.toImage
              ..width = 24.w
              ..height = 15.h,
            onTap: () => onTapSheetItem.call(1),
          ),
          SheetItem(
            label: StrLibrary.callVoice,
            icon: ImageLibrary.callVoice2.toImage
              ..width = 20.w
              ..height = 21.h,
            onTap: () => onTapSheetItem.call(0),
          ),
        ],
      ),
      // barrierColor: Colors.transparent,
    );
  }

  static void openPhotoSheet(
      {Function(dynamic path, dynamic url)? onData,
      bool crop = true,
      bool toUrl = true,
      bool fromGallery = true,
      bool fromCamera = true,
      List<SheetItem> items = const [],
      int quality = 95}) {
    Get.bottomSheet(
      barrierColor: StylesLibrary.c_191919_opacity50,
      BottomSheetView(
        items: [
          ...items,
          if (fromGallery)
            SheetItem(
              label: StrLibrary.toolboxAlbum,
              onTap: () {
                Permissions.storage(
                    permissions: [Permission.photos, Permission.videos],
                    () async {
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (null != image?.path) {
                    var map = await _uCropPic(image!.path,
                        crop: crop, toUrl: toUrl, quality: quality);
                    onData?.call(map['path'], map['url']);
                  }
                });
              },
            ),
          if (fromCamera)
            SheetItem(
              label: StrLibrary.toolboxCamera,
              onTap: () {
                Permissions.camera(() async {
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (null != image?.path) {
                    var map = await _uCropPic(image!.path,
                        crop: crop, toUrl: toUrl, quality: quality);
                    onData?.call(map['path'], map['url']);
                  }
                });
              },
            ),
        ],
      ),
    );
  }

  static Future<Map<String, dynamic>> _uCropPic(
    String path, {
    bool crop = true,
    bool toUrl = true,
    int quality = 80,
  }) async {
    CroppedFile? cropFile;
    String? url;
    if (crop && !path.endsWith('.gif')) {
      cropFile = await MitiUtils.uCrop(path);
      if (cropFile == null) {
        // 放弃选择
        // return {'path': cropFile?.path ?? path, 'url': url};
        return {'path': null, 'url': null};
      }
    }
    if (toUrl) {
      String putID = const Uuid().v4();
      dynamic result;
      if (null != cropFile) {
        result = await LoadingView.singleton.start(fn: () async {
          final image = await MitiUtils.compressImageAndGetFile(
              File(cropFile!.path),
              quality: quality);

          return OpenIM.iMManager.uploadFile(
            id: putID,
            filePath: image!.path,
            fileName: image.path.split('/').last,
          );
        });
      } else {
        result = await LoadingView.singleton.start(fn: () async {
          final image = await MitiUtils.compressImageAndGetFile(File(path),
              quality: quality);

          return OpenIM.iMManager.uploadFile(
            id: putID,
            filePath: image!.path,
            fileName: image.path,
          );
        });
      }
      if (result is String) {
        url = jsonDecode(result)['url'];
      }
    }
    return {'path': cropFile?.path ?? path, 'url': url};
  }

  static void openDownloadSheet(
    String url, {
    Function()? onDownload,
  }) {
    Get.bottomSheet(
      BottomSheetView(
        items: [
          SheetItem(
            label: StrLibrary.download,
            onTap: () {
              onDownload?.call();
            },
          ),
        ],
      ),
      barrierColor: Colors.transparent,
    );
  }

  static TextSpan getTimelineTextSpan(int ms) {
    int locTimeMs = DateTime.now().millisecondsSinceEpoch;
    var languageCode = Get.locale?.languageCode ?? 'zh';

    if (DateUtil.isToday(ms, locMs: locTimeMs)) {
      return TextSpan(
        text: languageCode == 'zh' ? '今天' : 'Today',
        style: StylesLibrary.ts_333333_22sp_medium,
      );
    }

    if (DateUtil.isYesterdayByMs(ms, locTimeMs)) {
      return TextSpan(
        text: languageCode == 'zh' ? '昨天' : 'Yesterday',
        style: StylesLibrary.ts_333333_22sp_medium,
      );
    }

    if (DateUtil.isWeek(ms, locMs: locTimeMs)) {
      final weekday = DateUtil.getWeekdayByMs(ms, languageCode: languageCode);
      if (weekday.contains('星期')) {
        return TextSpan(
          text: '星期',
          style: StylesLibrary.ts_333333_20sp_medium,
          children: [
            TextSpan(
              text: weekday.replaceAll('星期', ''),
              style: StylesLibrary.ts_333333_12sp_medium,
            ),
          ],
        );
      }
      return TextSpan(
          text: weekday, style: StylesLibrary.ts_333333_20sp_medium);
    }

    // if (DateUtil.yearIsEqualByMs(ms, locTimeMs)) {
    //   final date = MitiUtils.formatDateMs(ms, format: 'MM月dd');
    //   final one = date.split('月')[0];
    //   final two = date.split('月')[1];
    //   return TextSpan(
    //     text: two,
    //     style: StylesLibrary.ts_333333_17sp_medium,
    //     children: [
    //       TextSpan(
    //         text: '\n$one${languageCode == 'zh' ? '月' : ''}',
    //         style: StylesLibrary.ts_333333_12sp_medium,
    //       ),
    //     ],
    //   );
    // }
    final date = MitiUtils.formatDateMs(ms, format: 'MM月dd');
    final one = date.split('月')[0];
    final two = date.split('月')[1];
    return TextSpan(
      text: '${int.parse(two)}',
      style: StylesLibrary.ts_333333_20sp_medium,
      children: [
        TextSpan(
          text: '${int.parse(one)}${languageCode == 'zh' ? '月' : ''}',
          style: StylesLibrary.ts_333333_12sp_medium,
        ),
      ],
    );
  }

  static Future<String?> showCountryCodePicker() async {
    Completer<String> completer = Completer();
    showCountryPicker(
      context: Get.context!,
      showPhoneCode: true,
      // exclude: <String>['CN'],
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 16.sp, color: Colors.blueGrey),
        bottomSheetHeight: 500.h,
        // Optional. Country list modal height
        //Optional. Sets the border radius for the bottomsheet.
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0.r),
          topRight: Radius.circular(8.0.r),
        ),
        //Optional. StylesLibrary the search field.
        inputDecoration: InputDecoration(
          labelText: StrLibrary.search,
          // hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
      onSelect: (Country country) {
        completer.complete("+${country.phoneCode}");
      },
    );
    return completer.future;
  }

  static void showSinglePicker({
    required String title,
    required String description,
    required dynamic pickerData,
    bool isArray = false,
    List<int>? selected,
    Function(List<int> indexList, List valueList)? onConfirm,
  }) async {
    final picker = Picker(
        adapter: PickerDataAdapter<String>(
          pickerData: pickerData,
          isArray: isArray,
        ),
        changeToFirst: true,
        hideHeader: true,
        containerColor: StylesLibrary.c_FFFFFF,
        textStyle: StylesLibrary.ts_333333_17sp,
        selectedTextStyle: StylesLibrary.ts_333333_17sp,
        itemExtent: 45.h,
        cancelTextStyle: StylesLibrary.ts_333333_17sp,
        confirmTextStyle: StylesLibrary.ts_8443F8_17sp,
        cancelText: StrLibrary.cancel,
        confirmText: StrLibrary.confirm,
        selecteds: selected,
        selectionOverlay: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: BorderDirectional(
              bottom: BorderSide(color: StylesLibrary.c_E8EAEF, width: 1.h),
              top: BorderSide(color: StylesLibrary.c_E8EAEF, width: 1.h),
            ),
          ),
        )).getInstance();

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
                  title,
                  textAlign: TextAlign.center,
                  style: StylesLibrary.ts_333333_16sp_medium,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 16.w,
                ),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: StylesLibrary.ts_333333_14sp,
                ),
              ),
              picker.widget!
            ],
          )),
    ));
    if (confirm) {
      onConfirm?.call(picker.selecteds, picker.getSelectedValues());
    }
  }

  static void openChangeMitiIDSheet({
    required String mitiID,
    required RxBool agree,
    required Function() onSubmit,
    required Function() onTapRule,
    required Function(bool? newValue) onChangeAgree,
  }) {
    Get.bottomSheet(
      barrierColor: StylesLibrary.c_191919_opacity50,
      backgroundColor: StylesLibrary.c_FFFFFF,
      Container(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
        width: 1.sw,
        child: Obx(() => Column(
              children: [
                StrLibrary.newMitiID.toText
                  ..style = StylesLibrary.ts_333333_16sp
                  ..textAlign = TextAlign.center,
                10.verticalSpace,
                mitiID.toText
                  ..style = StylesLibrary.ts_333333_18sp_medium
                  ..textAlign = TextAlign.center,
                10.verticalSpace,
                StrLibrary.newMitiIDRule.toText
                  ..style = StylesLibrary.ts_333333_16sp
                  ..textAlign = TextAlign.center,
                Spacer(),
                Row(
                  children: [
                    Checkbox(
                      value: agree.value,
                      onChanged: onChangeAgree,
                    ),
                    Expanded(child: RichText(
                          // textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: StrLibrary.agreeChangeMitiID1,
                                style: StylesLibrary.ts_333333_16sp),
                            TextSpan(
                                text: StrLibrary.openAngleBracket,
                                style: StylesLibrary.ts_333333_16sp),
                            TextSpan(
                                text: StrLibrary.agreeChangeMitiID2,
                                style: StylesLibrary.ts_333333_16sp),
                            TextSpan(
                              text: StrLibrary.agreeChangeMitiID3,
                              style: StylesLibrary.ts_8443F8_16sp,
                              recognizer: TapGestureRecognizer()
                                ..onTap = onTapRule,
                            ),
                            TextSpan(
                                text: StrLibrary.closeAngleBracket,
                                style: StylesLibrary.ts_333333_16sp),
                          ])),
                    )
                  ],
                ),
                10.verticalSpace,
                Button(
                  width: 150.w,
                  text: StrLibrary.submit,
                  onTap: onSubmit,
                  enabled: agree.value,
                )
              ],
            )),
      ),
    );
  }
}
