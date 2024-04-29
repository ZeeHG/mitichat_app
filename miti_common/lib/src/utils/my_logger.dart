import 'dart:io';
import 'package:logger/logger.dart';
import 'package:miti_common/miti_common.dart' as common;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

Logger myLogger = Logger();
String myLoggerPath = "";
String myLoggerDirPath = "";
String myLoggerDateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
File? logFile;

class PrefixPrinter extends LogPrinter {
  final LogPrinter _realPrinter;
  late Map<Level, String> _prefixMap;
  String appVersion;

  PrefixPrinter(
    this._realPrinter,
    this.appVersion, {
    String? debug,
    String? trace,
    @Deprecated('[verbose] is being deprecated in favor of [trace].') verbose,
    String? fatal,
    @Deprecated('[wtf] is being deprecated in favor of [fatal].') wtf,
    String? info,
    String? warning,
    String? error,
  }) {
    _prefixMap = {
      Level.debug: debug ?? 'DEBUG',
      Level.trace: trace ?? verbose ?? 'TRACE',
      Level.fatal: fatal ?? wtf ?? 'FATAL',
      Level.info: info ?? 'INFO',
      Level.warning: warning ?? 'WARNING',
      Level.error: error ?? 'ERROR',
    };

    var len = _longestPrefixLength();
    _prefixMap.forEach((k, v) => _prefixMap[k] = '${v.padLeft(len)} ');
  }

  @override
  List<String> log(LogEvent event) {
    LogEvent newEvent = LogEvent(
        event.level,
        {
          "appVersion": appVersion,
          "curAccount": common.DataSp.getCurAccountLoginInfoKey(),
          "logTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          "logInfo": event.message,
        },
        time: event.time,
        error: event.error,
        stackTrace: event.stackTrace);
    var realLogs = _realPrinter.log(newEvent);
    return realLogs.map((s) => '${_prefixMap[event.level]}$s').toList();
  }

  int _longestPrefixLength() {
    compFunc(String a, String b) => a.length > b.length ? a : b;
    return _prefixMap.values.reduce(compFunc).length;
  }
}

Future<void> initLogger() async {
  await initLoggerConfig();
}

Future<void> initLoggerConfig() async {
  Directory applicationDir = await getApplicationDocumentsDirectory();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String appVersion = "${packageInfo.version}(${packageInfo.buildNumber})";
  // Directory? storageDir = await getExternalStorageDirectory();
  // if (storageDir != null) {
  //   myLoggerDirPath = "${storageDir.path}/";
  //   myLoggerPath = "${myLoggerDirPath}/${myLoggerDateStr}.log";
  //   logFile = File("${myLoggerDirPath}/${myLoggerDateStr}.log");
  // } else {
  myLoggerDirPath = "${applicationDir.path}/";
  myLoggerPath = "$myLoggerDirPath/$myLoggerDateStr.log";
  logFile = File(myLoggerPath);
  // }

  myLogger = Logger(
    filter: ProductionFilter(),
    printer: PrefixPrinter(
        PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          printTime: true,
        ),
        appVersion),
    output: MultiOutput([
      Logger.defaultOutput(),
      FileOutput(file: logFile!),
    ]),
  );
}
