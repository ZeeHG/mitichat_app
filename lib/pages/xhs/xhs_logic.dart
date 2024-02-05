import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

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
  final activeCategory = "推荐".obs;
  final categoryList = ["推荐", "视频", "户外", "相机", "汽车", "时尚", "动漫"].obs;
  final articleList = <dynamic>[
    {
      "title": "标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题",
      "content": "内容ddd",
      "splash": "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      "likeCount": "15.7万",
      "user": {
        "name": "小明",
        "avatar":
            "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      }
    },
    {
      "title": "标题",
      "content": "内容",
      "splash": "https://img0.baidu.com/it/u=104573412,694169124&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=777",
      "likeCount": "15.7万",
      "user": {
        "name": "小明",
        "avatar":
            "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      }
    },
    {
      "title": "标题",
      "content": "内容",
      "splash": "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      "likeCount": "15.7万",
      "user": {
        "name": "小明",
        "avatar":
            "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      }
    },
    {
      "title": "标题",
      "content": "内容",
      "splash": "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      "likeCount": "15.7万",
      "user": {
        "name": "小明",
        "avatar":
            "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      }
    },
    {
      "title": "标题",
      "content": "内容",
      "splash": "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      "likeCount": "15.7万",
      "user": {
        "name": "小明",
        "avatar":
            "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      }
    },
    {
      "title": "标题",
      "content": "内容",
      "splash": "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      "likeCount": "15.7万",
      "user": {
        "name": "小明",
        "avatar":
            "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      }
    },
    {
      "title": "标题",
      "content": "内容",
      "splash": "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      "likeCount": "15.7万",
      "user": {
        "name": "小明",
        "avatar":
            "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      }
    },
    {
      "title": "标题",
      "content": "内容",
      "splash": "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      "likeCount": "15.7万",
      "user": {
        "name": "小明",
        "avatar":
            "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      }
    },
    {
      "title": "标题",
      "content": "内容",
      "splash": "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      "likeCount": "15.7万",
      "user": {
        "name": "小明",
        "avatar":
            "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      }
    },{
      "title": "标题",
      "content": "内容",
      "splash": "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      "likeCount": "15.7万",
      "user": {
        "name": "小明",
        "avatar":
            "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      }
    },
    {
      "title": "标题",
      "content": "内容",
      "splash": "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      "likeCount": "15.7万",
      "user": {
        "name": "小明",
        "avatar":
            "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      }
    },
    {
      "title": "标题",
      "content": "内容",
      "splash": "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      "likeCount": "15.7万",
      "user": {
        "name": "小明",
        "avatar":
            "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      }
    },
    {
      "title": "标题",
      "content": "内容",
      "splash": "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      "likeCount": "15.7万",
      "user": {
        "name": "小明",
        "avatar":
            "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      }
    },
    {
      "title": "标题",
      "content": "内容",
      "splash": "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      "likeCount": "15.7万",
      "user": {
        "name": "小明",
        "avatar":
            "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      }
    },
    {
      "title": "标题",
      "content": "内容",
      "splash": "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      "likeCount": "15.7万",
      "user": {
        "name": "小明",
        "avatar":
            "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
      }
    }
  ].obs;

  clickCategory(String value) {
    activeCategory.value = value;
  }

  switchHeaderIndex(int i) => headerIndex.value = i;

  search() {}
}
