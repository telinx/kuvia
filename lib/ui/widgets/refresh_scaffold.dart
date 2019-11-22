


import 'dart:async';

import 'package:kuvia/blocs/bloc_index.dart';
import 'package:kuvia/ui/widgets/waterdrop_headerx.dart';
import 'package:kuvia/ui/widgets/widgets.dart';
import 'package:kuvia/utils/util_index.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


typedef void OnLoadMore();

class RefreshScaffold extends StatefulWidget {
  RefreshScaffold({
    Key key,
    this.labelId,
    this.isLoading,
    this.loadingWidget,
    @required this.controller,
    this.enablePullUp: true,
    this.onRefresh,
    this.onLoadMore,
    this.child,
    this.scrollController,
    this.itemCount,
    this.itemBuilder,
    this.itemHeight,
    this.buttonBottom,
    this.pageName = 'RefreshScaffold',
    this.isShowFloatBtn = true,
    this.footerHeight = 60.0,
    this.newScrollController = false,
    this.isStaggeredGrid = false,
    this.sliverWidget
  }): super(key: key);

  final String labelId;
  final bool isLoading;
  final ListView loadingWidget;
  final RefreshController controller;
  final bool enablePullUp;
  final RefreshCallback onRefresh;
  final OnLoadMore onLoadMore;
  final Widget child;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double itemHeight;
  final ScrollController scrollController;
  final double buttonBottom;
  final String pageName;
  final bool isShowFloatBtn;
  final double footerHeight;
  final bool newScrollController;
  final bool isStaggeredGrid;
  final Widget sliverWidget;

  

  @override
  State<StatefulWidget> createState() {
    return new RefreshScaffoldState();
  }
}

///   with AutomaticKeepAliveClientMixin
class RefreshScaffoldState extends State<RefreshScaffold> with AutomaticKeepAliveClientMixin {
  StreamSubscription scrollToTopSub;
  ScrollController listViewController;
  int initOffset = 0;

  int timeNow;
  var listViewKey;
  StreamSubscription cancelNotifySub;
  MainBloc bloc;

  @override
  void dispose() {
    scrollToTopSub?.cancel();
    this.listViewController?.dispose();
    cancelNotifySub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<MainBloc>(context);
    
    timeNow = DateTime.now().millisecondsSinceEpoch;

    if(widget.newScrollController){
      this.listViewController = ScrollController(
        initialScrollOffset: 0.0, 
        keepScrollOffset: false
      );
    }else {
      this.listViewController = widget.scrollController;
    }
  }

  
  @override
  Widget build(BuildContext context) {
    
    LogUtil.v('New RefreshScaffoldState-------build---->${widget.pageName}----${widget.isLoading}');
    super.build(context);

    if(widget.isLoading){
      return widget.loadingWidget != null ? this._buildSmartRefresher(context) : ProgressView();
    }
    return this._buildSmartRefresher(context);
  }

  /// 构建列表
  Widget _buildSmartRefresher(BuildContext context){

    Widget itemBuildWidget;
    if(widget.isLoading){
      itemBuildWidget = widget.loadingWidget;
      if(null != widget.sliverWidget){
        List<Widget> loadingWidgets = [
          SliverToBoxAdapter(
            child: widget.sliverWidget,
          ),
        ];
        loadingWidgets.addAll(widget.loadingWidget.buildSlivers(context));
        itemBuildWidget = CustomScrollView(
          slivers: loadingWidgets,
        );
      }
    }else{

      if(widget.isStaggeredGrid){
        itemBuildWidget = StaggeredGridView.countBuilder(
          physics: const AlwaysScrollableScrollPhysics (),
          controller: this.listViewController,
          itemCount: widget.itemCount,
          crossAxisCount: 4,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 0.3,
          itemBuilder: widget.itemBuilder,
          staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
        );
      }else if(null != widget.sliverWidget){
        itemBuildWidget = this._buildCustomScrollView();
      }else {
        itemBuildWidget = ListView.builder(
          cacheExtent: 100,
          physics: const AlwaysScrollableScrollPhysics (),
          addAutomaticKeepAlives: true,
          itemExtent: widget.itemHeight,
          controller: this.listViewController,
          itemCount: widget.itemCount,
          itemBuilder: widget.itemBuilder,
        );
      }
    
    }
    Widget smartRefreshWidget = SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeaderX(),
      // header: ClassicHeader(refreshStyle: RefreshStyle.Follow,),
      footer: ClassicFooterX(height: widget.footerHeight,),
      controller: widget.controller,
      onRefresh: widget.onRefresh,
      onLoading: widget.onLoadMore,
      child: itemBuildWidget,
    );
    
    return Container(
      child: RefreshConfiguration(
        footerTriggerDistance: 300.0,
        child: smartRefreshWidget,
      ),
    );
  }

  Widget _buildCustomScrollView() {
    Widget listWidget;
    // if(null == widget.itemCount || widget.itemCount == 0){
    //   listWidget = ProgressView();
    // }else{
      listWidget = SliverList(
        delegate: SliverChildBuilderDelegate(
          widget.itemBuilder,
          childCount: widget.itemCount,
        ),
      );
    // }
    
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: widget.sliverWidget,
        ),
        listWidget
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
