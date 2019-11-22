import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:kuvia/common/common.dart';
import 'package:kuvia/utils/util_index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserCenter extends StatefulWidget {

  @override
  _UserCenterState createState() => _UserCenterState();

}
class _UserCenterState extends State<UserCenter> {

  ScrollController scrollController;

  double marginTop;
  double blankTop;
  double scale = 1.0;
  double topBarOpacity = 0.0;
  double topBarIconOpacity = 1.0;
  Color topBarIconColor = Colors.white;

  double topBarHeight = 40.0;
  double nearTopBarHeight = 20.0;

  @override
  void initState() {
    super.initState();

    this.marginTop = 135.0 + AppConfig.statusBarHeight;
    this.blankTop = this.marginTop;
    scrollController = ScrollController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this.scrollController.addListener(() {
        double offset = this.scrollController.offset.toDouble();

        this.marginTop = this.blankTop - offset;
        if(offset < 0){
          this.scale = (this.blankTop - offset/10)/this.blankTop ;
        }

        double proximityPoint = this.topBarHeight + this.nearTopBarHeight + ScreenUtil.getStatusBarH(context);
        double result = offset + proximityPoint - this.blankTop;
        if(result > 0){
          this.topBarOpacity = result/proximityPoint > 1.0 ? 1.0 : result/proximityPoint;
          if(result >= this.nearTopBarHeight){
            this.topBarIconOpacity = (result - this.nearTopBarHeight)/(proximityPoint-this.nearTopBarHeight) > 1.0 ? 1.0 : (result - this.nearTopBarHeight)/(proximityPoint-this.nearTopBarHeight);
            this.topBarIconColor = Colors.black;
          }else{
            this.topBarIconOpacity = (this.nearTopBarHeight-result)/this.nearTopBarHeight;
            this.topBarIconColor = Colors.white;
          }
        }else {
          this.topBarOpacity = 0.0;
          this.topBarIconOpacity = 1.0;
          this.topBarIconColor = Colors.white;
        }

        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        // bottom: false,
        child: Stack(
          children: <Widget>[
            Transform.scale(
              scale: this.scale,
              child: Container(
                height: ScreenUtil.getScreenH(context),
                width: AppConfig.appScreenWidth,
                // margin: EdgeInsets.only(bottom: this.blankTop),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider('https://www.yidianzhidao.com/UploadFiles/img_0_2610790302_2863774598_15.jpg'),
                    fit: BoxFit.cover
                  )
                ),
              ),
            ),

            ClipRect(  //裁切长方形
              child: BackdropFilter(   //背景滤镜器
                filter: ImageFilter.blur(sigmaX: 25.0,sigmaY: 25.0), //图片模糊过滤，横向竖向都设置5.0
                child: Opacity( //透明控件
                  opacity: 0.5,
                  child: Container(// 容器组件
                    width: AppConfig.appScreenWidth,
                    height: ScreenUtil.getScreenH(context),
                    decoration: BoxDecoration(color:Colors.grey.shade200), //盒子装饰器，进行装饰，设置颜色为灰色
                  ),
                ),
              )
            ),

            AnimatedPositioned(
              duration: Duration(milliseconds: 0),
              curve : Curves.linear,
              top: this.marginTop,
              left: 0,
              right: 0,
              bottom: -2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                ),
              ),
            ),

            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: SingleChildScrollView(
                  controller: this.scrollController,
                  physics: BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: ScreenUtil.getScreenH(context) + 5.0,
                    ),
                    // height: ScreenUtil.getScreenH(context) + 10.0,
                    child: Column(
                      children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: this.blankTop - 45.0),
                      width: AppConfig.appScreenWidth,
                      height: this.blankTop + 45.0,
                      // color: Colors.red,
                      // color: Colors.black.withOpacity(0.03),
                      child: Center(
                        child: Container(
                          width: 90.0,
                          height: 90.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider('https://www.yidianzhidao.com/UploadFiles/img_0_2610790302_2863774598_15.jpg'), fit: BoxFit.cover),
                            border: Border.all(color: Colors.white,width: 1.0,),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 6.0,
                                spreadRadius: 2.0,
                                offset: Offset(-0.0, 2.0),
                              ),
                            ]
                          ),
                        ),
                      ),
                    ),

                    Container(
                      alignment: Alignment.center,
                      height: 30.0,
                      child: Text('Login / Rregister', style: TextStyle(fontWeight: FontWeight.w600),),
                    ),

                    // Container(
                    //   height: 85.0,
                    //   padding: EdgeInsets.only(left: 50.0, right: 50.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: <Widget>[
                    //       Image.asset("assets/images/facebook1.png",width: 33.0,),
                    //       Image.asset("assets/images/google1.png",width: 36.0,),
                    //     ],
                    //   ),
                    // ),

                    Container(
                      height: 85.0,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              color: Colors.black12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 7.0),
                                    child: Text('0', style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.w600,color: Colors.black)),
                                  ),
                                  Text('Following', style: TextStyle(fontSize: 13.0, color: Colors.black38)),
                                ],
                              ),
                            ),
                            flex: 1,
                          ),

                          Expanded(
                            child: Container(
                              color: Colors.black26,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 7.0),
                                    child: Text('0', style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.w600,color: Colors.black)),
                                  ),
                                  Text('Commented', style: TextStyle(fontSize: 13.0, color: Colors.black38)),
                                ],
                              ),
                            ),
                            flex: 1,
                          ),

                          Expanded(
                            child: Container(
                              color: Colors.black38,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 7.0),
                                    child: Text('0', style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.w600,color: Colors.black)),
                                  ),
                                  Text('Favorites', style: TextStyle(fontSize: 13.0, color: Colors.black38)),
                                ],
                              ),
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      height: 50.0,
                      width: AppConfig.appScreenWidth,
                      color: Colors.white,
                      child: Container(
                        height: 45.0,
                        color: Colors.black.withOpacity(0.03),
                        child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Icon(Icons.history, color: Colors.black26, size: 17.0,),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text('History'),
                            flex: 8,
                          ),
                          Expanded(
                            child: Icon(Icons.chevron_right, color: Colors.black26, size: 20.0,),
                            flex: 2,
                          ),
                        ],
                      ),
                      ),
                    ),

                    

                    


                    

                    
                    

                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      height: 50.0,
                      width: AppConfig.appScreenWidth,
                      color: Colors.black.withOpacity(0.03),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Icon(Icons.history, color: Colors.black26, size: 17.0,),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text('History'),
                            flex: 8,
                          ),
                          Expanded(
                            child: Icon(Icons.chevron_right, color: Colors.black26, size: 20.0,),
                            flex: 2,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      height: 50.0,
                      width: AppConfig.appScreenWidth,
                      color: Colors.black.withOpacity(0.03),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Icon(Icons.history, color: Colors.black26, size: 17.0,),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text('History'),
                            flex: 8,
                          ),
                          Expanded(
                            child: Icon(Icons.chevron_right, color: Colors.black26, size: 20.0,),
                            flex: 2,
                          ),
                        ],
                      ),
                    ),


                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      height: 50.0,
                      width: AppConfig.appScreenWidth,
                      color: Colors.black.withOpacity(0.03),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Icon(Icons.history, color: Colors.black26, size: 17.0,),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text('History'),
                            flex: 8,
                          ),
                          Expanded(
                            child: Icon(Icons.chevron_right, color: Colors.black26, size: 20.0,),
                            flex: 2,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      height: 50.0,
                      width: AppConfig.appScreenWidth,
                      color: Colors.black.withOpacity(0.03),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Icon(Icons.history, color: Colors.black26, size: 17.0,),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text('History'),
                            flex: 8,
                          ),
                          Expanded(
                            child: Icon(Icons.chevron_right, color: Colors.black26, size: 20.0,),
                            flex: 2,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      height: 50.0,
                      width: AppConfig.appScreenWidth,
                      color: Colors.black.withOpacity(0.03),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Icon(Icons.history, color: Colors.black26, size: 17.0,),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text('History'),
                            flex: 8,
                          ),
                          Expanded(
                            child: Icon(Icons.chevron_right, color: Colors.black26, size: 20.0,),
                            flex: 2,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      height: 50.0,
                      width: AppConfig.appScreenWidth,
                      color: Colors.black.withOpacity(0.03),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Icon(Icons.history, color: Colors.black26, size: 17.0,),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text('History'),
                            flex: 8,
                          ),
                          Expanded(
                            child: Icon(Icons.chevron_right, color: Colors.black26, size: 20.0,),
                            flex: 2,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      height: 50.0,
                      width: AppConfig.appScreenWidth,
                      color: Colors.black.withOpacity(0.03),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Icon(Icons.history, color: Colors.black26, size: 17.0,),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text('History'),
                            flex: 8,
                          ),
                          Expanded(
                            child: Icon(Icons.chevron_right, color: Colors.black26, size: 20.0,),
                            flex: 2,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      height: 50.0,
                      width: AppConfig.appScreenWidth,
                      color: Colors.black.withOpacity(0.03),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Icon(Icons.history, color: Colors.black26, size: 17.0,),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text('History'),
                            flex: 8,
                          ),
                          Expanded(
                            child: Icon(Icons.chevron_right, color: Colors.black26, size: 20.0,),
                            flex: 2,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      height: 50.0,
                      width: AppConfig.appScreenWidth,
                      color: Colors.black.withOpacity(0.03),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Icon(Icons.history, color: Colors.black26, size: 17.0,),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text('History'),
                            flex: 8,
                          ),
                          Expanded(
                            child: Icon(Icons.chevron_right, color: Colors.black26, size: 20.0,),
                            flex: 2,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      height: 50.0,
                      width: AppConfig.appScreenWidth,
                      color: Colors.black.withOpacity(0.03),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Icon(Icons.history, color: Colors.black26, size: 17.0,),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text('History'),
                            flex: 8,
                          ),
                          Expanded(
                            child: Icon(Icons.chevron_right, color: Colors.black26, size: 20.0,),
                            flex: 2,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      height: 50.0,
                      width: AppConfig.appScreenWidth,
                      color: Colors.black.withOpacity(0.03),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Icon(Icons.history, color: Colors.black26, size: 17.0,),
                            flex: 2,
                          ),
                          Expanded(
                            child: Text('History'),
                            flex: 8,
                          ),
                          Expanded(
                            child: Icon(Icons.chevron_right, color: Colors.black26, size: 20.0,),
                            flex: 2,
                          ),
                        ],
                      ),
                    ),

                    
                    
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.0),
                    ),
                  ]
                    ),
                  ),
              ),

            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: this.topBarOpacity,
                duration: Duration(milliseconds: 100),
                child: Container(
                  alignment: Alignment.center,
                  height: this.topBarHeight + ScreenUtil.getStatusBarH(context),
                  color: Colors.white,
                ),
              ),
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: this.topBarIconOpacity,
                duration: Duration(milliseconds: 100),
                child: Container(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: ScreenUtil.getStatusBarH(context) + 5.0),
                  alignment: Alignment.topCenter,
                  height: this.topBarHeight + ScreenUtil.getStatusBarH(context),
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(CupertinoIcons.back, color: this.topBarIconColor),
                      Container(
                        width: 60.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(Icons.share, color: this.topBarIconColor, size: 18.0,),
                            // Icon(CupertinoIcons.share_solid, color: this.topBarIconColor),
                            Icon(Icons.settings, color: this.topBarIconColor ,size: 18.0,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
  
}
