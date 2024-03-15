import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../core/controller/im_ctrl.dart';

class DiscoverLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
  final ScrollController scrollController = ScrollController();
  final RxDouble scrollHeight = 0.0.obs;

  final moments = <Moment>[
    Moment(
        nickname: "昵称1",
        content:
            "测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试",
        likes: "用户1",
        time: "2022-01-01",
        comments: [
          Comment(
              nickname: "用户1",
              content:
                  "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
          Comment(
              nickname: "用户1",
              content:
                  "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容")
        ]),
    Moment(
        nickname: "昵称2",
        content: "测试测试",
        time: "2022-01-01",
        likes:
            "用户1, 用户2, 用户1, 用户2, 用户2, 用户1, 用户2, 用户2, 用户1, 用户2, 用户2, 用户1, 用户2",
        comments: [
          Comment(
              nickname: "用户1",
              content:
                  "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
          Comment(
              nickname: "用户1",
              content:
                  "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容")
        ]),
    Moment(
        nickname: "昵称3",
        content: "测试测",
        time: "2022-01-01",
        likes: "用户1, 用户2",
        comments: [
          Comment(
              nickname: "用户1",
              content:
                  "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"),
          Comment(
              nickname: "用户1",
              content:
                  "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容")
        ]),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    scrollHeight.value = scrollController.offset;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

class Moment {
  String nickname;
  String content;
  String time;
  String likes;
  List<Comment> comments;

  Moment({
    required this.nickname,
    required this.content,
    required this.time,
    required this.likes,
    required this.comments,
  });
}

class Comment {
  String nickname;
  String content;

  Comment({
    required this.nickname,
    required this.content,
  });
}
