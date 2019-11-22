// import 'dart:io';

// import 'package:kuvia/utils/util_index.dart';
// import 'package:flutter/material.dart';
// import 'package:kuvia/common/common.dart';
// import 'package:kuvia/ui/widgets/widgets.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
// import 'package:share_extend/share_extend.dart';

// /// ------------ 以上为马甲代码，当打包ios 发布，需注释flutter_inappbrowser 引用及一下代码，开放马甲 begin-----------

// class InAppWebBrowser{

//   static InAppBrowser browser = InAppBrowser();

//   static void openInappbrowser({
//     @required String url, 
//     String title, 
//     String articleId ,
//     bool isAddToHistory}
//   ){
//     LogUtil.e('LoadWebviewPage===========url=====>>>>$url');
//     browser.open(
//         url: url,
//         // url: "https://36kr.com/p/5256612",
//         // url: "https://okmagazine.com1/photos/brittany-aldean-emotional-tribute-grandmother-dog-died-same-day-instagram/",
//         options: {
//           // "useShouldOverrideUrlLoading": true,
//           // "useOnLoadResource": true,
//           "databaseEnabled": true,
//           "domStorageEnabled": true,
//           // "safeBrowsingEnabled":false
//           "clearCache": true
//         }
//     );
//   }  
// }


// class InAppWebBrowserScreen extends StatefulWidget {
//   InAppWebBrowserScreen({
//     Key key, 
//     @required this.url,
//     this.headerHeight,
//   }): super(key: key);
//   final String url;
//   final headerHeight;
//   @override
//   _InAppWebBrowserScreenState createState() => new _InAppWebBrowserScreenState();
// }


// class _InAppWebBrowserScreenState extends State<InAppWebBrowserScreen> {
//   InAppWebViewController _inAppWebViewController;
//   double progressHeight = 2.0;
//   double progress = 0;
//   bool isOpenNavBar = false;
//   bool isWebViewMaskShow = true;
//   Offset startOffset;
//   String currentUrl;

//   bool canGoBack = false;
//   bool canGoForward = false;

//   int webScrollPosition = 0;

//   // bool isStartInitWeb = false;

//   @override
//   void initState() {
//     super.initState();
//     this.currentUrl = widget.url;
//     // Future.delayed(Duration(milliseconds: 350)).then((_){
//       // print('delayed------>>>>>');
//       // if(mounted){
//       //   setState(() {
//       //     this.isStartInitWeb = true;
//       //   });
//       // }
//     // });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   void _launchURL(url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     return 
//     // Scaffold(
//     //   backgroundColor: Colors.black.withOpacity(0.8),
//     //   body: SafeArea(
//     //     top: false,
//     //     child:
//         // Listener(
//         //   child: 
//           Stack(
//             children: <Widget>[
//               Positioned(
//                 top: 0.0,
//                 bottom: 0.0,
//                 right: 2.0,
//                 left: 2.0,
//                 child: this.buildContent(context),
//               ),
//               Positioned(
//                 top: widget.headerHeight - this.progressHeight,
//                 left: 2.0,
//                 right: 2.0,
//                 child: this._buildProgress(),
//               ),
//               this._buildNavBar(),
//             ],
//           );
//         //   onPointerDown: (PointerDownEvent event){
//         //     startOffset = event.localPosition;
//         //   },
//         //   onPointerUp: (PointerUpEvent event){
//         //     Offset endOffset = event.localPosition;
//         //     if(endOffset.dy < this.startOffset.dy && isOpenNavBar == true){  // 下翻隐藏
//         //       setState(() =>isOpenNavBar = false);
//         //     }else if(endOffset.dy > this.startOffset.dy && isOpenNavBar == false){ // 上翻显示
//         //       setState(() =>isOpenNavBar = true);
//         //     }
//         //   },
//         // ),
//     //   ),
//     // );
//   }

//   Widget buildContent(BuildContext context) {

    

//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.only(topLeft: Radius.circular(13.0), topRight: Radius.circular(13.0)),
//       ),
//       child: Column(
//         children: <Widget>[
//           this._buildHeader(),
          
//           // !this.isStartInitWeb ? 
//           // Expanded(
//           //   child: Container(
//           //     color: Colors.white,
//           //   ),
//           // )
//           // :
//           Expanded(
//             child: Container(
//               foregroundDecoration: BoxDecoration(
//                 color: Platform.isAndroid && this.isWebViewMaskShow ? Theme.of(context).cardColor : null,
//               ),
//               child: InAppWebView(
//                 initialUrl: widget.url,
//                 initialHeaders: {},
//                 initialOptions: {
//                   "mediaPlaybackRequiresUserGesture": false,
//                   "allowsInlineMediaPlayback": true,
//                   "useShouldOverrideUrlLoading": true,
//                   "useOnLoadResource": true,
//                   "clearCache": true,
//                 },
//                 gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
//                   Factory<OneSequenceGestureRecognizer>(
//                     () => EagerGestureRecognizer(),
//                   ),
//                 ].toSet(),
//                 onWebViewCreated: (InAppWebViewController controller) {
//                   this._inAppWebViewController = controller;
//                   if(Platform.isAndroid){
//                     Future.delayed(Duration(milliseconds: 1000),() {
//                       if(mounted){
//                         setState(() {
//                           isWebViewMaskShow = false; 
//                         });
//                       }
//                     });
//                   }
//                 },
//                 onLoadStart: (InAppWebViewController controller, String url) {
                  
//                   controller.canGoBack().then((bool canGoBack){
//                     if(canGoBack != this.canGoBack){
//                       setState(() => this.canGoBack = canGoBack);
//                     }
//                   });
//                   controller.canGoForward().then((bool canGoForward){
//                     if(canGoForward != this.canGoForward){
//                       setState(() => this.canGoForward = canGoForward);
//                     }
//                   });
//                   if(url != this.currentUrl){
//                     setState(() => this.currentUrl = url);
//                   }
                  
//                 },
//                 onLoadStop: (InAppWebViewController controller, String url) async {
                  
//                 },
//                 onProgressChanged:(InAppWebViewController controller, int progress) {
//                   setState(() {
//                     this.progress = progress / 100;
//                   });
//                 },
//                 shouldOverrideUrlLoading: (InAppWebViewController controller, String url) {
//                   controller.loadUrl(url);
//                 },
//                 onLoadResource: (InAppWebViewController controller, WebResourceResponse response, WebResourceRequest request) {
                
//                 },
//                 onConsoleMessage: (InAppWebViewController controller, ConsoleMessage consoleMessage) {
                  
//                 },
//                 onScrollChanged: (InAppWebViewController controller, int x, int y){
//                   if(y - this.webScrollPosition > 10 && this.isOpenNavBar){
//                     setState(() {
//                       this.isOpenNavBar = false;
//                     });
//                   }if(this.webScrollPosition - y > 10 && !this.isOpenNavBar){
//                     setState(() {
//                       this.isOpenNavBar = true;
//                     });
//                   }else{
//                     this.webScrollPosition = y;
//                   }
//                 },
//               ),
//             ),
//           ),
//         ]
//       )
//     );
//   }

//   /// web头部
//   Widget _buildHeader(){
//     String headerTitle = this.currentUrl.replaceFirst('https://', '');
//     headerTitle = headerTitle.replaceFirst('http://', '');
//     List<String> list = headerTitle.split('/');
//     if(list.length > 0){
//       headerTitle = list[0];
//     }
//     return Container(
//       width: AppConfig.appScreenWidth,
//       height: widget.headerHeight,
//       decoration: BoxDecoration(
//         color: AppConfig.placeHolderColor,
//         borderRadius: Platform.isAndroid ? BorderRadius.only(topLeft: Radius.circular(13.0), topRight: Radius.circular(13.0)) : null,
//         // border: Border(top: BorderSide(width: 0.5, color: Colors.black12)),
//         boxShadow: [
//           BoxShadow(
//             color: const Color.fromRGBO(160, 160, 160, 0.1),
//             blurRadius: 8.0,
//             spreadRadius: 8.0,
//             offset: Offset(0.0, -4.0),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[

//           GestureDetector(
//               onTap: () async {
//                 _launchURL('${widget.url}');
//               },
//               child: Container(
//                 width: 60.0,
//                 color: Colors.red,
//                 padding: EdgeInsets.only(right: 10.0),
//                 alignment: Alignment.centerRight,
//                 child: Icon(
//                   Platform.isAndroid ? FontAwesomeIcons.chrome : FontAwesomeIcons.safari,
//                   color: Theme.of(context).textTheme.subtitle.color,
//                   size : 14.0
//                 ),
//               ),
//           ),

//           Expanded(
//             flex: 1,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Container(
//                   // margin: EdgeInsets.only(top: 4.0),
//                   alignment: Alignment.center,
//                   padding: const EdgeInsets.fromLTRB(8.0, 6.0, 8.0, 6.0),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).textTheme.title.color.withOpacity(0.12),
//                     borderRadius: BorderRadius.circular(3.0),
//                   ),
//                   child: Text(
//                     '$headerTitle',
//                     maxLines: 1,
//                     textAlign: TextAlign.center,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontSize: 14.0,
//                       color: Theme.of(context).textTheme.title.color
//                     )
//                   ),
//                 )
//               ],
//             ),
//           ),
          
//           GestureDetector(
//             child: Container(
//               width: 60.0,
//               color: Colors.transparent,
//               padding: EdgeInsets.only(left: 8.0),
//               alignment: Alignment.centerLeft,
//               child: Container(
//                 width: 20.0,
//                 height: 20.0,
//                 child: Center(
//                   child: Stack(
//                     children: <Widget>[
//                       Positioned(
//                         child: Container(
//                           width: 10.0,
//                           height: 10.0,
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               image: AssetImage('assets/images/close.png'),
//                               fit: BoxFit.cover
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               )
//             ),
//             onTap: () => Navigator.pop(context),
//           ),
          

//         ],

//       ),
//     );
//   }

//   /// 进度条显示 
//   Widget _buildProgress(){
    
//     return progress < 1.0 ?           
//       Container(
//         width: double.infinity,
//         height: this.progressHeight,
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor,
//         ),
//         child: LinearProgressIndicator(
//           backgroundColor: AppConfig.placeHolderColor.withOpacity(0.5),
//           value: progress,
//           valueColor: new AlwaysStoppedAnimation<Color>(AppConfig.primaryThemeColor),
//         ),
//       )
//       :
//       Container(
//         width: 0.0,
//         height: this.progressHeight,
//         color: Colors.transparent,
//       );
//   }

//   /// 浏览器导航
//   Widget _buildNavBar(){
//     double backBar = 50.0;
//     double iconSize = 22.0;
//     return AnimatedPositioned(       // 网页回退按钮
//       duration: Duration(milliseconds: 200),
//       curve : Curves.linear,
//       bottom: ( isOpenNavBar ) ? 0 : -backBar,
//       left: 0,
//       right: 0,
//       child: Container(
//         height: backBar,
//         decoration: BoxDecoration(
//           color: Theme.of(context).cardColor.withOpacity(0.96),
//           border: Border(top: BorderSide(width: 0.3, color: Theme.of(context).dividerColor))
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
            
//             Expanded(
//               flex: 1,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[

//                   GestureDetector(
//                     onTap: () {
//                       if( this.canGoBack ) {
//                         _inAppWebViewController?.goBack();
//                         setState(() {
//                           isOpenNavBar = false;
//                         });
//                       }
//                     },
//                     child: Container(
//                       width: 60.0,
//                       alignment: Alignment.center,
//                       color: Colors.transparent,
//                       child: Icon(
//                         // FontAwesomeIcons.chevronLeft, 
//                         CupertinoIcons.left_chevron,
//                         // Icons.chevron_left,
//                         size: iconSize, 
//                         color: this.canGoBack ? Color.fromRGBO(80, 80, 80, 1) : Color.fromRGBO(200, 200, 200, 1)
//                       ),
//                     ),
//                   ),

//                   GestureDetector(
//                     onTap: () {
//                       if( this.canGoForward ) {
//                         _inAppWebViewController?.goForward();
//                         setState(() {
//                           isOpenNavBar = false;
//                         });
//                       }
//                     },
//                     child:  Container(
//                       width: 60.0,
//                       alignment: Alignment.center,
//                       color: Colors.transparent,
//                       child: Icon(
//                           // FontAwesomeIcons.chevronRight, 
//                         CupertinoIcons.right_chevron,
//                         // Icons.chevron_right,
//                         size: iconSize, 
//                         color: this.canGoForward ? Color.fromRGBO(80, 80, 80, 1) : Color.fromRGBO(200, 200, 200, 1)
//                       ),
//                     ),
//                   ),

//                 ],
//               )
//             ),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[

//                 GestureDetector(
//                   onTap: () {
//                     ShareExtend.share('${widget.url}', 'text');
//                   },
//                   child: Container(
//                     width: 80.0,
//                     color: Colors.transparent,
//                     alignment: Alignment.centerLeft,
//                     child: CeleFaIcon(
//                       // icon: FontAwesomeIcons.solidShareSquare,
//                       icon: CupertinoIcons.share,
//                       size: iconSize,
//                       color: Theme.of(context).textTheme.subtitle.color,
//                     ),
//                   )
//                 ),
                
//               ],
//             )

//           ],
//         ),
//       )
//     );
//   }
// }

// class InAppWebBrowserScaffold extends StatefulWidget {
//   const InAppWebBrowserScaffold({
//     Key key,
//     this.title,
//     this.titleId,
//     this.url,
//   }) : super(key: key);

//   final String title;
//   final String titleId;
//   final String url;


//   @override
//   State<StatefulWidget> createState() => _InAppWebBrowserScaffoldState();
// }

// class _InAppWebBrowserScaffoldState extends State<InAppWebBrowserScaffold> {

//   double webOpacity = 0.0;
//   bool showProgress = true;

//   bool isProgressView;
//   bool isWebViewMaskShow;
//   InAppWebViewController _inAppWebViewController;
  
//   @override
//   void initState() {
//     super.initState();
//     isProgressView = true;
//     isWebViewMaskShow = true;
//   }

//   void closeProgressView() {
//     Future.delayed(Duration(milliseconds: 500), () {
//       // 加载完成 框架|页面 后，关闭动画
//       setState(() {
//         isProgressView = false;
//       });  
//     });
//   }


//   @override
//   Widget build(BuildContext context) {
    
//     Widget webView = InAppWebView(
//       initialUrl: widget.url,
//       initialHeaders: {},
//       initialOptions: {},
//       onWebViewCreated: (InAppWebViewController controller) {
//         _inAppWebViewController = controller;
//         Future.delayed(Duration(milliseconds: 300)).then((_){
//           if(mounted){
//             setState(() {
//               isWebViewMaskShow = false; 
//               this.webOpacity = 1.0;
//               this.showProgress = false;
//             });
//           }
//         });
//       },
//       onLoadStart: (InAppWebViewController controller, String url) {
//       },
//       onProgressChanged: (InAppWebViewController controller, int progress) {
//         if( progress == 100 ) {
//           closeProgressView();
//         }
//       },
//       gestureRecognizers: Set()
//       ..add(
//           Factory<VerticalDragGestureRecognizer>(
//           () => VerticalDragGestureRecognizer(),
//           ),
//       ),
//     );

//     Widget body = AnimatedOpacity(
//       opacity: this.webOpacity,
//       duration: Duration(milliseconds: 500),
//       child: Container(
//         color: Theme.of(context).cardColor,
//         padding: EdgeInsets.only(top: AppConfig.appHeaderHeight),
//         child: webView,
//       ),
//     );

//     return Scaffold(
//           body: SafeArea(
//             top: false,
//             child: Stack(
//             children: <Widget>[
//               Positioned(
//                 left: 3.0,
//                 right: 3.0,
//                 top: 0.0,
//                 bottom: 0.0,
//                 child: body,
//               ),
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0.0,
//                 child: AppHeader(
//                   title: '${widget.title}'
//                 )
//               ),
//               Positioned(
//                 top: AppConfig.appHeaderHeight,
//                 left: 0,
//                 bottom: 0.0,
//                 right: 0.0,
//                 child: Offstage(
//                   offstage: !this.showProgress,
//                   child: Container(
//                     alignment: Alignment.center,
//                     color: Theme.of(context).cardColor,
//                     child: CupertinoActivityIndicator(),
//                   ),
//                 ),
//               )
//             ],
//           )
//       )
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }

// /// ------------ 以上为马甲代码，当打包ios 发布，需注释flutter_inappbrowser 引用及一下代码，开放马甲 begin-----------
