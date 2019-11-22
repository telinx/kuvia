import 'package:kuvia/common/common.dart';

class DumeiAndroidApi {

  /// 首页banner http://www.wanandroid.com/banner/json
  static const String BANNER = "banner";

  static String getPath({String path: '', int page, String resType: 'json'}) {
    StringBuffer sb = new StringBuffer(Constant.SERVER_ADDRESS + path);
    if (page != null) {
      sb.write('/$page');
    }
   
    return sb.toString();
  }
  
}
