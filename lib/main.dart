import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:openim_common/openim_common.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'app.dart';

void main() async =>
    FlutterBugly.postCatchedException(() => Config.init(() async {
          await dotenv.load(fileName: ".env");
          WidgetsFlutterBinding.ensureInitialized();
          await initLogger();
          // await initialization(null);
          runApp(ChatApp());
        }));

//启动图延时移除方法
Future<void> initialization(BuildContext? context) async {
  //延迟3秒
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
}
