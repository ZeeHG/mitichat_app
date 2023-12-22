import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class OpenIM {
  static const version = '3.4.1-alpha.5-e-1.1.3';

  static const _channel = MethodChannel('flutter_openim_sdk');

  static final iMManager = IMManager(_channel);

  OpenIM._();
}
