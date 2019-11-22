/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2019/5/5 下午2:37
 */

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart'
    hide RefreshIndicatorState, RefreshIndicator;
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:vibration/vibration.dart';
class WaterDropHeaderX extends RefreshIndicator {
  final Widget refresh;

  final Widget complete;

  final Widget failed;

  final Widget idleIcon;

  final Color waterDropColor;

  final bool reverse;

  final String successTip;

  final String failTip;

  const WaterDropHeaderX({
    Key key,
    this.refresh,
    this.complete,
    this.reverse: false,
    Duration completeDuration: const Duration(milliseconds: 600),
    this.failed,
    this.waterDropColor: Colors.grey,
    this.idleIcon: const Icon(
      Icons.autorenew,
      size: 15,
      color: Colors.white,
    ),
    this.successTip = 'Refresh Success',
    this.failTip = 'Refresh Failed'
  }) : super(
            key: key,
            height:60.0,
            completeDuration: completeDuration,
            refreshStyle: RefreshStyle.UnFollow);


  @override
  State<StatefulWidget> createState() {
    return _WaterDropHeaderXState();
  }
}

class _WaterDropHeaderXState extends RefreshIndicatorState<WaterDropHeaderX>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _dismissCtl;

  @override
  void onOffsetChange(double offset) {
    final double realOffset =
        offset - 44.0; //55.0 mean circleHeight(24) + originH (20) in Painter
    // when readyTorefresh
    if (!_animationController.isAnimating)
      _animationController.value = realOffset;
  }

  @override
  Future<void> readyToRefresh() {
    _dismissCtl.animateTo(0.0);
    return _animationController.animateTo(0.0);
  }

  @override
  void initState() {
    _dismissCtl = AnimationController(
        vsync: this, duration: Duration(milliseconds: 400), value: 1.0);
    _animationController = AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 50.0,
        duration: Duration(milliseconds: 400));
    super.initState();
  }

  @override
  bool needReverseAll() {
    return false;
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    Widget child;
    const Widget progress = const cupertino.CupertinoActivityIndicator();
    if (mode == RefreshStatus.refreshing) {
      if(Platform.isAndroid){
        Vibration.hasVibrator().then((status){
          if(status == true) Vibration.vibrate(duration: 10, amplitude: -1);
        });
      }
      child = widget.refresh ??
          SizedBox(
            width: 25.0,
            height: 25.0,
            child: progress,
            // child: defaultTargetPlatform == TargetPlatform.iOS
            //     ? const CupertinoActivityIndicator()
            //     : const CircularProgressIndicator(strokeWidth: 2.0),
          );
    } else if (mode == RefreshStatus.completed) {
      // child = widget.complete ??             // 注释提示成功刷新
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: <Widget>[
      //         const Icon(
      //           Icons.done,
      //           color: Colors.grey,
      //         ),
      //         Container(
      //           width: 15.0,
      //         ),
      //         Text(
      //           widget.successTip,
      //           style: TextStyle(color: Colors.grey),
      //         )
      //       ],
      //     );
      child = widget.refresh ??
          SizedBox(
            width: 25.0,
            height: 25.0,
            child: progress,
            // child: defaultTargetPlatform == TargetPlatform.iOS
            //     ? const CupertinoActivityIndicator()
            //     : const CircularProgressIndicator(strokeWidth: 2.0),
          );
    } else if (mode == RefreshStatus.failed) {
      child = widget.failed ??
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                AntDesign.close,
                color: Colors.grey,
              ),
              Container(
                width: 15.0,
              ),
              Text(widget.failTip, style: TextStyle(color: Colors.grey))
            ],
          );
    } else if (mode == RefreshStatus.idle || mode == RefreshStatus.canRefresh) {
      return FadeTransition(
          child: Container(
            child: Stack(
              children: <Widget>[
                RotatedBox(
                  child: CustomPaint(
                    child: Container(
                      height: 60.0,
                    ),
                    painter: _QqPainter(
                      color: widget.waterDropColor,
                      listener: _animationController,
                    ),
                  ),
                  quarterTurns: widget.reverse ? 10 : 0,
                ),
                Container(
                  alignment: widget.reverse
                      ? Alignment.bottomCenter
                      : Alignment.topCenter,
                  margin: widget.reverse
                      ? EdgeInsets.only(bottom: 12.0)
                      : EdgeInsets.only(top: 12.0),
                  child: widget.idleIcon,
                )
              ],
            ),
            height: 60.0,
          ),
          opacity: _dismissCtl);
    }
    return Container(
      height: 60.0,
      child: Center(
        child: child,
      ),
    );
  }

  @override
  void resetValue() {
    _animationController.reset();
    _dismissCtl.value = 1.0;
  }

  @override
  void dispose() {
    _dismissCtl.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

class _QqPainter extends CustomPainter {
  final Color color;
  final Animation<double> listener;

  double get value => listener.value;
  final Paint painter = Paint();

  _QqPainter({this.color, this.listener}) : super(repaint: listener);

  @override
  void paint(Canvas canvas, Size size) {
    final double originH = 20.0;

    final double middleW = size.width / 2;

    final double circleSize = 12.0;

    final double scaleRatio = 0.1;

    final double offset = value;

    painter.color = color;
    canvas.drawCircle(Offset(middleW, originH), circleSize, painter);
    Path path = Path();
    path.moveTo(middleW - circleSize, originH);

    //drawleft
    path.cubicTo(
        middleW - circleSize,
        originH,
        middleW - circleSize + value * scaleRatio,
        originH + offset / 5,
        middleW - circleSize + value * scaleRatio * 2,
        originH + offset);
    path.lineTo(
        middleW + circleSize - value * scaleRatio * 2, originH + offset);
    //draw right
    path.cubicTo(
        middleW + circleSize - value * scaleRatio * 2,
        originH + offset,
        middleW + circleSize - value * scaleRatio,
        originH + offset / 5,
        middleW + circleSize,
        originH);
    //draw upper circle
    path.moveTo(middleW - circleSize, originH);
    path.arcToPoint(Offset(middleW + circleSize, originH),
        radius: Radius.circular(circleSize));

    //draw lowwer circle
    path.moveTo(
        middleW + circleSize - value * scaleRatio * 2, originH + offset);
    path.arcToPoint(
        Offset(middleW - circleSize + value * scaleRatio * 2, originH + offset),
        radius: Radius.circular(value * scaleRatio));
    path.close();
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class ClassicFooterX extends LoadIndicator {
  final String idleText, loadingText, noDataText, failedText;

  final Function outerBuilder;

  final Widget idleIcon, loadingIcon, noMoreIcon, failedIcon;

  final double spacing;

  final IconPosition iconPos;

  final TextStyle textStyle;

  const ClassicFooterX({
    Key key,
    Function onClick,
    LoadStyle loadStyle:LoadStyle.ShowAlways,
    double height: 120.0,
    this.outerBuilder,
    this.textStyle: const TextStyle(color: const Color.fromRGBO(160, 160, 160, 1),fontSize: 14.0),
    this.loadingText: 'Loading...',
    this.noDataText: 'No More Data',
    // this.noDataText: '''────── · ──────''',
    this.noMoreIcon,
    this.idleText: 'Load More..',
    this.failedText: 'Load Failed, Click Retry!',
    this.failedIcon: const Icon(Icons.error, color: Colors.grey),
    this.iconPos: IconPosition.left,
    this.spacing: 15.0,
    this.loadingIcon,
    this.idleIcon = const Icon(Icons.arrow_downward, color: Colors.grey),
  }) : super(
    key: key,
    loadStyle:loadStyle,
    height:height,
    onClick: onClick,
  );

  @override
  State<StatefulWidget> createState() {
    return _ClassicFooterXState();
  }
}

class _ClassicFooterXState extends LoadIndicatorState<ClassicFooterX> {
  Widget _buildText(LoadStatus mode) {
    return Text(
        mode == LoadStatus.loading
            ? widget.loadingText
            : LoadStatus.noMore == mode
            ? widget.noDataText
            : LoadStatus.failed == mode
            ? widget.failedText
            : widget.idleText,
        style: widget.textStyle);
  }

  Widget _buildIcon(LoadStatus mode) {
    Widget icon = mode == LoadStatus.loading
        ? widget.loadingIcon ??
        SizedBox(
          width: 25.0,
          height: 25.0,
          child: const CupertinoActivityIndicator(),
          // child: defaultTargetPlatform == TargetPlatform.iOS
          //     ? const CupertinoActivityIndicator()
          //     : const CircularProgressIndicator(strokeWidth: 2.0),
        )
        : mode == LoadStatus.noMore
        ? widget.noMoreIcon
        : mode == LoadStatus.failed ? widget.failedIcon : widget.idleIcon;
    return icon ?? Container();
  }

  @override
  Widget buildContent(BuildContext context, LoadStatus mode) {
    Widget textWidget = _buildText(mode);
    Widget iconWidget = _buildIcon(mode);
    List<Widget> children = <Widget>[iconWidget, textWidget];
    final Widget container = Wrap(
      spacing: widget.spacing,
      textDirection: widget.iconPos == IconPosition.left
          ? TextDirection.ltr
          : TextDirection.rtl,
      direction: widget.iconPos == IconPosition.bottom ||
          widget.iconPos == IconPosition.top
          ? Axis.vertical
          : Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      verticalDirection: widget.iconPos == IconPosition.bottom
          ? VerticalDirection.up
          : VerticalDirection.down,
      alignment: WrapAlignment.center,
      children: children,
    );
    return widget.outerBuilder != null
        ? widget.outerBuilder(container)
        : Container(
      height: 60.0,
      child: Center(
        child: container,
      ),
    );
  }
}