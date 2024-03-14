import 'package:flutter/material.dart';
import 'package:openim_common/openim_common.dart';
import 'miti.dart';

void main() async => Config.init(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await initLogger();
      runApp(Miti());
    });
