import 'package:kuvia/utils/util_index.dart';
import 'package:flutter/material.dart';

// 以下为马甲代码，真是发布时需更改为in_app_web_browser_bak
class InAppWebBrowser{
  static void openInappbrowser({@required String url, String title, String articleId ,bool isAddToHistory}){
    LogUtil.e('《《《《《-------使用马甲代码中-------》》》》》');
  }
}
class InAppWebBrowserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Center(child: Text('马甲代码'),),),
    );
  }
}

class InAppWebBrowserScaffold extends StatelessWidget {
  const InAppWebBrowserScaffold({
    Key key,
    this.title,
    this.titleId,
    this.url,
  }) : super(key: key);

  final String title;
  final String titleId;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Center(child: Text('马甲代码'),),),
    );
  }

}
