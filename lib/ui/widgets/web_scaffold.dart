import 'dart:async';

import 'package:kuvia/common/common.dart';
import 'package:kuvia/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

class WebScaffold extends StatefulWidget {
  const WebScaffold({
    Key key,
    this.title,
    this.titleId,
    this.url,
  }) : super(key: key);

  final String title;
  final String titleId;
  final String url;


  @override
  State<StatefulWidget> createState() => _WebScaffoldState();
}

class _WebScaffoldState extends State<WebScaffold> {

  final Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController _webViewController;

  double webOpacity = 0.0;
  bool showProgress = true;

  bool isProgressView;
  bool isWebViewMaskShow;

  @override
  void initState() {
    super.initState();
    isProgressView = true;
    isWebViewMaskShow = true;
    Future.delayed(Duration(milliseconds: 500),() {
      if(mounted){
        setState(() {
          isWebViewMaskShow = false; 
          this.webOpacity = 1.0;
          this.showProgress = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onClearCache() async {
    await _webViewController?.clearCache();
  }


  @override
  Widget build(BuildContext context) {
    
    Widget webView = WebView(
      // initialUrl: 'https://www.baidu.com',
      initialUrl: '${widget.url}',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
        this._webViewController = webViewController;
      },
      javascriptChannels: <JavascriptChannel>[].toSet(),
      // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
      //   Factory<OneSequenceGestureRecognizer>(
      //     () => new EagerGestureRecognizer(),
      //   ),
      // ].toSet(),
      gestureRecognizers: Set()
      ..add(
          Factory<VerticalDragGestureRecognizer>(
          () => VerticalDragGestureRecognizer(),
          ),
      ),
      navigationDelegate: (NavigationRequest request) {
        return NavigationDecision.navigate;
      },
      onPageFinished: (String url) {
      },
    );

    Widget body = AnimatedOpacity(
      opacity: this.webOpacity,
      duration: Duration(milliseconds: 500),
      child: Container(
        color: Theme.of(context).cardColor,
        width: double.infinity,
        padding: EdgeInsets.only(top: AppConfig.appHeaderHeight),
        child: webView,
      ),
    );

    return Scaffold(
          body: SafeArea(
            top: false,
            child: Stack(
            children: <Widget>[
              Positioned(
                left: 2.0,
                right: 2.0,
                top: 0.0,
                bottom: 0.0,
                child: body,
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0.0,
                child: AppHeader(
                  title: '${widget.title}'
                )
              ),
              Positioned(
                top: AppConfig.appHeaderHeight,
                left: 0,
                bottom: 0.0,
                right: 0.0,
                child: Offstage(
                  offstage: !this.showProgress,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              )
            ],
          )
      )
    );
  }



  
}