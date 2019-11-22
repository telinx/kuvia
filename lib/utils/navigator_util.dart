import 'dart:io';

import 'package:kuvia/blocs/bloc_index.dart';
import 'package:kuvia/common/common.dart';
import 'package:kuvia/common/sp_helper.dart';
import 'package:kuvia/ui/config/app_routes.dart';
import 'package:kuvia/ui/widgets/in_app_web_browser.dart';
import 'package:kuvia/ui/widgets/web_scaffold.dart';
import 'package:kuvia/utils/event_bus_box.dart';
import 'package:kuvia/utils/extended_cupertino_page_route.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigatorUtil {
  static Future pushPage(
    BuildContext context, 
    Widget page, 
    {
      bool replace = false, 
      bool isInitialRoute = false, 
      bool maintainState = true, 
      bool fullscreenDialog = false,
      bool useXCupertinoPageRoute = false,
      bool isWideGesture = true, // 是否是宽收视返回
      Object arguments 
    }) {
      
    if (context == null || page == null) return null;

    if(AppConfig.isVideoPlaying){
      eventBus.fire(CurrentPlayVideoEvent(null, doPause: true));
    }

    if(replace){
      if(useXCupertinoPageRoute){
        return showXCupertinoModalReplacement(
          context: context,
          builder: (ctx) => page, 
        ).then((val) {
            // print(val);
        });
      } else{
        return Navigator.pushReplacement(
          context, XCupertinoPageRoute<void>(
            builder: (ctx) => page, 
            settings: RouteSettings(
              isInitialRoute: isInitialRoute
            ),
            maintainState : maintainState,
            fullscreenDialog: fullscreenDialog,
          )
        );
      }
    }
    
    if(useXCupertinoPageRoute){
      return showXCupertinoModalPopup(
        context: context,
        builder: (ctx) => page, 
        isWideGesture: isWideGesture
      ).then((val) {
          // print(val);
      });
    } else{
      return Navigator.push(
        context, 
        XCupertinoPageRoute<void>(
          builder: (ctx) => page, 
          settings: RouteSettings(
            isInitialRoute: isInitialRoute
          ),
          maintainState : maintainState,
          fullscreenDialog: fullscreenDialog,
          isWideGesture: isWideGesture
        )
      );
    }
    
  }

  static Future pushByPageName(BuildContext context, String pageName, {replace = false}) {
    if (context == null || ObjectUtil.isEmpty(pageName)) return null;
    if(!replace){
      return Navigator.pushNamed(context, pageName);
    } else{
      return Navigator.pushReplacementNamed(context, pageName);
    }
    
  }

   static void pushWeb(BuildContext context,{String title, String titleId, String url, bool isHome: false}) {
    LogUtil.v("pushWeb: -------------->>>>>$url");
    if (context == null || ObjectUtil.isEmpty(url)) return;
    if (url.endsWith(".apk")) {
      launchInBrowser(url, title: title ?? titleId);
    } else {
      Widget webWidget = Platform.isAndroid ? 
        InAppWebBrowserScaffold(
          title: title,
          titleId: titleId,
          url: url,
        ) 
      : 
        WebScaffold(
          title: title,
          titleId: titleId,
          url: url,
        );

      // Widget webWidget = WebScaffold(
      //   title: title,
      //   titleId: titleId,
      //   url: 'https://36kr.com/p/5265703',
      // );


      Navigator.push(
        context, 
        XCupertinoPageRoute<void>(
          builder: (ctx) => webWidget, 
        )
      );
   }
  }

  static Future<Null> launchInBrowser(String url, {String title}) async {
    // LogUtil.v("launchInBrowser: -------------->>>>>");
    if (await canLaunch(url)) {
      await launch(
        url, 
        forceSafariVC: false, 
        forceWebView: false,
        enableJavaScript : true
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<Null> launchThirdPartyUrl(BuildContext context, {String title, String url, String articleId, bool isAddToHistory = false}) async {

    if(Platform.isAndroid){
      InAppWebBrowser.openInappbrowser(
        title: title,
        url: url
      );
    }else if(Platform.isIOS){
      // if(AppConfig.appCenterVerifyStatus ){
      //   Utils.launchURL(url);
      // }else{
        // NavigatorUtil.pushPage(
        //   context, 
        //   AppRoutes.getInstance().loadWebviewPage(
        //     title: title,
        //     url: url,
        //     articleId : articleId,
        //   ),
        //   fullscreenDialog : true,
        //   isInitialRoute: false,
        //   useXCupertinoPageRoute: true,
        //   isWideGesture: false
        // );
      }
    // }
  }
}
