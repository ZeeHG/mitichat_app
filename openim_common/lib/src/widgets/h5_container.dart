import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:openim_common/openim_common.dart';
import 'package:url_launcher/url_launcher.dart';

class H5Container extends StatefulWidget {
  const H5Container({super.key, required this.url, this.title});

  final String url;
  final String? title;

  @override
  State<H5Container> createState() => _H5ContainerState();
}

class _H5ContainerState extends State<H5Container> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    Logger.print('H5Container: ${widget.url}');
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Styles.c_0089FF,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title != null ? TitleBar.back(title: widget.title) : null,
      body: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            // contextMenu: contextMenu,
            // initialUrlRequest: URLRequest(
            initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
            // initialFile: "assets/html/index.html",
            // initialData: InAppWebViewInitialData(data: ""),
            initialUserScripts: UnmodifiableListView<UserScript>([]),
            initialOptions: options,
            pullToRefreshController: pullToRefreshController,
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {},
            androidOnPermissionRequest: (controller, origin, resources) async {
              return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT);
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url!;
              if (![
                "http",
                "https",
                "file",
                "chrome",
                "data",
                "javascript",
                "about"
              ].contains(uri.scheme)) {
                final uri = Uri.parse(widget.url);
                if (await canLaunchUrl(uri)) {
                  // Launch the App
                  await launchUrl(uri);
                  // and cancel the request
                  return NavigationActionPolicy.CANCEL;
                }
              }

              return NavigationActionPolicy.ALLOW;
            },
            onLoadStop: (controller, url) async {
              pullToRefreshController.endRefreshing();
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
            onUpdateVisitedHistory: (controller, url, androidIsReload) {},
            onConsoleMessage: (controller, consoleMessage) {},
          ),
          progress < 1.0
              ? LinearProgressIndicator(value: progress)
              : Container(),
        ],
      ),
    );
  }
}
