import 'package:flutter/material.dart';
import 'package:miti_common/miti_common.dart';
import 'miti.dart';

void main() async => Config.init(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await initLogger();
      runApp(Miti());
    });
