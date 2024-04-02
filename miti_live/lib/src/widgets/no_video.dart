import 'dart:math' as math;

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:miti_common/miti_common.dart';
import 'package:miti_live/src/utils/live_utils.dart';

class NoVideoWidget extends StatelessWidget {
  //
  const NoVideoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        child: LayoutBuilder(
          builder: (ctx, constraints) => Icon(
            EvaIcons.videoOffOutline,
            color: StylesLibrary.c_0089FF,
            size: math.min(constraints.maxHeight, constraints.maxWidth) * 0.3,
          ),
        ),
      );
}

class NoVideoAvatarWidget extends StatelessWidget {
  //
  const NoVideoAvatarWidget({Key? key, this.faceURL}) : super(key: key);
  final String? faceURL;

  //

  @override
  Widget build(BuildContext context) =>
      null != faceURL && LiveUtils.isURL(faceURL!)
          ? ImageUtil.networkImage(url: faceURL!, fit: BoxFit.cover)
          : const NoVideoWidget();
}
