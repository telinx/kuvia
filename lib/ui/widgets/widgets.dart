import 'dart:ui';

// import 'package:kuvia/resources/colors.dart';
import 'package:kuvia/common/sp_helper.dart';
import 'package:kuvia/resources/colors.dart';
import 'package:kuvia/utils/util_index.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kuvia/common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'dart:math' as math;

class ProgressView extends StatelessWidget {
  // SpinKitWave(color: Colors.black26, type: SpinKitWaveType.start),
  
  ProgressView({
    Key key,
    this.padding = const EdgeInsets.only(bottom: 168.0),
  }) : super(key: key);

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding,
        child: Center(
          child : CupertinoActivityIndicator()
        ),
      );
  }
}


class InheritedContext<T> extends InheritedWidget {
  
  final Widget child;
  final T data;
  final Function() function;

  InheritedContext(
    {
      Key key, 
      @required this.data,
      @required this.function, 
      @required this.child
    }
  ) : super(key: key, child: child);

  static InheritedContext<T> of<T> (BuildContext context){
    final type = _typeOf<InheritedContext<T>>();
    InheritedContext<T> inheritedContext = context.inheritFromWidgetOfExactType(type);
    return inheritedContext;
  }

  static Type _typeOf<T>() => T;

  @override
  bool updateShouldNotify(InheritedContext oldWidget) {
    return this.data != oldWidget.data;
  }

}



class CeleStylesWidgets{

  static Color videoPLHColor = Colors.black.withOpacity(0.4);
  static double videoIconSize = 22.0;
  static double videoIconBoxSize = 50.0;
  static double titleHeight = 30.0;
  
  static Widget getForYouImgPlaceholderWidget(BuildContext context, double cardRadius, double fontSize){
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppConfig.placeHolderColor.withOpacity(0.5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(cardRadius)),
        ),
        child: Center(
          child: Text(
            'CELESTYLE',
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'cele',
              fontWeight: FontWeight.bold,
              height: 1.1,
              decoration: TextDecoration.none,
              color: Theme.of(context).textTheme.subtitle.color,
            )
          )
        )
      );
  }

  static Widget getImgPlaceholderWidget(BuildContext context, double cardRadius, double fontSize){
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppConfig.placeHolderColor.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
        ),
        child: Center(
          child: Text(
            'CELESTYLE',
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'cele',
              fontWeight: FontWeight.bold,
              height: 1.1,
              decoration: TextDecoration.none,
              color: Theme.of(context).textTheme.subtitle.color.withOpacity(0.4)
            )
          )
        )
      );
  }

  // video group
  static Widget getVideoPlayPlaceholder(){
    return Container(
        width: videoIconBoxSize,
        height: videoIconBoxSize,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: videoPLHColor, 
          shape: BoxShape.circle,
        ),
        // child: Icon(Icons.play_arrow, size: videoIconSize, color: Colors.white),
        child: Center(
          child: CeleFaIcon(
            icon: FontAwesomeIcons.play,
            size: videoIconSize,
            color: Colors.white,
            left: 4,
          ),
        )
    );
  }

  static Widget getVideoPausePlaceholder(){
    return Container(
        width: videoIconBoxSize,
        height: videoIconBoxSize,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: videoPLHColor,
          shape: BoxShape.circle,
        ),
        // child: Icon(Icons.pause, size: videoIconSize, color: Colors.white),
        child: Center(
          child: CeleFaIcon(
            icon: FontAwesomeIcons.pause,
            size: videoIconSize,
            color: Colors.white
          ),
        )
    );
  }

  static Widget getVideoReplayPlaceholder(){
    return Container(
        width: videoIconBoxSize,
        height: videoIconBoxSize,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: videoPLHColor,
          shape: BoxShape.circle,
        ),
        // child: Icon(Icons.replay, size: videoIconSize, color: Colors.white),
        child: Center(
          child: CeleFaIcon(
            icon: FontAwesomeIcons.redoAlt,
            size: videoIconSize,
            color: Colors.white
          ),
        )
    );
  }

}


class CeleAvatar extends StatelessWidget {

  CeleAvatar({
     Key key,
    this.avatarWidth = 61.0,
    this.avatarHeight = 61.0,
    this.border,
    @required this.avatarUrl,
    this.hasBorder = true,
  }) : borderWidth = avatarWidth * 0.01, 
    super(key: key);

  final double avatarWidth;
  final double avatarHeight;
  final BoxBorder border;
  final double borderWidth;
  final String avatarUrl;
  final bool hasBorder;
  
  Widget build(BuildContext context) {
    return Container(
      width: avatarHeight,
      height: avatarWidth,
      padding: EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: AppConfig.placeHolderColor,
        shape: BoxShape.circle,
        border: hasBorder && border == null ? Border.all(color: Theme.of(context).textTheme.subtitle.color, width: this.borderWidth) : border ,
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: this.avatarUrl == null ? AssetImage('assets/images/avatar_default.png') : CachedNetworkImageProvider(this.avatarUrl),
            fit: BoxFit.cover,
          ),
        ),
      )
    );  
  }
}

// 默认头像
class AssetAvatar extends StatelessWidget {

  AssetAvatar({
    Key key,
    this.avatarWidth = 41.0,
    this.avatarHeight = 41.0,
    this.assetUrl = "assets/images/avatar_default.png",
    this.hasBorder = true,
  }) : borderWidth = avatarWidth * 0.01, 
    super(key: key);

  final double avatarWidth;
  final double avatarHeight;
  final String assetUrl;
  final double borderWidth;
  final bool hasBorder;
  
  Widget build(BuildContext context) {
    return Container(
            width: avatarHeight,
            height: avatarWidth,
            padding: EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: hasBorder ? Border.all(color: Theme.of(context).textTheme.subtitle.color, width: this.borderWidth) : null,
            ),
            child: Stack(
                children: <Widget>[
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(assetUrl),
                                fit: BoxFit.cover
                              ),
                            ),
                          ),
                        ),
                ],
              )
          );  
    

  }
}

class PlaceholderAvatar extends StatelessWidget {

  PlaceholderAvatar({
    Key key,
    this.width = 40.0,
    this.height = 40.0,
    this.color
  }) : super(key: key);

  final double width;
  final double height;
  final Color color;
  
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color == null ? AppConfig.placeHolderColor.withOpacity(0.5) : color,
      ),
    );  
  }
}

class WordAvatar extends StatelessWidget {

  WordAvatar({
    Key key,
    this.avatarWidth = 41.0,
    this.avatarHeight = 41.0,
    this.word = "A",
  }) : borderWidth = avatarWidth * 0.01, 
    super(key: key);

  final double avatarWidth;
  final double avatarHeight;
  final String word;
  final double borderWidth;
  
  Widget build(BuildContext context) {
    String letter = this.word.substring(0, 1);
    Color color = avatarBgColorMap[letter];
    color = null == color ? avatarBgColorMap['#'] : color;

    return Container(
      alignment: Alignment.center,
      width: avatarHeight,
      height: avatarWidth,
      // padding: EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).textTheme.subtitle.color, width: this.borderWidth),
        // color: color.withOpacity(0.5),
      ),
      child: Container(
        alignment: Alignment.center,
        width: avatarHeight,
        height: avatarWidth,
        margin: EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.5)
        ),
        child: Text('$letter', style: TextStyle(fontSize: 25.0, color: Colors.white, fontWeight: FontWeight.w500),),
      )
    );  

  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max((minHeight ?? kToolbarHeight), minExtent);
  // @override
  // double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}


class NothingNotice extends StatelessWidget {

  final String txt1;
  final String txt2;
  NothingNotice({this.txt1='', this.txt2=''});

  @override
  Widget build(BuildContext context) {
    double appbarheight = AppConfig.appScreenHeight * AppConfig.appBarHeight;
    const TextStyle style1 = TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400,);
    const TextStyle style2 = TextStyle(fontSize: 18.0, );
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        // color: Colors.black12,
        height: AppConfig.appScreenHeight - appbarheight - AppConfig.statusBarHeight + 0.2,
        padding: EdgeInsets.only(top: 100.0),
        child: Column(
          children: <Widget>[
            FadeInImage(
              placeholder: AssetImage('assets/images/heart-broken.png'),
              image: AssetImage('assets/images/heart-broken.png'),
              width: 60.0,
              height: 60.0,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 30.0, bottom: 30.0, left: 40.0, right: 40.0),
              child: Center(
                child: Text(this.txt1, style: style1, textAlign: TextAlign.center,),
              ),
            ),
            Offstage(
              offstage: this.txt2 == null || this.txt2.length == 0,
              child: Container(
                padding: EdgeInsets.only(top: 30.0, bottom: 30.0, left: 40.0, right: 40.0),
                child: Text(this.txt2, style: style2,),
              ),
            )
          ],
        )
      ),
    );
  }

}

class AppHeader extends StatelessWidget{

  AppHeader({
    Key key, 
    this.title = '', 
    this.height,
    this.child,
    // this.leftIcon = FontAwesomeIcons.chevronLeft, 
    this.leftIcon = AntDesign.left, 
    this.leftIconSize = 19.0,
    this.leftAction,
    this.rightIcon,
    this.rightIconSize = 16.0,
    this.rightAction,
    this.isShadow = true
  }): super(key: key);

  final String title;
  final double height;
  final Widget child;
  final IconData leftIcon;
  final double leftIconSize;
  final IconData rightIcon;
  final double rightIconSize;
  final VoidCallback leftAction;
  final Function rightAction;
  final bool isShadow;

  @override
  Widget build(BuildContext context) {
    
    double fontSizeScale = SpHelper.getFontSizeScale();

    double lrSpace = 8.0;

    Widget header = child == null ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          child: Container(
            width: 40.0,
            padding: EdgeInsets.only(left: lrSpace),
            alignment: Alignment.centerLeft,
            child: Icon(
              leftIcon, 
              size: leftIconSize,
            ),
           
          ),
          onTap: () => leftAction == null ? Navigator.pop(context) : leftAction(),
          onLongPress: () => leftAction == null ? Navigator.pop(context) : leftAction(),
        ),

        Expanded(
          flex: 1,
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            child:  Text(
              "${this.title}", 
              textScaleFactor : fontSizeScale,
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w600, 
              )
            ),
          ),
        ),

        rightIcon != null 
        ? GestureDetector(
            onTap: () {
              rightAction != null ? rightAction() : print('');
            },
            child: Container(
              color: Colors.transparent,
              width: 40.0,
              padding: EdgeInsets.only(right: lrSpace),
              alignment: Alignment.centerRight,
              child: Icon(
                rightIcon, 
                size : rightIconSize
              ),
            ),
        ) : Container(
            width: 40.0,
            color: Colors.transparent,
        )

      ],

    ) : child;


    return
      // 高斯模糊头部
      // ClipRect(  //裁切长方形
      //   child: BackdropFilter(   //背景滤镜器
      //   filter: ImageFilter.blur(sigmaX: 10.0,sigmaY: 10.0), //图片模糊过滤，横向竖向都设置5.0
      //   child: 
        Container(
          width: AppConfig.appScreenWidth,
          height: height == null ? AppConfig.appHeaderHeight : height,
          padding: EdgeInsets.only(top: AppConfig.statusBarHeight),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.9),
            border: Border(bottom: BorderSide(width: 0.33, color: Color.fromRGBO(160, 160, 160, 0.8))),
            boxShadow: isShadow ? [
              BoxShadow(
                color: Color.fromRGBO(160, 160, 160, 0.1),
                blurRadius: 8.0,
                spreadRadius: 8.0,
                offset: Offset(0.0, -4.0),
              ),
            ] : []
          ),
          child: header,
        );
    //   )
    // );
  }

}

class AppItem extends StatelessWidget {

  AppItem({
    this.name = 'Title',
    this.height = 45.0,
    this.border = const Border(
       bottom: BorderSide(
         width: 0.3, 
         color: Color.fromRGBO(160, 160, 160, 0.5)
       ),
    ),
    this.bgColor,
    @required this.leftIcon,
    this.leftIconSize = 14.0,
    this.rightIcon = Icons.chevron_right,
    this.action,
    this.margin = const EdgeInsets.only(top: 0.0),
  });

  final String name;
  final double height;
  final BoxBorder border;
  final Color bgColor;
  final IconData leftIcon; 
  final double leftIconSize; 
  final IconData rightIcon; 
  final Function action;
  final EdgeInsetsGeometry margin;
  
  @override
  Widget build(BuildContext context) {
    
    double fontSizeScale = SpHelper.getFontSizeScale();

    return GestureDetector(
      child: Container(
        margin: margin,
        height: height,
        decoration: BoxDecoration(
          color: bgColor ?? Theme.of(context).cardColor,
          border : border ?? Border(bottom: BorderSide(width: 1, color: Theme.of(context).dividerColor),)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Container(
              width: 20.0,
              height: 20.0,
              // color: Colors.blue,
              margin: EdgeInsets.only(left: 15.0),
              child: Icon(
                leftIcon, 
                color: Theme.of(context).textTheme.subtitle.color, 
                size: leftIconSize
              )
              
              // child: Icon( leftIcon, color: Colors.black26, size: 17.0 )
            ),

            Padding(
              padding: EdgeInsets.only(left: 12.0),
            ),
            
            Expanded(
              child: Text(
                '$name',
                textScaleFactor : fontSizeScale,
                style: TextStyle(
                  fontSize: 13.0 + 1.0,
                ),
              ),
              flex: 1,
            ),

            Container(
              padding: EdgeInsets.only(right: 8.0),
              alignment: Alignment.center,
              child: Icon(
                rightIcon, 
                color: Theme.of(context).textTheme.subtitle.color, 
                size: 20.0
              ),
            ),
            
          ],
        ),
      ),
      onTap: (){
        action();
      },
    );
  }

}



class CeleFaIcon extends StatelessWidget {
  /// 默认 FontAwesomeIcons 重心往上提 0.5 : top -0.5
  CeleFaIcon({
    this.name,
    @required this.icon,
    this.color = const Color.fromRGBO(160, 160, 160, 1),
    this.size = 12.0,
    this.padding,
    this.margin,
    this.top = -0.5,
    this.bottom = 0.0,
    this.left = 0.0,
    this.right = 0.0,
  });

  final String name;
  final IconData icon;
  final Color color;
  final double size;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double top;
  final double bottom;
  final double left;
  final double right;

  double get width => size + 2;
  double get height => size + 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width : width,
      height: height,
      margin : margin,
      padding : padding,
      // color: Colors.blue.withOpacity(0.3),
      child: Stack(
          children: <Widget>[
            Positioned(
              top: top,
              bottom: bottom,
              left: left,
              right: right,
              child: Icon(
                icon,
                color: color,
                size: size,
                semanticLabel: 'FontAwesomeIcon:$name'
              )
            )
          ],
        ),
    );
  }
}

class SkeletonItem extends StatelessWidget {

  SkeletonItem({
    this.width = 100.0,
    this.height = 20.0,
    this.radius = 2.0,
    this.color
  });

  final double width;
  final double height;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width : width,
      height: height,
      decoration: BoxDecoration(
        color: color == null ? AppConfig.placeHolderColor.withOpacity(0.5) : color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}