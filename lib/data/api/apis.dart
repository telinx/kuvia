import 'package:kuvia/common/common.dart';

class DumeiApi {

  static const String BANNER = "${AppConstant.SERVER_APP_ADDRESS}xml/slide/slide.xml";                        // 详情
  static const String NEWSCONTENT = "${AppConstant.SERVER_APP_ADDRESS}xml/newscontent/${0}/${1}.xml";         // 文章详情
  static const String RELATENEWS = "${AppConstant.SERVER_APP_ADDRESS}json/tags/${0}/${1}.json";               // 相关文章
  static const String RANK = "${AppConstant.SERVER_APP_ADDRESS}json/newslist/rank";                     // 排行榜

  static const String NEWSLIST = "${AppConstant.SERVER_WEB_ADDRESS}api/news/newslistpageget";                 // 列表文章

}
