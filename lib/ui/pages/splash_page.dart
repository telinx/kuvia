import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:kuvia/blocs/bloc_index.dart';
import 'package:kuvia/common/common.dart';
import 'package:kuvia/common/sp_helper.dart';
import 'package:kuvia/models/models.dart';
import 'package:kuvia/theme/theme_provider.dart';
import 'package:kuvia/ui/config/app_routes.dart';
import 'package:kuvia/utils/util_index.dart';
import 'package:kuvia/utils/utils.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';


/// 开机启动页
class SplashPage extends StatefulWidget {
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  TimerUtil _timerUtil;
  int _status = 0;                                          // 状态0出是状态，1启动默认应用图片，2为首次启动介绍页面,3为显示广告
  int _count = 2;                                           // 倒计时
  SplashModel _splashModel;                                 // 动画对象
  Duration defaultSplashTime = Duration(milliseconds: 1000); // 默认闪屏时间
  List<String> _guideList;

  @override
  void dispose() {
    _timerUtil?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // 新安装首次启动显示图片
    if(Platform.isAndroid) {
      setState(() {
        _guideList = <String>[                       
          "assets/images/android-intro1.png",
          "assets/images/android-intro2.png",
          "assets/images/android-intro3.png",
          "assets/images/android-intro4.png",
          "assets/images/intro-5.png",
        ];
      });
    } else {
      setState(() {
        _guideList = <String>[
          "assets/images/iOS-intro1.png",
          "assets/images/iOS-intro2.png",
          "assets/images/iOS-intro3.png",
          "assets/images/iOS-intro4.png",
          "assets/images/intro-5.png",
        ];
      });
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
      
    // });

    super.initState();
    _initAsync();
  }

  /// 初始化数据
  Future _initAsync() async {
    await SpUtil.getInstance();

    bool openedAppStatus = SpUtil.getBool(AppConstant.KEY_GUIDE);
    LogUtil.v('_initAsync---------=======>>>>openedAppStatus: $openedAppStatus');
    if (openedAppStatus != true && _guideList.length > 0) { // 判断是否是第一次启动，第一次启动加载 使用介绍 图，非第一次则启动画面
      SpUtil.putBool(AppConstant.KEY_GUIDE, true);
      _status = 2;  // 1为首次启动介绍页面
    }else {
      _splashModel = SpHelper.getSplashModel();
      if(_splashModel != null){
        this._status = 3;  // 2为显示广告
        this._doCountDown();
      }else {
        _status = 1;  // 2为显示广告
      }
    }
    LogUtil.v('_initAsync---------=======>>>>_status: $_status');
    setState(() {});
  }

  /// 跳主页
  void _goMain() {
    // Navigator.pushReplacement(context, MaterialPageRoute<void>(builder: (ctx) => AppRoutes.getInstance().mainPage));
  }

  /// 倒计时播放
  void _doCountDown() {
    if(!mounted){
      return;
    }
    _timerUtil = TimerUtil(mTotalTime: _count * 1000);
    _timerUtil.setOnTimerTickCallback((int tick){
      double _tick = tick / 1000;
      setState(() => _count = _tick.toInt());
      if (_tick == 0) {
        _goMain();
      }
    });
    _timerUtil.startCountDown();
  }

  /// 默认启动页面背景
  Widget _buildDefaultSplashBg() {
    return Image.asset(
      Utils.getImgPath('splash'),
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }

  /// 
  Widget _buidAdWidget() {
    return CachedNetworkImage(
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.fill,
      imageUrl: _splashModel.imgUrl,
      placeholder: (context, url) => Container(),
      errorWidget: (context, url, error) => Container(),
    );
  }

  

   /// 设置屏幕信息
  void setScreenData(BuildContext context){
    AppConfig.appStatusBarHeight = ScreenUtil.getStatusBarH(context);
    AppConfig.appScreenWidth = ScreenUtil.getScreenW(context);
    AppConfig.appScreenHeight = ScreenUtil.getScreenH(context);
    AppConfig.kBackGestureWidth = AppConfig.appScreenWidth - 30.0;
  }

  /// 倒计时
  Widget _buildTimeWidget(BuildContext context){
    return Positioned(
      top: 30.0,
      right: 30.0,
      child: InkWell(
        onTap: () => _goMain(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Text('skip', style: new TextStyle(fontSize: 15.0, color: Colors.white),),
          decoration: BoxDecoration(
            color: Theme.of(context).textTheme.subtitle.color.withOpacity(0.7),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            border: new Border.all(width: 0.33, color: Theme.of(context).textTheme.subtitle.color.withOpacity(0.7)))
          ),
        ),
    );
  }


  @override
  Widget build(BuildContext context) {
   
    
    return Scaffold(
      body: this.buildContent(context),
    );
  }

  Widget buildContent(BuildContext context) {
    this.setScreenData(context);
    LogUtil.v('buildContent-------->>>>_status: $_status');
    if(_status == 0){
      return Container();
    }
    if(_status == 2){
      return OnBoardingPage(imageUrls: this._guideList,);
    }
    if(_status == 3){
      return Stack(
        children: <Widget>[
          this._buidAdWidget(),
          this._buildTimeWidget(context),
        ],
      );
    }
    Future.delayed(defaultSplashTime).then((_) {
      final MainBloc mainBloc = BlocProvider.of<MainBloc>(context);
      String theme = SpUtil.getString(AppConstant.KEY_THEME);
      LogUtil.e('splash theme===========${SpUtil.isInitialized()}==111>>>>$theme==${Themes.DARK.toString()}==${Themes.DARK.toString().indexOf(theme)}');
      if(ObjectUtil.isNotEmpty(theme)){
        ThemeProvider themeProvider = mainBloc.themeBloc.com ?? ThemeProvider();
        if('${Themes.DARK}'.toLowerCase().indexOf(theme.toLowerCase()) >= 0){
          themeProvider.theme = Themes.DARK;
        }else if(('${Themes.LIGHT}'.toLowerCase().indexOf(theme.toLowerCase()) >= 0)){
          themeProvider.theme = Themes.LIGHT;
        }else{
          themeProvider.theme = Themes.SYSTEM;
        }
        mainBloc.themeBloc.comData.sink.add(themeProvider);
      }
      _goMain();
    });
    return this._buildDefaultSplashBg();
  }

}

class OnBoardingPage extends StatelessWidget {

  const OnBoardingPage({Key key, this.imageUrls}) : super(key: key);
  
  final List<String> imageUrls;

  void _onIntroEnd(context) {
    // Navigator.pushReplacement(context, MaterialPageRoute<void>(builder: (ctx) => AppRoutes.getInstance().mainPage));
  }

  Widget _buildImage(int index) {
    // return Align(
    //   child: Image.network(imageUrls[index], height: 175.0),
    //   alignment: Alignment.bottomCenter,
    // );
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: GestureDetector(
        onTap: () {},
        child: Image.asset(
          imageUrls[index],
          fit : BoxFit.cover 
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    // PageDecoration pageDecoration =  PageDecoration(
    //   titleTextStyle: const TextStyle(
    //     fontSize: 22.0,
    //     fontWeight: FontWeight.w600,
    //     color: Colors.black,
    //   ),
    //   bodyTextStyle: TextStyle(
    //     fontSize: 14.0,
    //     height: 1.4,
    //     color: Theme.of(context).textTheme.subtitle.color,
    //   ),
    //   dotsDecorator: DotsDecorator(
    //     activeColor: Theme.of(context).primaryColor,
    //     activeSize: Size.fromRadius(6),
    //   ),
    //   pageColor: Colors.white,
    //   imageFlex : 10,
    //   bodyFlex : 10,
    // );
    return IntroductionScreen(
      pages: [
        PageViewModel(
          decoration: PageDecoration(
            dotsDecorator: DotsDecorator(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              activeColor: Theme.of(context).primaryColor,
              activeSize: Size.fromRadius(5.0),
            ),
            boxDecoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrls[0]),
                fit: BoxFit.cover
              ),
            ),
          ),
        ),
        PageViewModel(
          decoration: PageDecoration(
            dotsDecorator: DotsDecorator(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              activeColor: Theme.of(context).primaryColor,
              activeSize: Size.fromRadius(5.0),
            ),
            boxDecoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrls[1]),
                fit: BoxFit.cover
              ),
            ),
          ),
        ),
        PageViewModel(
          decoration: PageDecoration(
            dotsDecorator: DotsDecorator(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              activeColor: Theme.of(context).primaryColor,
              activeSize: Size.fromRadius(5.0),
            ),
            boxDecoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrls[2]),
                fit: BoxFit.cover
              ),
            ),
          ),
        ),
        PageViewModel(
          decoration: PageDecoration(
            dotsDecorator: DotsDecorator(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              activeColor: Theme.of(context).primaryColor,
              activeSize: Size.fromRadius(5.0),
            ),
            boxDecoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrls[3]),
                fit: BoxFit.cover
              ),
            ),
          ),
        ),
        PageViewModel(
          decoration: PageDecoration(
            dotsDecorator: DotsDecorator(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              activeColor: Theme.of(context).primaryColor,
              activeSize: Size.fromRadius(5.0),
            ),
            boxDecoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrls[4]),
                fit: BoxFit.cover
              ),
            ),
          ),
          title: '',
          footer: RaisedButton(
            onPressed: () {
              _onIntroEnd(context);
            },
            padding: EdgeInsets.symmetric(horizontal: 70.0),
            child: Container(
              padding: EdgeInsets.only(left: 24.0),
              width: 74.0,
              child: Row(
                children: <Widget>[
                  Text('Go', style: TextStyle(color: Colors.white, fontSize: 16.0),),
                  Icon(Icons.chevron_right, color: Colors.white, size: 24.0),
                ],
              ),
            ),
            color: Theme.of(context).primaryColor,
            elevation: 10,
          ),
        ),
      ],
      // onDone: () => _onIntroEnd(context),
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      onChange : (index) {},
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: Text(
        'Skip',
        style : TextStyle (
          fontSize: 16.0,
          color: Theme.of(context).primaryColor.withOpacity(0.8)
        )
      ),
      next: Text(
        'Next',
        style : TextStyle (
          fontSize: 16.0,
          color: Theme.of(context).primaryColor,
        )
      ),
      // next: const Icon(Icons.arrow_forward),
      done: Container(),
      // done: const Text('Got It', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor)),
      // done: Container(
      //   padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      //   decoration: BoxDecoration(
      //     color: Theme.of(context).primaryColor,
      //     borderRadius: BorderRadius.all(Radius.circular(3.0))
      //   ),
      //   child: Text('Got It', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white)),
      // )
    );
  }
}