import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kuvia/resources/colors.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kuvia/common/common.dart';
import 'package:http/http.dart' as http;

class Utils {
  static String getImgPath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }

  static void showCheckNetworkTip({String tip = "Oops! Wait A Moment Or Check Your NetWork~"}){
    Fluttertoast.showToast(
      msg: tip,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 2,
      backgroundColor: Colors.black38,
      textColor: Colors.white,
      fontSize: 14.0
    );
  }
 
  static Color getCircleAvatarBg(String key) {
    return circleAvatarMap[key];
  }


  static Color nameToColor(String name) {
    // assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  static String getTimeLine(BuildContext context, int timeMillis) {
    return TimelineUtil.format(timeMillis,
        locale: Localizations.localeOf(context).languageCode,
        dayFormat: DayFormat.Common);
  }

  static double getTitleFontSize(String title) {
    if (ObjectUtil.isEmpty(title) || title.length < 10) {
      return 18.0;
    }
    int count = 0;
    List<String> list = title.split("");
    for (int i = 0, length = list.length; i < length; i++) {
      String ss = list[i];
      if (RegexUtil.isZh(ss)) {
        count++;
      }
    }

    return (count >= 10 || title.length > 16) ? 14.0 : 18.0;
  }

  /// 0
  /// -1
  /// 1
  static int getUpdateStatus(String version) {
    String locVersion = AppConfig.version;
    int remote = int.tryParse(version.replaceAll('.', ''));
    int loc = int.tryParse(locVersion.replaceAll('.', ''));
    if (remote <= loc) {
      return 0;
    } else {
      return (remote - loc >= 2) ? -1 : 1;
    }
  }

  static String weekdayFormatter(int weekday){
    switch (weekday) {
      case 1:
        return 'Monday';
        break;
      case 2:
        return 'Tuesday';
        break;
      case 3:
        return 'Wednesday';
        break;
      case 4:
        return 'Thursday';
        break;
      case 5:
        return 'Friday';
        break;
      case 6:
        return 'Saturday';
        break;
      case 7:
        return 'Sunday';
        break;
      default:
        return 'Monday';
        break;
    }
  }
  
  static String monthFormatter(int month){
    switch (month) {
      case 1:
        return 'January';
        break;
      case 2:
        return 'February';
        break;
      case 3:
        return 'March';
        break;
      case 4:
        return 'April';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'June';
        break;
      case 7:
        return 'July';
        break;
      case 8:
        return 'August';
        break;
      case 9:
        return 'September';
        break;
      case 10:
        return 'October';
        break;
      case 11:
        return 'November';
        break;
      case 12:
        return 'December';
        break;
      default:
        return 'January';
        break;
    }
  }

  static forbidNull(String val){
    return ObjectUtil.isEmpty(val) ? '' : val;
  }

  /// 恒大于等于0
  static int greaterThanOrEqualZero(int val){
    return val == null || val < 0 ? 0 : val;
  }

  static void launchURL(url) async {
      if (await canLaunch(url)) {
        await launch(
          url,
          forceSafariVC : false,
          forceWebView : false,
          enableJavaScript : true
        );
      } else {
        throw 'Could not launch $url';
      }
    }


  /*
  * Base64加密
  */
  static String encodeBase64(String data){
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  /*
  * Base64解密
  */
  static String decodeBase64(String data){
    return String.fromCharCodes(base64Decode(data));
  }
  
  static Map<String, String> headers = {
    'Connection': 'keep-alive',
    'Upgrade-Insecure-Requests': '1',
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
    'Accept-Encoding': 'gzip, deflate',
    'Accept-Language': 'en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7,zh-TW;q=0.6,la;q=0.5,it;q=0.4',
  };


  /// 获取Youtube的视频地址
  static Future<String> fetchVideoURL(String yt) async {
    // yt = yt.replaceAll('https://www', 'https://m');
    print('fetchVideoURL------->>>>>>yt: $yt');
    final response = await http.get(yt);
    Iterable<String> parseAll = allStringMatches(response.body, RegExp("\"url_encoded_fmt_stream_map\":\"([^\"]*)\""));
    final Iterable<String> parse = allStringMatches(parseAll.toList()[0], RegExp("url=(.*)"));
    final List<String> urls = parse.toList()[0].split('url=');
    parseAll = allStringMatches(urls[1], RegExp("([^&,]*)[&,]"));
    String finalUrl = Uri.decodeFull(parseAll.toList()[0]);
    if(finalUrl.indexOf('\\u00') > -1)
      finalUrl = finalUrl.substring(0, finalUrl.indexOf('\\u00'));
    print('fetchVideoURL------->>>>>>finalUrl: $finalUrl');
    return finalUrl;
  }

  /// 通过获取html的body的键值对
  static Iterable<String> allStringMatches(String text, RegExp regExp) => regExp.allMatches(text).map((m) => m.group(0));

  /// 获取Youtube的视频主图
  static String videoThumbURL(String yt) {
    String id = yt.substring(yt.indexOf('v=') + 2);
    if(id.contains('&'))
      id = id.substring(0, id.indexOf('&'));
    return "http://img.youtube.com/vi/$id/0.jpg";
  }

  /// 转成int
  static int tranfer2Int(dynamic val){
    if(val == null || val == "") return 0;
    return int.parse('$val'.trim());
  }

  /// 转成bool
  static bool tranfer2Bool(dynamic val){
    if(val == null || val == "") return false;
    if('$val'.toLowerCase().trim() == "true") return true;
    return false;
  }

  /// 两边去空
  static String trimData(dynamic val){
    return ObjectUtil.isEmpty(val) ? val : '$val'.trim();
  }

  /// 两边去空
  static String filterNullString(dynamic val){
    return val ?? '';
  }

  /// decode response data.
  static Map<String, dynamic> decodeData(Response response) {
    if (response == null ||
        response.data == null ||
        response.data.toString().isEmpty) {
      return Map<String, dynamic>();
    }
    return json.decode(response.data.toString());
  }

}
