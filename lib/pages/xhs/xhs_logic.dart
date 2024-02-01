import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class XhsLogic extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  final headerIndex = 0.obs;
  final categoryList = ["推荐1", "视频", "户外", "相机", "汽车", "时尚", "推荐",
    "视频",
    "户外",
    "相机",
    "汽车",
    "时尚"
  ,
    "推荐",
    "视频",
    "户外",
    "相机",
    "汽车",
    "时尚"
  ,
    "推荐",
    "视频",
    "户外",
    "相机",
    "汽车",
    "时尚"
  ].obs;

  switchHeaderIndex(int i) => headerIndex.value = i;

  search() {}
}
