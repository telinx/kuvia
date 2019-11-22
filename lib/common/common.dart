import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

class Constant {

  static const String APP_NAME = 'kuvia';

  static const bool DEBUG_MODE = true;

  static const String KEY_LANGUAGE = 'key_language';

  static const int STATUS_SUCCESS = 0;

  static const String SERVER_ADDRESS = DUMEI_SERVER_PRD;

  static const String DUMEI_SERVER_PRD = "https://www.kuvia.com/";
  static const String DUMEI_SERVER = "http://192.168.1.4:8082/";
  static const String DUMEI_SERVER_DEV = 'http://dev.aidumei.com/';
  static const int TYPE_SYS_UPDATE = 1;
  static const String KEY_THEME = 'key_theme';
  static const String KEY_THEME_COLOR = 'key_theme_color';
  static const String KEY_GUIDE = 'key_guide';
  static const String KEY_SPLASH_MODEL = 'key_splash_models';
  static const String KEY_FONT_SIZE_SCALE = 'key_font_size_SCALE';
}

class AppConfig {
  static PackageInfo packageInfo;
  static String appVersion = '1.0.6';
  static const String appName = 'kuvia';
  static const String version = '0.0.1';
  static bool appCenterVerifyStatus = false; //用户是否显示外链和用自带浏览器打开
  static const double appBarHeight = 0.055;
  static const double appElevation = 0.5;
  static const double appBottomBarHeight = 0.07;
  static const double appBottomNaviHeight = 50.0;
  static const double appArticleTitleFontSizeScale = 1.0;
  static const String followErrorImg = 'https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=2968111742,3263885643&fm=58&bpow=551&bpoh=640';
  static double statusBarHeight = 0.0;
  static double appScreenWidth = 0.0;
  static double appScreenHeight = 0.0;
  static double searchBarHeight = 45.0;
  static int commonDuration = 350;
  static double tabBarHeight = 45.0;
  static double appHeaderHeight = tabBarHeight + AppConfig.statusBarHeight;
  static bool underWifi = false;
  static bool autoPlayVideoUnderWifi = true;
  static const double cardRadius = 8.0;
  static const bool heroOpen = false;
  static const bool heroGestures = false;

    static bool isVideoPlaying = false;
      static const Color placeHolderColor = Color.fromRGBO(240, 240, 240, 1);               //占位颜色


  

  static SystemUiOverlayStyle systemUiOverlayStyle;

  static double kBackGestureWidth = 120.0;

}

class AppLocalLabel{
 

}

class AppHttpConstant {
  static const String APP_VERSION = 'appVersion';
  static const String USER_ID = 'userId';
  static const String PAGE_NUM = 'pageNum';
  static const String PAGEING_STATE = 'pagingState';
  static const String HAS_NEXT = 'hasNext';
  static const String PAGE_SIZE = 'pageSize';
  static const String TOTAL = 'total';
  static const String ROWS = 'rows';
}
