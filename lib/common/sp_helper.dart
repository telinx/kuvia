import 'package:kuvia/utils/util_index.dart';
import 'package:flustars/flustars.dart';
import 'package:kuvia/common/common.dart';
import 'package:kuvia/models/models.dart';

class SpHelper {
  // T 用于区分存储类型
  static void putObject<T>(String key, Object value) {
    switch (T) {
      case int:
        SpUtil.putInt(key, value);
        break;
      case double:
        SpUtil.putDouble(key, value);
        break;
      case bool:
        SpUtil.putBool(key, value);
        break;
      case String:
        SpUtil.putString(key, value);
        break;
      case List:
        SpUtil.putStringList(key, value);
        break;
      default:
        SpUtil.putObject(key, value);
        break;
    }
  }

  static LanguageModel getLanguageModel() {
    Map map = SpUtil.getObject(AppConstant.KEY_LANGUAGE);
    return map == null ? null : LanguageModel.fromJson(map);
  }

  static SplashModel getSplashModel() {
    Map map = SpUtil.getObject(AppConstant.KEY_SPLASH_MODEL);
    return map == null ? null : SplashModel.fromJson(map);
  }

    static double getFontSizeScale() {
    return SpUtil.getDouble(AppConstant.KEY_FONT_SIZE_SCALE, defValue: 1.0);
  }

}
