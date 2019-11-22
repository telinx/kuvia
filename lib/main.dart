import 'dart:async';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:kuvia/blocs/bloc_index.dart';
import 'package:kuvia/common/common.dart';
import 'package:kuvia/data/net/dio_util.dart';
import 'package:kuvia/theme/theme_provider.dart';
import 'package:kuvia/ui/pages/page_index.dart';
import 'package:kuvia/ui/pages/splash_page.dart';
// import 'package:fluintl/fluintl.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:tip_dialog/tip_dialog.dart';


Future main() async {
  // Admob.initialize(AppConfig.admodAppId);
  // 强制竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
   // 透明状态栏
  // runApp(BlocProvider(child: MyApp(), bloc: MainBloc()));
  runApp(MaterialApp(home: ListWidget(),));
  SystemUiOverlayStyle systemUiOverlayStyle =
  SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  
}

// String getAppId() {
//   if (Platform.isIOS) {
//     return 'ca-app-pub-3940256099942544~1458002511';
//   } else if (Platform.isAndroid) {
//     return 'ca-app-pub-3940256099942544~3347511713';
//   }
//   return null;
// }



class MyApp extends StatelessWidget {


  void _initAsync(MainBloc mainBloc) {
    SpUtil.getInstance().then((_){
      // mainBloc.initUserModelData();
      // mainBloc.initUserFollowModelList();
      // mainBloc.initHistoryForYouData();  //因网络判断问题改为SpHelper.forYouArticleModelList 静态方式
    });
  }
 
  @override
  Widget build(BuildContext context) {
    LogUtil.debuggable = AppConstant.DEBUG_MODE;
    DioUtil.setDebug(AppConstant.DEBUG_MODE);
    final MainBloc mainBloc = BlocProvider.of<MainBloc>(context);
    _initAsync(mainBloc);
    LogUtil.v('Main---->AppLocalLabel.homeTabs------getData--build');
    // mainBloc.tabModelListBloc.getData(labelId: AppLocalLabel.homeTabs);       // 初始化app数据

    return TipDialogContainer(
      child: StreamBuilder(
      stream: mainBloc.themeBloc.comStream,
      builder: (BuildContext context, AsyncSnapshot<ThemeProvider> snapshot){
        ThemeProvider themeProvider = snapshot.data ?? ThemeProvider(theme: Themes.SYSTEM);
        return MaterialApp(
            theme: themeProvider.getTheme(),
            darkTheme:  themeProvider.getTheme(isDarkMode: true),
            home: SplashPage(),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
      }),
    );
  }
}


class ListWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView.builder(
          cacheExtent:30,
          itemCount: 500,
          itemBuilder: (BuildContext context, index){
              return Container(
              height: 300,
              color: Colors.black12,
              margin: EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: Text('----->>>$index', style: TextStyle(fontSize: 30.0)),
              ),
            );
          },
        ),
      ),
    );
  }
}