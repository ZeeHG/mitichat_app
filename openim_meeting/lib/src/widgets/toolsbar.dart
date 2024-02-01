import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_meeting/src/widgets/button.dart';

class ToolsBar extends StatelessWidget {
  const ToolsBar({
    Key? key,
    this.enabledMicrophone = true,
    this.enabledCamera = true,
    this.enabledScreenShare = true,
    this.openedScreenShare = false,
    this.openedMicrophone = true,
    this.openedCamera = true,
    this.onTapSettings,
    this.onTapMemberList,
    this.onTapCamera,
    this.onTapMicrophone,
    this.onTapScreenShare,
    this.membersCount = 0,
    this.isHost = false,
  }) : super(key: key);
  final Function()? onTapSettings;
  final Function()? onTapMemberList;
  final Function()? onTapMicrophone;
  final Function()? onTapCamera;
  final Function()? onTapScreenShare;
  final bool enabledMicrophone;
  final bool enabledCamera;
  final bool enabledScreenShare;
  final bool openedScreenShare;
  final bool openedMicrophone;
  final bool openedCamera;
  final int membersCount;
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66.h,
      alignment: Alignment.center,
      child: Row(
        children: [
          ImageButton.microphone(
            on: openedMicrophone,
            enabled: enabledMicrophone,
            onTap: onTapMicrophone,
          ),
          ImageButton.camera(
            on: openedCamera,
            enabled: enabledCamera,
            onTap: onTapCamera,
          ),
          ImageButton.screenShare(
            on: openedScreenShare,
            enabled: enabledScreenShare,
            onTap: onTapScreenShare,
          ),
          ImageButton.members(
            onTap: onTapMemberList,
            count: membersCount,
          ),
          if (isHost) ImageButton.settings(onTap: onTapSettings),
        ],
      ),
    );
  }
}
