import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

class AppConstant {

  static const String APP_NAME = 'kuvia';

  static const bool DEBUG_MODE = true;

  static const String KEY_LANGUAGE = 'key_language';

  static const int STATUS_SUCCESS = 1;

  static const String SERVER_WEB_ADDRESS = SERVER_WEB_ADDRESS_PRD;

  static const String SERVER_APP_ADDRESS = DUMEI_APP_SERVER_PRD;

  static const String SERVER_WEB_ADDRESS_PRD = "https://m.ithome.com/";

  static const String DUMEI_APP_SERVER_PRD = "https://api.ithome.com/";

  static const String KEY_THEME = 'key_theme';

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

  static double appStatusBarHeight = 0.0;
  static double appScreenWidth = 0.0;
  static double appScreenHeight = 0.0;
  static double appSearchBarHeight = 45.0;
  static double appTabBarHeight = 45.0;
  static double appHeaderHeight = appTabBarHeight + AppConfig.appStatusBarHeight;

  static bool isVideoPlaying = false;
  static int commonDuration = 350;
  static bool underWifi = false;
  static bool autoPlayVideoUnderWifi = true;
  static const double cardRadius = 8.0;
  static const bool heroOpen = false;
  static const bool heroGestures = false;

  static const Color placeHolderColor = Color.fromRGBO(240, 240, 240, 1);               //占位颜色

  static SystemUiOverlayStyle systemUiOverlayStyle;
  static double kBackGestureWidth = 120.0;

  static const Map<String, String> tabMap = {
    "newsm" : '最新',
    "rankm" : '排行榜',
    "jingdum" : '精读',
    "originalm" : '原创',
    "hotcommentm" : '上热评',
    "labsm" : '评测室',
    "livem" : '发布会',
    "5gm" : '5G',
    "specialm" : '专题',
    "balconym" : '阳台',
    "phonem" : '手机',
    "digim" : '数码',
    "geekm" : '极客学院',
    "vrm" : 'VR',
    "autom" : '智能汽车',
    "pcm" : '电脑',
    "jdm" : '京东精选',
    "androidm" : '安卓',  //0350
    "iosm" : '苹果',
    "internetm" : '网络焦点',
    "itm" : '行业前沿',
    "gamem" : '游戏电竞',
    "windowsm" : 'Windows',
    "linuxsm" : 'Linux',
    "discoverym" : '科普',
  };
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

  static const String SUCCESS = 'Success';
  static const String RESULT = 'Result';
  static const String RSS = 'rss';
  static const String CHANNEL = 'channel';
  static const String NEWSSOURCE = 'newssource';
  static const String NEWSAUTHOR = 'newsauthor';
  static const String DETAIL = 'detail';
}
