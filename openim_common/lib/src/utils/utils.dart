import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:azlistview/azlistview.dart';
import 'package:collection/collection.dart';
import 'package:common_utils/common_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_date/dart_date.dart';
import 'package:extended_image/extended_image.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:openim_common/openim_common.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_browser/page/custom_page.dart';
import 'package:photo_browser/photo_browser.dart';
import 'package:sprintf/sprintf.dart';
import 'package:uri_to_file/uri_to_file.dart';

import '../widgets/chat/chat_preview_merge_message.dart';

/// 间隔时间完成某事
class IntervalDo {
  DateTime? last;
  Timer? lastTimer;

  //call---milliseconds---call
  void run({required Function() fuc, int milliseconds = 0}) {
    DateTime now = DateTime.now();
    if (null == last ||
        now.difference(last ?? now).inMilliseconds > milliseconds) {
      last = now;
      fuc();
    }
  }

  //---milliseconds----milliseconds....---call  在milliseconds时连续的调用会被丢弃并重置milliseconds的时间，milliseconds后才会call
  void drop({required Function() fun, int milliseconds = 0}) {
    lastTimer?.cancel();
    lastTimer = null;
    lastTimer = Timer(Duration(milliseconds: milliseconds), () {
      lastTimer!.cancel();
      lastTimer = null;
      fun.call();
    });
  }
}

class MediaSource {
  final String url;
  final String thumbnail;

  MediaSource(this.url, this.thumbnail);
}

class IMUtils {
  IMUtils._();

  static Future<CroppedFile?> uCrop(String path) {
    return ImageCropper().cropImage(
      sourcePath: path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: Styles.c_8443F8,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: '',
        ),
      ],
    );
  }

  static String getSuffix(String url) {
    if (!url.contains(".")) return "";
    return url.substring(url.lastIndexOf('.'), url.length);
  }

  static bool isGif(String url) {
    return IMUtils.getSuffix(url).contains("gif");
  }

  static void copy({required String text}) {
    Clipboard.setData(ClipboardData(text: text));
    IMViews.showToast(StrLibrary.copySuccessfully);
  }

  static List<ISuspensionBean> convertToAZList(List<ISuspensionBean> list) {
    for (int i = 0, length = list.length; i < length; i++) {
      setAzPinyinAndTag(list[i]);
    }
    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(list);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(list);

    // add topList.
    // contactsList.insertAll(0, topList);
    return list;
  }

  static ISuspensionBean setAzPinyinAndTag(ISuspensionBean info) {
    if (info is ISUserInfo) {
      String pinyin = PinyinHelper.getPinyinE(info.showName);
      if (pinyin.trim().isEmpty) {
        info.tagIndex = "#";
      } else {
        String tag = pinyin.substring(0, 1).toUpperCase();
        info.namePinyin = pinyin.toUpperCase();
        if (RegExp("[A-Z]").hasMatch(tag)) {
          info.tagIndex = tag;
        } else {
          info.tagIndex = "#";
        }
      }
    } else if (info is ISGroupMembersInfo) {
      String pinyin = PinyinHelper.getPinyinE(info.nickname!);
      if (pinyin.trim().isEmpty) {
        info.tagIndex = "#";
      } else {
        String tag = pinyin.substring(0, 1).toUpperCase();
        info.namePinyin = pinyin.toUpperCase();
        if (RegExp("[A-Z]").hasMatch(tag)) {
          info.tagIndex = tag;
        } else {
          info.tagIndex = "#";
        }
      }
    }
    return info;
  }

  static saveMediaToGallery(String mimeType, String cachePath) async {
    if (mimeType.contains('video') || mimeType.contains('image')) {
      await ImageGallerySaver.saveFile(cachePath);
    }
  }

  static String? emptyStrToNull(String? str) =>
      (null != str && str.trim().isEmpty) ? null : str;

  static bool isNotNullEmptyStr(String? str) => null != str && "" != str.trim();

  static bool isChinaMobile(String mobile) {
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    return exp.hasMatch(mobile);
  }

  static bool isMobile(String areaCode, String mobile) =>
      (areaCode == '+86' || areaCode == '86') ? isChinaMobile(mobile) : true;

  /// 获取视频缩略图
  static Future<File> getVideoThumbnail(File file) async {
    final path = file.path;
    final names = path.substring(path.lastIndexOf("/") + 1).split('.');
    final name = '${names.first}.png';
    final directory = await createTempDir(dir: 'video');
    final targetPath = '$directory/$name';

    final String ffmpegCommand =
        '-i $path -ss 0 -vframes 1 -q:v 15 -y $targetPath';
    final session = await FFmpegKit.execute(ffmpegCommand);

    final state =
        FFmpegKitConfig.sessionStateToString(await session.getState());
    final returnCode = await session.getReturnCode();

    if (state == SessionState.failed || !ReturnCode.isSuccess(returnCode)) {
      Logger().printError(
          info: "Command failed. Please check output for the details.");
    }

    session.cancel();

    return File(targetPath);
  }

  ///  compress video
  static Future<File?> compressVideoAndGetFile(File file) async {
    final path = file.path;
    final name = path.substring(path.lastIndexOf("/") + 1);
    final directory = await createTempDir(dir: 'video');
    final targetPath = '$directory/$name';

    final output = await FFprobeKit.getMediaInformation(path);
    final streams = output.getMediaInformation()?.getStreams();
    final isH264 = streams
            ?.any((element) => element.getCodec()?.contains('h264') == true) ??
        false;
    final size = output.getMediaInformation()?.getSize() ?? '0';
    output.cancel();

    if (File(targetPath).existsSync() && isH264) {
      return File(targetPath);
    }
    // By default, everything below 1024M is uncompressed. If you want to compress it, you can change the value size.
    if (int.parse(size) < 1024 * 1024 * 1024 && isH264) {
      file.copySync(targetPath);

      return File(targetPath);
    }
    // Compression is time consuming.
    // -i ${file.path} -preset fast -vf scale=-2:720 -crf 10 -strict experimental -b:a 192k -b:v 1000k $targetPath
    final String ffmpegCommand =
        '-i ${file.path} -preset fast -vf scale=-2:720 -crf 10 -strict experimental -b:a 192k -b:v 1000k $targetPath';
    final session = await FFmpegKit.execute(ffmpegCommand);

    final state =
        FFmpegKitConfig.sessionStateToString(await session.getState());
    final returnCode = await session.getReturnCode();

    if (state == SessionState.failed || !ReturnCode.isSuccess(returnCode)) {
      Logger().printError(
          info: "Command failed. Please check output for the details.");
      file.copySync(targetPath);

      return File(targetPath);
    }

    session.cancel();

    return File(targetPath);
  }

  ///  compress file and get file.
  static Future<File?> compressImageAndGetFile(File file,
      {int quality = 80}) async {
    var path = file.path;
    var name = path.substring(path.lastIndexOf("/") + 1);
    var targetPath = await createTempFile(name: name, dir: 'pic');
    if (name.endsWith('.gif')) {
      return file;
    }

    CompressFormat format = CompressFormat.jpeg;
    if (name.endsWith(".jpg") || name.endsWith(".jpeg")) {
      format = CompressFormat.jpeg;
    } else if (name.endsWith(".png")) {
      format = CompressFormat.png;
    } else if (name.endsWith(".heic")) {
      format = CompressFormat.heic;
    } else if (name.endsWith(".webp")) {
      format = CompressFormat.webp;
    }

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      minWidth: 480,
      minHeight: 800,
      // minHeight: 1920,
      // minWidth: 1080,
      format: format,
    );
    return result != null ? File(result.path) : file;
  }

  static Future<String> createTempFile({
    required String dir,
    required String name,
  }) async {
    final storage = await createTempDir(dir: dir);
    File file = File('$storage/$name');
    if (!(await file.exists())) {
      file.create();
    }
    return file.path;
  }

  static Future<String> createTempDir({
    required String dir,
  }) async {
    final storage = (Platform.isIOS
        ? await getApplicationCacheDirectory()
        : await getExternalStorageDirectory());
    Directory directory = Directory('${storage!.path}/$dir');
    if (!(await directory.exists())) {
      directory.create(recursive: true);
    }
    return directory.path;
  }

  static int compareVersion(String val1, String val2) {
    var arr1 = val1.split(".");
    var arr2 = val2.split(".");
    int length = arr1.length >= arr2.length ? arr1.length : arr2.length;
    int diff = 0;
    int v1;
    int v2;
    for (int i = 0; i < length; i++) {
      v1 = i < arr1.length ? int.parse(arr1[i]) : 0;
      v2 = i < arr2.length ? int.parse(arr2[i]) : 0;
      diff = v1 - v2;
      if (diff == 0) {
        continue;
      } else {
        return diff > 0 ? 1 : -1;
      }
    }
    return diff;
  }

  static int getPlatform() {
    final context = Get.context!;
    if (Platform.isAndroid) {
      return context.isTablet ? 8 : 2;
    } else {
      return context.isTablet ? 9 : 1;
    }
  }

  // md5 加密
  static String? generateMD5(String? data) {
    if (null == data) return null;
    var content = const Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }

  static String buildGroupApplicationID(GroupApplicationInfo info) {
    return '${info.groupID}-${info.creatorUserID}-${info.reqTime}-${info.userID}--${info.inviterUserID}';
  }

  static String buildFriendApplicationID(FriendApplicationInfo info) {
    /// 1686566803245 1686727472913
    return '${info.fromUserID}-${info.toUserID}-${info.createTime}';
  }

  static Future<String> getCacheFileDir() async {
    return (await getTemporaryDirectory()).absolute.path;
  }

  static Future<String> getDownloadFileDir() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        // externalStorageDirPath = await AndroidPathProvider.downloadsPath;
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      } catch (err, st) {
        Logger.print('failed to get downloads path: $err, $st');
        myLogger.e({"message": "获取下载目录异常", "error": err, "stack": st});
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath!;
  }

  static Future<String> toFilePath(String path) async {
    var filePrefix = 'file://';
    var uriPrefix = 'content://';
    if (path.contains(filePrefix)) {
      path = path.substring(filePrefix.length);
    } else if (path.contains(uriPrefix)) {
      // Uri uri = Uri.parse(thumbnailPath); // Parsing uri string to uri
      File file = await toFile(path);
      path = file.path;
    }
    return path;
  }

  /// 消息列表超过5分钟则显示时间
  static List<Message> calChatTimeInterval(List<Message> list,
      {bool calculate = true}) {
    if (!calculate) return list;
    var milliseconds = list.firstOrNull?.sendTime;
    if (null == milliseconds) return list;
    list.first.exMap['showTime'] = true;
    var lastShowTimeStamp = milliseconds;
    for (var i = 0; i < list.length; i++) {
      var index = i + 1;
      if (index <= list.length - 1) {
        var cur = getDateTimeByMs(lastShowTimeStamp);
        var milliseconds = list.elementAt(index).sendTime!;
        var next = getDateTimeByMs(milliseconds);
        if (next.difference(cur).inMinutes > 5) {
          lastShowTimeStamp = milliseconds;
          list.elementAt(index).exMap['showTime'] = true;
        }
      }
    }
    return list;
  }

  static String getChatTimeline(int ms, [String formatToday = 'HH:mm']) {
    final locTimeMs = DateTime.now().millisecondsSinceEpoch;
    final languageCode = Get.locale?.languageCode ?? 'zh';
    final isZH = languageCode == 'zh';

    if (DateUtil.isToday(ms, locMs: locTimeMs)) {
      return formatDateMs(ms, format: formatToday);
    }

    if (DateUtil.isYesterdayByMs(ms, locTimeMs)) {
      return '${isZH ? '昨天' : 'Yesterday'} ${formatDateMs(ms, format: 'HH:mm')}';
    }

    if (DateUtil.isWeek(ms, locMs: locTimeMs)) {
      return '${DateUtil.getWeekdayByMs(ms, languageCode: languageCode)} ${formatDateMs(ms, format: 'HH:mm')}';
    }

    if (DateUtil.yearIsEqualByMs(ms, locTimeMs)) {
      return formatDateMs(ms, format: isZH ? 'M月d HH:mm' : 'MM/dd HH:mm');
    }

    return formatDateMs(ms, format: isZH ? 'yyyy年M月d' : 'yyyy/MM/dd');
  }

  static String getCallTimeline(int milliseconds) {
    if (DateUtil.yearIsEqualByMs(milliseconds, DateUtil.getNowDateMs())) {
      return formatDateMs(milliseconds, format: 'MM/dd');
    } else {
      return formatDateMs(milliseconds, format: 'yyyy/MM/dd');
    }
  }

  static DateTime getDateTimeByMs(int ms, {bool isUtc = false}) {
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
  }

  static String formatDateMs(int ms, {bool isUtc = false, String? format}) {
    return DateUtil.formatDateMs(ms, format: format, isUtc: isUtc);
  }

  static String seconds2HMS(int seconds) {
    int h = 0;
    int m = 0;
    int s = 0;
    int temp = seconds % 3600;
    if (seconds > 3600) {
      h = seconds ~/ 3600;
      if (temp != 0) {
        if (temp > 60) {
          m = temp ~/ 60;
          if (temp % 60 != 0) {
            s = temp % 60;
          }
        } else {
          s = temp;
        }
      }
    } else {
      m = seconds ~/ 60;
      if (seconds % 60 != 0) {
        s = seconds % 60;
      }
    }
    if (h == 0) {
      return '${m < 10 ? '0$m' : m}:${s < 10 ? '0$s' : s}';
    }
    return "${h < 10 ? '0$h' : h}:${m < 10 ? '0$m' : m}:${s < 10 ? '0$s' : s}";
  }

  /// 消息按时间线分组
  static Map<String, List<Message>> groupingMessage(List<Message> list) {
    var languageCode = Get.locale?.languageCode ?? 'zh';
    var group = <String, List<Message>>{};
    for (var message in list) {
      var dateTime = DateTime.fromMillisecondsSinceEpoch(message.sendTime!);
      String dateStr;
      if (DateUtil.isToday(message.sendTime!)) {
        // 今天
        dateStr = languageCode == 'zh' ? '今天' : 'Today';
      } else if (DateUtil.isWeek(message.sendTime!)) {
        // 本周
        dateStr = languageCode == 'zh' ? '本周' : 'This Week';
      } else if (dateTime.isThisMonth) {
        //当月
        dateStr = languageCode == 'zh' ? '这个月' : 'This Month';
      } else {
        // 按年月
        dateStr = DateUtil.formatDate(dateTime, format: 'yyyy/MM');
      }
      group[dateStr] = (group[dateStr] ?? <Message>[])..add(message);
    }
    return group;
  }

  static String mutedTime(int mss) {
    int days = mss ~/ (60 * 60 * 24);
    int hours = (mss % (60 * 60 * 24)) ~/ (60 * 60);
    int minutes = (mss % (60 * 60)) ~/ 60;
    int seconds = mss % 60;
    return "${_combTime(days, StrLibrary.day)}${_combTime(hours, StrLibrary.hours)}${_combTime(minutes, StrLibrary.minute)}${_combTime(seconds, StrLibrary.seconds)}";
  }

  static String _combTime(int value, String unit) =>
      value > 0 ? '$value$unit' : '';

  /// 搜索聊天内容显示规则
  static String calContent({
    required String content,
    required String key,
    required TextStyle style,
    required double usedWidth,
  }) {
    var size = calculateTextSize(content, style);
    var lave = 1.sw - usedWidth;
    if (size.width < lave) {
      return content;
    }
    var index = content.indexOf(key);
    if (index == -1 || index > content.length - 1) return content;
    var start = content.substring(0, index);
    var end = content.substring(index);
    var startSize = calculateTextSize(start, style);
    var keySize = calculateTextSize(key, style);
    if (startSize.width + keySize.width > lave) {
      if (index - 4 > 0) {
        return "...${content.substring(index - 4)}";
      } else {
        return "...$end";
      }
    } else {
      return content;
    }
  }

  // Here it is!
  static Size calculateTextSize(
    String text,
    TextStyle style, {
    int maxLines = 1,
    double maxWidth = double.infinity,
  }) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: maxLines,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: maxWidth);
    return textPainter.size;
  }

  static TextPainter getTextPainter(
    String text,
    TextStyle style, {
    int maxLines = 1,
    double maxWidth = double.infinity,
  }) =>
      TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: maxLines,
          textDirection: TextDirection.ltr)
        ..layout(minWidth: 0, maxWidth: maxWidth);

  static bool isUrlValid(String? url) {
    if (null == url || url.isEmpty) {
      return false;
    }
    return url.startsWith("http://") || url.startsWith("https://");
  }

  static bool isValidUrl(String? urlString) {
    if (null == urlString || urlString.isEmpty) {
      return false;
    }
    Uri? uri = Uri.tryParse(urlString);
    if (uri != null && uri.hasScheme && uri.hasAuthority) {
      return true;
    }
    return false;
  }

  static String getGroupMemberShowName(GroupMembersInfo membersInfo) {
    return membersInfo.userID == OpenIM.iMManager.userID
        ? StrLibrary.you
        : membersInfo.nickname!;
  }

  static String getShowName(String? userID, String? nickname) {
    return (userID == OpenIM.iMManager.userID
            ? OpenIM.iMManager.userInfo.nickname
            : nickname) ??
        '';
  }

  /// 通知解析
  static String? parseNtf(
    Message message, {
    bool isConversation = false,
  }) {
    String? text;
    try {
      if (message.contentType! >= 1000) {
        final elem = message.notificationElem!;
        final map = json.decode(elem.detail!);
        switch (message.contentType) {
          case MessageType.groupCreatedNotification:
            {
              final ntf = GroupNotification.fromJson(map);
              // a 创建了群聊
              final label = StrLibrary.createGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.groupInfoSetNotification:
            {
              final ntf = GroupNotification.fromJson(map);
              if (ntf.group?.notification != null &&
                  ntf.group!.notification!.isNotEmpty) {
                return isConversation ? ntf.group!.notification! : null;
              }
              // a 修改了群资料
              final label = StrLibrary.editGroupInfoNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.memberQuitNotification:
            {
              final ntf = QuitGroupNotification.fromJson(map);
              // a 退出了群聊
              final label = StrLibrary.quitGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.quitUser!)]);
            }
            break;
          case MessageType.memberInvitedNotification:
            {
              final ntf = InvitedJoinGroupNotification.fromJson(map);
              // a 邀请 b 加入群聊
              final label = StrLibrary.invitedJoinGroupNtf;
              final b = ntf.invitedUserList
                  ?.map((e) => getGroupMemberShowName(e))
                  .toList()
                  .join('、');
              text = sprintf(
                  label, [getGroupMemberShowName(ntf.opUser!), b ?? '']);
            }
            break;
          case MessageType.memberKickedNotification:
            {
              final ntf = KickedGroupMemeberNotification.fromJson(map);
              // b 被 a 踢出群聊
              final label = StrLibrary.kickedGroupNtf;
              final b = ntf.kickedUserList!
                  .map((e) => getGroupMemberShowName(e))
                  .toList()
                  .join('、');
              text = sprintf(label, [b, getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.memberEnterNotification:
            {
              final ntf = EnterGroupNotification.fromJson(map);
              // a 加入了群聊
              final label = StrLibrary.joinGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.entrantUser!)]);
            }
            break;
          case MessageType.dismissGroupNotification:
            {
              final ntf = GroupNotification.fromJson(map);
              // a 解散了群聊
              final label = StrLibrary.dismissGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.groupOwnerTransferredNotification:
            {
              final ntf = GroupRightsTransferNoticication.fromJson(map);
              // a 将群转让给了 b
              final label = StrLibrary.transferredGroupNtf;
              text = sprintf(label, [
                getGroupMemberShowName(ntf.opUser!),
                getGroupMemberShowName(ntf.newGroupOwner!)
              ]);
            }
            break;
          case MessageType.groupMemberMutedNotification:
            {
              final ntf = MuteMemberNotification.fromJson(map);
              // b 被 a 禁言
              final label = StrLibrary.muteMemberNtf;
              final c = ntf.mutedSeconds;
              text = sprintf(label, [
                getGroupMemberShowName(ntf.mutedUser!),
                getGroupMemberShowName(ntf.opUser!),
                mutedTime(c!)
              ]);
            }
            break;
          case MessageType.groupMemberCancelMutedNotification:
            {
              final ntf = MuteMemberNotification.fromJson(map);
              // b 被 a 取消了禁言
              final label = StrLibrary.muteCancelMemberNtf;
              text = sprintf(label, [
                getGroupMemberShowName(ntf.mutedUser!),
                getGroupMemberShowName(ntf.opUser!)
              ]);
            }
            break;
          case MessageType.groupMutedNotification:
            {
              final ntf = MuteMemberNotification.fromJson(map);
              // a 开起了群禁言
              final label = StrLibrary.muteGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.groupCancelMutedNotification:
            {
              final ntf = MuteMemberNotification.fromJson(map);
              // a 关闭了群禁言
              final label = StrLibrary.muteCancelGroupNtf;
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.friendApplicationApprovedNotification:
            {
              // 你们已成为好友
              text = StrLibrary.friendAddedNtf;
            }
            break;
          case MessageType.burnAfterReadingNotification:
            {
              final ntf = BurnAfterReadingNotification.fromJson(map);
              if (ntf.isPrivate == true) {
                text = StrLibrary.openPrivateChatNtf;
              } else {
                text = StrLibrary.closePrivateChatNtf;
              }
            }
            break;
          case MessageType.groupMemberInfoChangedNotification:
            final ntf = GroupMemberInfoChangedNotification.fromJson(map);
            text = sprintf(StrLibrary.memberInfoChangedNtf,
                [getGroupMemberShowName(ntf.opUser!)]);
            break;
          case MessageType.groupInfoSetAnnouncementNotification:
            if (isConversation) {
              final ntf = GroupNotification.fromJson(map);
              text = ntf.group?.notification ?? '';
            }
            break;
          case MessageType.groupInfoSetNameNotification:
            final ntf = GroupNotification.fromJson(map);
            text = sprintf(StrLibrary.whoModifyGroupName,
                [getGroupMemberShowName(ntf.opUser!)]);
            break;
        }
      }
    } catch (e, s) {
      Logger.print('Exception details:\n $e');
      Logger.print('Stack trace:\n $s');
    }
    return text;
  }

  /// 通知detail解析为map, 后续需要根据contentType具体转换
  static Map<String, dynamic>? parseNtfMap(Message message) {
    Map<String, dynamic>? map;
    try {
      if (message.contentType! >= 1000) {
        final elem = message.notificationElem!;
        map = json.decode(elem.detail!);
      }
    } catch (e, s) {
      myLogger.e({
        "message": "parseNtfMap通知detail转换出错",
        "data": message.toJson(),
        "error": e,
        "stack": s
      });
    }
    return map;
  }

  static String parseMsg(
    Message message, {
    bool isConversation = false,
    bool replaceIdToNickname = false,
  }) {
    String? content;
    try {
      switch (message.contentType) {
        case MessageType.text:
          content = message.textElem!.content!;
          break;
        case MessageType.atText:
          content = message.atTextElem!.text!;
          if (replaceIdToNickname) {
            var list = message.atTextElem?.atUsersInfo;
            list?.forEach((e) {
              content = content?.replaceAll(
                '@${e.atUserID}',
                '@${getAtNickname(e.atUserID!, e.groupNickname!)}',
              );
            });
          }
          break;
        case MessageType.picture:
          content = '[${StrLibrary.picture}]';
          break;
        case MessageType.voice:
          content = '[${StrLibrary.voice}]';
          break;
        case MessageType.video:
          content = '[${StrLibrary.video}]';
          break;
        case MessageType.file:
          content = '[${StrLibrary.file}]';
          break;
        case MessageType.location:
          content = '[${StrLibrary.location}]';
          break;
        case MessageType.merger:
          content = '[${StrLibrary.chatRecord}]';
          break;
        case MessageType.card:
          content = '[${StrLibrary.carte}]';
          break;
        case MessageType.quote:
          content = message.quoteElem?.text ?? '';
          break;
        case MessageType.revokeMessageNotification:
          var isSelf = message.sendID == OpenIM.iMManager.userID;
          var map = json.decode(message.notificationElem!.detail!);
          var info = RevokedInfo.fromJson(map);
          if (message.isSingleChat) {
            // 单聊
            if (isSelf) {
              content = '${StrLibrary.you} ${StrLibrary.revokeMsg}';
            } else {
              content = '${message.senderNickname} ${StrLibrary.revokeMsg}';
            }
          } else {
            // 群聊撤回包含：撤回自己消息，群组或管理员撤回其他人消息
            if (info.revokerID == info.sourceMessageSendID) {
              if (isSelf) {
                content = '${StrLibrary.you} ${StrLibrary.revokeMsg}';
              } else {
                content = '${message.senderNickname} ${StrLibrary.revokeMsg}';
              }
            } else {
              late String revoker;
              late String sender;
              if (info.revokerID == OpenIM.iMManager.userID) {
                revoker = StrLibrary.you;
              } else {
                revoker = info.revokerNickname!;
              }
              if (info.sourceMessageSendID == OpenIM.iMManager.userID) {
                sender = StrLibrary.you;
              } else {
                sender = info.sourceMessageSenderNickname!;
              }

              content = sprintf(StrLibrary.aRevokeBMsg, [revoker, sender]);
            }
          }
          break;
        case MessageType.customFace:
          content = '[${StrLibrary.emoji}]';
          break;
        case MessageType.custom:
          var data = message.customElem!.data;
          var map = json.decode(data!);
          var customType = map['customType'];
          var customData = map['data'];
          switch (customType) {
            case CustomMessageType.call:
              var type = map['data']['type'];
              content =
                  '[${type == 'video' ? StrLibrary.callVideo : StrLibrary.callVoice}]';
              break;
            case CustomMessageType.emoji:
              content = '[${StrLibrary.emoji}]';
              break;
            case CustomMessageType.tag:
              if (null != customData['textElem']) {
                final textElem = TextElem.fromJson(customData['textElem']);
                content = textElem.content;
              } else if (null != customData['soundElem']) {
                // final soundElem = SoundElem.fromJson(customData['soundElem']);
                content = '[${StrLibrary.voice}]';
              } else {
                content = '[${StrLibrary.unsupportedMessage}]';
              }
              break;
            // case CustomMessageType.meeting:
            //   content = '[${StrLibrary .meetingMessage}]';
            //   break;
            case CustomMessageType.blockedByFriend:
              content = StrLibrary.blockedByFriendHint;
              break;
            case CustomMessageType.deletedByFriend:
              content = sprintf(
                StrLibrary.deletedByFriendHint,
                [''],
              );
              break;
            case CustomMessageType.removedFromGroup:
              content = StrLibrary.removedFromGroupHint;
              break;
            case CustomMessageType.groupDisbanded:
              content = StrLibrary.groupDisbanded;
              break;
            case CustomMessageType.waitingAiReplay:
              // content = CustomMessageContent.waitingAiReplay;
              break;
            default:
              content = '[${StrLibrary.unsupportedMessage}]';
              break;
          }
          break;
        case MessageType.oaNotification:
          // OA通知
          String detail = message.notificationElem!.detail!;
          var oa = OANotification.fromJson(json.decode(detail));
          content = oa.text!;
          break;
        default:
          content = '[${StrLibrary.unsupportedMessage}]';
          break;
      }
    } catch (e, s) {
      Logger.print('Exception details:\n $e');
      Logger.print('Stack trace:\n $s');
    }
    content = content?.replaceAll("\n", " ");
    return content ?? '[${StrLibrary.unsupportedMessage}]';
  }

  static dynamic parseCustomMessage(Message message) {
    try {
      switch (message.contentType) {
        case MessageType.custom:
          {
            var data = message.customElem!.data;
            var map = json.decode(data!);
            var customType = map['customType'];
            switch (customType) {
              case CustomMessageType.call:
                {
                  final duration = map['data']['duration'];
                  final state = map['data']['state'];
                  final type = map['data']['type'];
                  String? content;
                  switch (state) {
                    case 'beHangup':
                    case 'hangup':
                      content = sprintf(
                          StrLibrary.callDuration, [seconds2HMS(duration)]);
                      break;
                    case 'cancel':
                      content = StrLibrary.cancelled;
                      break;
                    case 'beCanceled':
                      content = StrLibrary.cancelledByCaller;
                      break;
                    case 'reject':
                      content = StrLibrary.rejected;
                      break;
                    case 'beRejected':
                      content = StrLibrary.rejectedByCaller;
                      break;
                    case 'timeout':
                      content = StrLibrary.callTimeout;
                      break;
                    case 'networkError':
                      content = StrLibrary.networkAnomaly;
                      break;
                    default:
                      break;
                  }
                  if (content != null) {
                    return {
                      'viewType': CustomMessageType.call,
                      'type': type,
                      'content': content,
                    };
                  }
                }
                break;
              case CustomMessageType.emoji:
                map['data']['viewType'] = CustomMessageType.emoji;
                return map['data'];
              case CustomMessageType.tag:
                map['data']['viewType'] = CustomMessageType.tag;
                return map['data'];
              // case CustomMessageType.meeting:
              //   map['data']['viewType'] = CustomMessageType.meeting;
              //   return map['data'];
              case CustomMessageType.deletedByFriend:
              case CustomMessageType.blockedByFriend:
              case CustomMessageType.removedFromGroup:
              case CustomMessageType.groupDisbanded:
                return {'viewType': customType};
            }
          }
      }
    } catch (e, s) {
      Logger.print('Exception details:\n $e');
      Logger.print('Stack trace:\n $s');
    }
    return null;
  }

  static Map<String, String> getAtMapping(
    Message message,
    Map<String, String> newMapping,
  ) {
    final mapping = <String, String>{};
    try {
      if (message.contentType == MessageType.atText) {
        var list = message.atTextElem!.atUsersInfo;
        list?.forEach((e) {
          final userID = e.atUserID!;
          final groupNickname =
              newMapping[userID] ?? e.groupNickname ?? e.atUserID!;
          mapping[userID] = getAtNickname(userID, groupNickname);
        });
      }
    } catch (_) {}
    return mapping;
  }

  static String getAtNickname(String atUserID, String atNickname) {
    // String nickname = atNickname;
    // if (atUserID == OpenIM.iMManager.uid) {
    //   nickname = StrLibrary .you;
    // } else if (atUserID == 'atAllTag') {
    //   nickname = StrLibrary .everyone;
    // }
    return atUserID == 'atAllTag' ? StrLibrary.everyone : atNickname;
  }

  static void previewUrlPicture(
    List<MediaSource> sources, {
    int currentIndex = 0,
    String? heroTag,
  }) =>
      navigator?.push(TransparentRoute(
        builder: (BuildContext context) => GestureDetector(
          onTap: () => Get.back(),
          child: ChatPicturePreview(
            currentIndex: currentIndex,
            images: sources,
            heroTag: heroTag,
            onLongPress: (url) {
              IMViews.openDownloadSheet(
                url,
                onDownload: () => HttpUtil.saveUrlPicture(url),
              );
            },
          ),
        ),
      ));

  /*Get.to(
        () => ChatPicturePreview(
          currentIndex: currentIndex,
          images: urls,
          // heroTag: message.clientMsgID,
          heroTag: urls.elementAt(currentIndex),
          onLongPress: (url) {
            IMViews.openDownloadSheet(
              url,
              onDownload: () => HttpUtil.saveUrlPicture(url),
            );
          },
        ),
        // opaque: false,
        transition: Transition.cupertino,
        // popGesture: true,
        // fullscreenDialog: true,
      );*/

  static void previewCustomFace(Message message) {
    final face = message.faceElem;
    final map = json.decode(face!.data!);
    final urls = <String>[map['url']];
    // previewUrlPicture(urls);
    Get.to(
      () => ChatFacePreview(url: map['url']),
      popGesture: true,
      transition: Transition.cupertino,
    );
  }

  static void previewPicture(
    Message message, {
    List<Message> allList = const [],
  }) {
    if (allList.isEmpty) {
      // 不在使用，直接在chatview中
      previewUrlPicture(
        [
          MediaSource(message.pictureElem!.sourcePicture!.url!,
              message.pictureElem!.snapshotPicture!.url!)
        ],
        currentIndex: 0,
      );
    } else {
      final picList = allList
          .where((element) =>
              element.contentType == MessageType.picture ||
              element.contentType == MessageType.video)
          .toList();
      final index = picList.indexOf(message);
      final urls = picList.map((e) {
        if (e.contentType == MessageType.picture) {
          return MediaSource(e.pictureElem!.sourcePicture!.url!,
              e.pictureElem!.snapshotPicture!.url!);
        } else {
          return MediaSource(e.videoElem!.videoUrl!, e.videoElem!.snapshotUrl!);
        }
      }).toList();
      previewUrlPicture(urls, currentIndex: index == -1 ? 0 : index);
    }
  }

  static void previewVideo(Message message) {
    navigator!.push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ChatVideoPlayerView(
            path: message.videoElem?.videoPath,
            url: message.videoElem?.videoUrl,
            coverUrl: message.videoElem?.snapshotUrl,
            heroTag: null,
            oDownload: (url) => HttpUtil.saveUrlVideo(url!),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOut;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        opaque: false));
  }

  static void previewFile(Message message) async {
    final fileElem = message.fileElem;
    if (null != fileElem) {
      final sourcePath = fileElem.filePath;
      final url = fileElem.sourceUrl;
      final fileName = fileElem.fileName;
      final fileSize = fileElem.fileSize;
      final dir = await getDownloadFileDir();
      final cachePath = '$dir/${message.clientMsgID}_$fileName';
      Logger.print('cachePath:$cachePath');
      // 原路径
      final isExitSourcePath = await isExitFile(sourcePath);
      // 自己下载保存路径
      final isExitCachePath = await isExitFile(cachePath);
      // 网络地址
      final isExitNetwork = isUrlValid(url);
      String? availablePath;
      if (isExitSourcePath) {
        availablePath = sourcePath;
      } else if (isExitCachePath) {
        availablePath = cachePath;
      }
      final isAvailableFileSize = isExitSourcePath || isExitCachePath
          ? (await File(availablePath!).length() == fileSize)
          : false;
      Logger.print(
          'previewFile isAvailableFileSize: $isAvailableFileSize   isExitNetwork: $isExitNetwork');
      if (isAvailableFileSize) {
        String? mimeType = lookupMimeType(fileName ?? '');
        if (null != mimeType && mimeType.contains('video')) {
          previewVideo(Message()
            ..clientMsgID = message.clientMsgID
            ..contentType = MessageType.video
            ..videoElem = VideoElem(videoPath: availablePath, videoUrl: url));
        } else if (null != mimeType && mimeType.contains('image')) {
          previewPicture(Message()
            ..clientMsgID = message.clientMsgID
            ..contentType = MessageType.picture
            ..pictureElem = PictureElem(
                sourcePath: availablePath,
                sourcePicture: PictureInfo(url: url)));
        } else {
          openFileByOtherApp(availablePath);
        }
      } else {
        if (isExitNetwork) {
          if (Get.isRegistered<DownloadController>()) {
            final controller = Get.find<DownloadController>();
            controller.clickFileMessage(url!, cachePath);
          }
        }
      }
    }
  }

  static Future previewMediaFile(
      {required BuildContext context,
      required int currentIndex,
      required List<Message> mediaMessages,
      bool muted = false,
      bool Function(int)? onAutoPlay,
      ValueChanged<int>? onPageChanged,
      ValueChanged<OperateType>? onOperate}) {
    late PhotoBrowser photoBrowser;

    void showBottomBar(int index) {
      if (onOperate == null) {
        return;
      }
      PhotoBrowserBottomBar.show(
        context,
        onPressedButton: (type) async {
          final msg = mediaMessages[index];
          switch (type) {
            case OperateType.save:
              if (msg.isVideoType) {
                final cachedVideoControllerService =
                    CachedVideoControllerService(DefaultCacheManager());
                final cached = await cachedVideoControllerService
                    .getCacheFile(msg.videoElem!.videoUrl!);

                if (cached != null) {
                  HttpUtil.saveFileToGallerySaver(cached);
                } else {
                  HttpUtil.saveUrlVideo(msg.videoElem!.videoUrl!);
                }
              } else {
                final url = msg.pictureElem?.sourcePicture?.url;
                if (url?.isNotEmpty == true) {
                  HttpUtil.saveUrlPicture(url!);
                }
              }
              break;
            case OperateType.forward:
              onOperate.call(type);
              break;
          }
        },
      );
    }

    Positioned buildCloseBtn(BuildContext context) {
      return Positioned(
        right: 15,
        top: MediaQuery.of(context).padding.top + 10,
        child: GestureDetector(
          onTap: () {
            // Pop through controller
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 32,
          ),
        ),
      );
    }

    Positioned buildSaveImageBtn(
        BuildContext context, int curIndex, int totalNum) {
      final msg = mediaMessages[curIndex];
      if (msg.isVideoType) {
        return Positioned(child: Container());
      }
      return Positioned(
        left: 20,
        bottom: 20,
        child: GestureDetector(
            onTap: () async {
              if (msg.isVideoType) {
                HttpUtil.saveUrlPicture(msg.videoElem!.videoUrl!);
              } else {
                final url = msg.pictureElem?.sourcePicture?.url;
                if (url?.isNotEmpty == true) {
                  HttpUtil.saveUrlPicture(url!);
                }
              }
            },
            child: const Icon(
              Icons.download_sharp,
              color: Colors.white,
              size: 20,
            )),
      );
    }

    Widget buildFailedChild() {
      return const Center(
        child: Material(
          child: Text(
            '加载图片失败',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    photoBrowser = PhotoBrowser(
      itemCount: mediaMessages.length,
      initIndex: currentIndex,
      // controller: logic.browserController,
      allowSwipeDownToPop: false,
      // If allowPullDownToPop is true, the allowSwipeDownToPop setting is invalid.
      allowPullDownToPop: true,
      heroTagBuilder: (int index) {
        return mediaMessages[index].clientMsgID!;
      },
      // Set the display type of each page,
      // if the value is null, all are DisplayType.image.
      displayTypeBuilder: (int index) {
        final msg = mediaMessages[index];
        if (msg.contentType == MessageType.picture) {
          return DisplayType.image;
        } else {
          return DisplayType.custom;
        }
      },
      // Large images setting.
      imageProviderBuilder: (index) {
        final msg = mediaMessages[index];
        final localPath = msg.pictureElem?.sourcePath;
        if (localPath != null && File(localPath).existsSync()) {
          return ExtendedFileImageProvider(File(localPath));
        }
        final url = msg.pictureElem?.bigPicture?.url ?? '';

        return ExtendedNetworkImageProvider(url, cache: true);
      },
      // Thumbnails setting.
      thumbImageProviderBuilder: (index) {
        final msg = mediaMessages[index];
        final localPath = msg.pictureElem?.sourcePath;
        if (localPath != null && File(localPath).existsSync()) {
          return ExtendedFileImageProvider(File(localPath));
        }
        final url = msg.pictureElem?.snapshotPicture?.url
                ?.adjustThumbnailAbsoluteString(540) ??
            '';

        return ExtendedNetworkImageProvider(url, cache: true);
      },
      // Called when the display type is DisplayType.custom.
      customChildBuilder: (int index) {
        final msg = mediaMessages[index];

        final snapshotUrl =
            msg.videoElem?.snapshotUrl?.adjustThumbnailAbsoluteString(540) ??
                '';
        final url = msg.videoElem?.videoUrl ?? '';
        return CustomChild(
          child: Center(
              child: ChatVideoPlayerView(
            url: url,
            coverUrl: snapshotUrl,
            file: File(msg.videoElem!.videoPath!),
            autoPlay: onAutoPlay != null ? onAutoPlay(index) : false,
            muted: muted,
            oDownload: (url) {
              HttpUtil.saveUrlVideo(url!);
            },
          )),
          allowZoom: true,
        );
      },
      positions: (BuildContext context) => <Positioned>[buildCloseBtn(context)],
      positionBuilders: <PositionBuilder>[
        buildSaveImageBtn,
      ],
      loadFailedChild: buildFailedChild(),
      onPageChanged: onPageChanged,
      pageCodeBuild: (context, current, total) {
        return Positioned(
          top: 70,
          right: 0,
          left: 0,
          child: Text(
            '$current/$total',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withAlpha(230),
              decoration: TextDecoration.none,
            ),
          ),
        );
      },
      onLongPress: (index) {
        showBottomBar(index);
      },
    );

    return photoBrowser.push(context);
  }

  static openFileByOtherApp(String path) async {
    OpenResult result = await OpenFilex.open(path);
    if (result.type == ResultType.noAppToOpen) {
      IMViews.showToast("没有可支持的应用");
    } else if (result.type == ResultType.permissionDenied) {
      IMViews.showToast("无权限访问");
    } else if (result.type == ResultType.fileNotFound) {
      IMViews.showToast("文件已失效");
    }
  }

  static void previewLocation(Message message) {
    var location = message.locationElem;
    Map detail = json.decode(location!.description!);
    Logger.print('previewLocation ${location.latitude}  ${location.longitude}');
    Get.to(
      () => MapView(
        latitude: location.latitude!,
        longitude: location.longitude!,
        address1: detail['name'],
        address2: detail['addr'],
      ),
      // () => ChatWebViewMap(
      //   mapAppKey: Config.mapKey,
      //   latitude: location?.latitude,
      //   longitude: location?.longitude,
      // ),
      transition: Transition.cupertino,
      popGesture: true,
      // fullscreenDialog: true,
    );
  }

  static void previewMergeMessage(Message message) => Get.to(
        () => ChatPreviewMergeMsgView(
          title: message.mergeElem!.title!,
          messageList: message.mergeElem!.multiMessage ?? [],
        ),
        preventDuplicates: false,
        transition: Transition.cupertino,
        popGesture: true,
      );

  static void previewCarteMessage(
    Message message,
    Function(UserInfo userInfo)? onViewUserInfo,
  ) =>
      onViewUserInfo?.call(UserInfo.fromJson(message.cardElem!.toJson()));

  /// 处理消息点击事件
  /// [messageList] 预览图片消息的时候，可用左右滑动
  static void parseClickEvent(
    Message message, {
    List<Message> messageList = const [],
    Function(UserInfo userInfo)? onViewUserInfo,
  }) async {
    if (message.contentType == MessageType.picture ||
        message.contentType == MessageType.video) {
      var mediaMessages = messageList
          .where((element) =>
              element.contentType == MessageType.picture ||
              message.contentType == MessageType.video)
          .toList();
      var currentIndex = mediaMessages.indexOf(message);
      if (currentIndex == -1) {
        mediaMessages = [message];
        currentIndex = 0;
      }
      previewMediaFile(
          context: Get.context!,
          currentIndex: currentIndex,
          mediaMessages: mediaMessages);
    } else if (message.contentType == MessageType.file) {
      previewFile(message);
    } else if (message.contentType == MessageType.card) {
      previewCarteMessage(message, onViewUserInfo);
    } else if (message.contentType == MessageType.merger) {
      previewMergeMessage(message);
    } else if (message.contentType == MessageType.location) {
      previewLocation(message);
    } else if (message.contentType == MessageType.customFace) {
      previewCustomFace(message);
    }
  }

  static Future<bool> isExitFile(String? path) async {
    return isNotNullEmptyStr(path) ? await File(path!).exists() : false;
  }

  //fileExt 文件后缀名
  static String? getMediaType(final String filePath) {
    var fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
    var fileExt = fileName.substring(fileName.lastIndexOf("."));
    switch (fileExt.toLowerCase()) {
      case ".jpg":
      case ".jpeg":
      case ".jpe":
        return "image/jpeg";
      case ".png":
        return "image/png";
      case ".bmp":
        return "image/bmp";
      case ".gif":
        return "image/gif";
      case ".json":
        return "application/json";
      case ".svg":
      case ".svgz":
        return "image/svg+xml";
      case ".mp3":
        return "audio/mpeg";
      case ".mp4":
        return "video/mp4";
      case ".mov":
        return "video/mov";
      case ".htm":
      case ".html":
        return "text/html";
      case ".css":
        return "text/css";
      case ".csv":
        return "text/csv";
      case ".txt":
      case ".text":
      case ".conf":
      case ".def":
      case ".log":
      case ".in":
        return "text/plain";
    }
    return null;
  }

  /// 将字节数转化为MB
  static String formatBytes(int bytes) {
    int kb = 1024;
    int mb = kb * 1024;
    int gb = mb * 1024;
    if (bytes >= gb) {
      return sprintf("%.1f GB", [bytes / gb]);
    } else if (bytes >= mb) {
      double f = bytes / mb;
      return sprintf(f > 100 ? "%.0f MB" : "%.1f MB", [f]);
    } else if (bytes > kb) {
      double f = bytes / kb;
      return sprintf(f > 100 ? "%.0f KB" : "%.1f KB", [f]);
    } else {
      return sprintf("%d B", [bytes]);
    }
  }

  // static IconData fileIcon(String fileName) {
  //   var mimeType = lookupMimeType(fileName) ?? '';
  //   if (mimeType == 'application/pdf') {
  //     return FontAwesomeIcons.solidFilePdf;
  //   } else if (mimeType == 'application/msword' ||
  //       mimeType ==
  //           'application/vnd.openxmlformats-officedocument.wordprocessingml.document') {
  //     return FontAwesomeIcons.solidFileWord;
  //   } else if (mimeType == 'application/vnd.ms-excel' ||
  //       mimeType ==
  //           'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') {
  //     return FontAwesomeIcons.solidFileExcel;
  //   } else if (mimeType == 'application/vnd.ms-powerpoint') {
  //     return FontAwesomeIcons.solidFilePowerpoint;
  //   } else if (mimeType.startsWith('audio/')) {
  //   } else if (mimeType == 'application/zip' ||
  //       mimeType == 'application/x-rar-compressed') {
  //     return FontAwesomeIcons.solidFileZipper;
  //   } else if (mimeType.startsWith('audio/')) {
  //     return FontAwesomeIcons.solidFileAudio;
  //   } else if (mimeType.startsWith('video/')) {
  //     return FontAwesomeIcons.solidFileVideo;
  //   } else if (mimeType.startsWith('image/')) {
  //     return FontAwesomeIcons.solidFileImage;
  //   } else if (mimeType == 'text/plain') {
  //     return FontAwesomeIcons.solidFileCode;
  //   }
  //   return FontAwesomeIcons.solidFileLines;
  // }

  static String fileIcon(String fileName) {
    var mimeType = lookupMimeType(fileName) ?? '';
    if (mimeType == 'application/pdf') {
      return ImageRes.filePdf;
    } else if (mimeType == 'application/msword' ||
        mimeType ==
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document') {
      return ImageRes.fileWord;
    } else if (mimeType == 'application/vnd.ms-excel' ||
        mimeType ==
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') {
      return ImageRes.fileExcel;
    } else if (mimeType == 'application/vnd.ms-powerpoint') {
      return ImageRes.filePpt;
    } else if (mimeType.startsWith('audio/')) {
    } else if (mimeType == 'application/zip' ||
        mimeType == 'application/x-rar-compressed') {
      return ImageRes.fileZip;
    }
    /*else if (mimeType.startsWith('audio/')) {
      return FontAwesomeIcons.solidFileAudio;
    } else if (mimeType.startsWith('video/')) {
      return FontAwesomeIcons.solidFileVideo;
    } else if (mimeType.startsWith('image/')) {
      return FontAwesomeIcons.solidFileImage;
    } else if (mimeType == 'text/plain') {
      return FontAwesomeIcons.solidFileCode;
    }*/
    return ImageRes.fileUnknown;
  }

  static String createSummary(Message message) {
    return '${message.senderNickname}：${parseMsg(message, replaceIdToNickname: true)}';
  }

  static List<UserInfo>? convertSelectContactsResultToUserInfo(result) {
    if (result is Map) {
      final checkedList = <UserInfo>[];
      final values = result.values;
      for (final value in values) {
        if (value is ISUserInfo) {
          checkedList.add(UserInfo.fromJson(value.toJson()));
        } else if (value is UserFullInfo) {
          checkedList.add(UserInfo.fromJson(value.toJson()));
        } else if (value is UserInfo) {
          checkedList.add(value);
        }
      }
      return checkedList;
    }
    return null;
  }

  static List<String>? convertSelectContactsResultToUserID(result) {
    if (result is Map) {
      final checkedList = <String>[];
      final values = result.values;
      for (final value in values) {
        if (value is UserInfo ||
            value is FriendInfo ||
            value is UserFullInfo ||
            value is ISUserInfo) {
          checkedList.add(value.userID!);
        }
      }
      return checkedList;
    }
    return null;
  }

  static convertCheckedListToMap(List<dynamic>? checkedList) {
    if (null == checkedList) return null;
    final checkedMap = <String, dynamic>{};
    for (var item in checkedList) {
      if (item is ConversationInfo) {
        checkedMap[item.isSingleChat ? item.userID! : item.groupID!] = item;
      } else if (item is UserInfo ||
          item is UserFullInfo ||
          item is ISUserInfo) {
        checkedMap[item.userID!] = item;
      } else if (item is GroupInfo) {
        checkedMap[item.groupID] = item;
      } else if (item is TagInfo) {
        checkedMap[item.tagID!] = item;
      }
    }
    return checkedMap;
  }

  static List<Map<String, String?>> convertCheckedListToForwardObj(
      List<dynamic> checkedList) {
    final map = <Map<String, String?>>[];
    for (var item in checkedList) {
      if (item is UserInfo || item is UserFullInfo || item is ISUserInfo) {
        map.add({'nickname': item.nickname, 'faceURL': item.faceURL});
      } else if (item is GroupInfo) {
        map.add({'nickname': item.groupName, 'faceURL': item.faceURL});
      } else if (item is ConversationInfo) {
        map.add({'nickname': item.showName, 'faceURL': item.faceURL});
      }
    }
    return map;
  }

  static String? convertCheckedToUserID(dynamic info) {
    if (info is UserInfo || info is UserFullInfo || info is ISUserInfo) {
      return info.userID;
    } else if (info is ConversationInfo) {
      return info.userID;
    }
    return null;
  }

  static String? convertCheckedToGroupID(dynamic info) {
    if (info is GroupInfo) {
      return info.groupID;
    } else if (info is ConversationInfo) {
      return info.groupID;
    }
    return null;
  }

  static List<Map<String, String?>> convertCheckedListToShare(
      Iterable<dynamic> checkedList) {
    final map = <Map<String, String?>>[];
    for (var item in checkedList) {
      if (item is UserInfo || item is UserFullInfo || item is ISUserInfo) {
        map.add({'userID': item.userID, 'groupID': null});
      } else if (item is GroupInfo) {
        map.add({'userID': null, 'groupID': item.groupID});
      } else if (item is ConversationInfo) {
        map.add({'userID': item.userID, 'groupID': item.groupID});
      }
    }
    return map;
  }

  static String getWorkMomentsTimeline(int ms) {
    final locTimeMs = DateTime.now().millisecondsSinceEpoch;
    final languageCode = Get.locale?.languageCode ?? 'zh';
    final isZH = languageCode == 'zh';

    if (DateUtil.isToday(ms, locMs: locTimeMs)) {
      return isZH ? '今天' : 'Today';
    }

    if (DateUtil.isYesterdayByMs(ms, locTimeMs)) {
      return isZH ? '昨天' : 'Yesterday';
    }

    if (DateUtil.isWeek(ms, locMs: locTimeMs)) {
      return DateUtil.getWeekdayByMs(ms, languageCode: languageCode);
    }

    if (DateUtil.yearIsEqualByMs(ms, locTimeMs)) {
      return formatDateMs(ms, format: isZH ? 'MM月dd日' : 'MM/dd');
    }

    return formatDateMs(ms, format: isZH ? 'yyyy年MM月dd日' : 'yyyy/MM/dd');
  }

  static Future<bool> checkingBiometric(LocalAuthentication auth) =>
      auth.authenticate(
        localizedReason: '扫描您的指纹（或面部或其他）以进行身份验证',
        options: const AuthenticationOptions(
          // stickyAuth: true,
          biometricOnly: true,
        ),
        authMessages: <AuthMessages>[
          const AndroidAuthMessages(
            cancelButton: '不，谢谢',
            biometricNotRecognized: '未能识别。 再试一次。',
            biometricHint: '验证身份',
            biometricSuccess: '成功',
            biometricRequiredTitle: '需要身份验证',
            goToSettingsDescription: "您的设备上未设置生物认证。 去设置 > 安全以添加生物识别身份验证。",
            goToSettingsButton: '前往设置',
            deviceCredentialsRequiredTitle: '需要设备凭据',
            deviceCredentialsSetupDescription: '需要设备凭据',
            signInTitle: '需要身份验证',
          ),
          const IOSAuthMessages(
            cancelButton: '不，谢谢',
            goToSettingsButton: '前往设置',
            goToSettingsDescription: '您的设备上未设置生物认证。 请启用手机上的Touch ID或Face ID。',
            lockOut: '生物认证被禁用。 请锁定和解锁您的屏幕以启用它。',
          ),
        ],
      );

  static String safeTrim(String text) {
    String pattern = '(${[regexAt, regexAtAll].join('|')})';
    RegExp regex = RegExp(pattern);
    Iterable<Match> matches = regex.allMatches(text);
    int? start;
    int? end;
    for (Match match in matches) {
      String? matchText = match.group(0);
      start ??= match.start;
      end = match.end;
      Logger.print("Matched: $matchText  start: $start  end: $end");
    }
    if (null != start && null != end) {
      final startStr = text.substring(0, start).trimLeft();
      final middleStr = text.substring(start, end);
      final endStr = text.substring(end).trimRight();
      return '$startStr$middleStr$endStr';
    }
    return text.trim();
  }

  static String getTimeFormat1() {
    bool isZh = Get.locale!.languageCode.toLowerCase().contains("zh");
    return isZh ? 'yyyy年MM月dd日' : 'yyyy/MM/dd';
  }

  static String getTimeFormat2() {
    bool isZh = Get.locale!.languageCode.toLowerCase().contains("zh");
    return isZh ? 'yyyy年MM月dd日 HH时mm分' : 'yyyy/MM/dd HH:mm';
  }

  static String getTimeFormat3() {
    bool isZh = Get.locale!.languageCode.toLowerCase().contains("zh");
    return isZh ? 'MM月dd日 HH时mm分' : 'MM/dd HH:mm';
  }

  static bool isValidPassword(String password) => RegExp(
        // r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@#$%^&+=!.])(?=.{6,20}$)',
        // r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z\d]{6,20}$',
        // r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{6,20}$',
        r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d\S]{6,20}$',
      ).hasMatch(password);

  static TextInputFormatter getPasswordFormatter() =>
      FilteringTextInputFormatter.allow(
        // RegExp(r'[a-zA-Z0-9]'),
        RegExp(r'[a-zA-Z0-9\S]'),
      );

  static bool isEmail(String email) {
    RegExp exp = RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z0-9.-]+$',
        caseSensitive: false, multiLine: false);
    return exp.hasMatch(email);
  }

  static Future<File?> getFile({
    required String path,
  }) async {
    final file = File(path);
    if (await file.exists()) {
      return file;
    } else {
      return null;
    }
  }

  static String replaceMessageAtMapping(
    Message message,
    Map<String, String> newMapping,
  ) {
    String text =
        message.atTextElem!.text!.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
    final reg = "${regexAt}|${regexAtAll}";
    final atMap = getAtMapping(message, newMapping);
    final newText = text.splitMapJoin(RegExp(reg), onMatch: (Match match) {
      final matchText = match[0]!;
      String userID = matchText.replaceFirst("@", "").trim();
      if (atMap.containsKey(userID)) {
        return '@${atMap[userID]} ';
      }
      return matchText;
    });
    return newText;
  }

  // 尝试从好友showName中获取指定用户showName
  static Future<String?> getShowNameFromFriendList(
      {required String userID}) async {
    final list = await OpenIM.iMManager.friendshipManager.getFriendListMap();
    final friendJson = list.firstWhereOrNull((element) {
      final fullUser = FullUserInfo.fromJson(element);
      return fullUser.userID == userID;
    });
    ISUserInfo? friendInfo;
    if (null != friendJson) {
      final info = FullUserInfo.fromJson(friendJson);
      friendInfo = info.friendInfo != null
          ? ISUserInfo.fromJson(info.friendInfo!.toJson())
          : ISUserInfo.fromJson(info.publicInfo!.toJson());
    }
    return null != friendInfo && friendInfo.showName.isNotEmpty
        ? friendInfo.showName
        : null;
  }

  static Future<String?> getShowNameFromGroup(
      {required String userID, required String groupID}) async {
    GroupMembersInfo? member;
    final memberList = await OpenIM.iMManager.groupManager.getGroupMemberList(
      groupID: groupID,
      count: 999,
    );
    member = memberList.firstWhereOrNull((element) => element.userID == userID);

    return null != member?.nickname && member!.nickname!.isNotEmpty
        ? member.nickname
        : null;
  }
}
