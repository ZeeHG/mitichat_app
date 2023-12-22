import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

/// 腾讯h5地图
class ChatWebViewMap extends StatefulWidget {
  const ChatWebViewMap({
    Key? key,
    this.mapAppKey = "",
    this.mapThumbnailSize = "1200*600",
    this.mapBackUrl = "http://callback",
    this.latitude,
    this.longitude,
  }) : super(key: key);

  final String mapAppKey;
  final String mapThumbnailSize;
  final String mapBackUrl;
  final double? latitude;
  final double? longitude;

  @override
  State<ChatWebViewMap> createState() => _ChatWebViewMapState();
}

class _ChatWebViewMapState extends State<ChatWebViewMap> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
        domStorageEnabled: true,
        geolocationEnabled: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;

  String url = "";
  double progress = 0;
  double? latitude;
  double? longitude;
  String? description;

  /// 定位获取
  late String locationUrl;
  late String thumbnailUrl;

  /// 根据定位坐标预览
  late String previewLocationUrl;

  _initUrl() {
    locationUrl =
        "https://apis.map.qq.com/tools/locpicker?search=1&type=0&backurl=${widget.mapBackUrl}&key=${widget.mapAppKey}&referer=myapp&policy=1";
    thumbnailUrl =
        "https://apis.map.qq.com/ws/staticmap/v2/?center=%s&zoom=18&size=${widget.mapThumbnailSize}&maptype=roadmap&markers=size:large|color:0xFFCCFF|label:k|%s&key=${widget.mapAppKey}";
    previewLocationUrl =
        "https://apis.map.qq.com/uri/v1/geocoder?coord=${widget.latitude},${widget.longitude}&referer=${widget.mapAppKey}";
  }

  bool get isPreview => widget.longitude != null && widget.latitude != null;

  @override
  void initState() {
    super.initState();
    _initUrl();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _confirm() async {
    if (null == latitude || null == longitude) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: StrRes.plsSelectLocation.toText
            ..style = Styles.ts_0C1C33_17sp_semibold,
          actions: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: StrRes.determine.toText
                  ..style = Styles.ts_0089FF_17sp_semibold,
              ),
            ),
          ],
        ),
      );
      return;
    }
    Navigator.pop(context, {
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TitleBar.back(
        onTap: () async {
          if (await webViewController!.canGoBack()) {
            webViewController!.goBack();
          } else {
            Get.back();
          }
        },
        title: StrRes.location,
        right: isPreview
            ? null
            : GestureDetector(
                onTap: _confirm,
                behavior: HitTestBehavior.translucent,
                child: StrRes.determine.toText..style = Styles.ts_0C1C33_17sp,
              ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              // contextMenu: contextMenu,
              initialUrlRequest: URLRequest(
                  url: Uri.parse(isPreview ? previewLocationUrl : locationUrl)),
              // initialFile: "assets/index.html",
              initialUserScripts: UnmodifiableListView<UserScript>([]),
              initialOptions: options,
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {},
              androidOnGeolocationPermissionsShowPrompt:
                  (controller, origin) async {
                return GeolocationPermissionShowPromptResponse(
                    origin: origin, allow: true, retain: true);
              },
              androidOnPermissionRequest: (ctrl, origin, res) async {
                return PermissionRequestResponse(
                  resources: res,
                  action: PermissionRequestResponseAction.GRANT,
                );
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                var uri = navigationAction.request.url!;
                var uriStr = uri.toString();
                Logger.print('click: $uriStr');
                if (uriStr.startsWith(widget.mapBackUrl)) {
                  try {
                    Logger.print('${uri.queryParameters}');
                    var result = <String, String>{};
                    result.addAll(uri.queryParameters);
                    var lat = result['latng'];
                    //latitude, longitude
                    var list = lat!.split(",");
                    result['latitude'] = list[0];
                    result['longitude'] = list[1];
                    result['url'] = sprintf(thumbnailUrl, [lat, lat]);
                    Logger.print('${result['url']}');
                    // log('--url:${_result['url']}');
                    latitude = double.tryParse(result['latitude']!);
                    longitude = double.tryParse(result['longitude']!);
                    description = jsonEncode(result);
                  } catch (e) {
                    Logger.print('e:$e');
                  }
                  return NavigationActionPolicy.CANCEL;
                } else if (uriStr
                    .contains('qqmap://map/routeplan?type=drive&referer=')) {
                  return NavigationActionPolicy.CANCEL;
                } else if (uriStr.contains('qqmap://map/nearby?coord=')) {
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController.endRefreshing();
                this.url = url.toString();
              },
              onLoadError: (controller, url, code, message) {
                pullToRefreshController.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                this.url = url.toString();
              },
              onConsoleMessage: (controller, consoleMessage) {
                Logger.print('$consoleMessage');
              },
            ),
            progress < 1.0
                ? LinearProgressIndicator(value: progress)
                : Container(),
          ],
        ),
      ),
    );
  }
}
