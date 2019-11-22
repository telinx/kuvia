import 'dart:collection';
import 'dart:convert';

import 'package:kuvia/common/common.dart';
import 'package:kuvia/common/sp_helper.dart';
import 'package:kuvia/data/protocol/models.dart';
import 'package:kuvia/data/repository/dumei_repository.dart';
import 'package:kuvia/events/event.dart';
import 'package:kuvia/utils/util_index.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';
//  import 'package:vibration/vibration.dart';


import 'bloc_provider.dart';

class ComListBloc<T> implements BlocBase {

  /// 构建实例以被调用方法
  static ComListBloc _instance;

  static ComListBloc getInstance() {
    if (_instance == null) {
      _instance = ComListBloc();
    }
    return _instance;
  }

  ComListBloc({this.comList});

  BehaviorSubject<List<T>> comListData = BehaviorSubject<List<T>>();

  Sink<List<T>> get _comListSink => comListData.sink;

  Stream<List<T>> get comListStream => comListData.stream;

  List<T> comList;

  RefreshController refreshController = RefreshController();

  PageEvent _pageEvent = PageEvent();

  DumeiRepository _dumeiRepository = DumeiRepository.getInstance();

  @override
  void dispose() {
    refreshController?.dispose();
    comListData?.close();
    // _comListEvent.close();
  }

  void updataPageEvent(ComData comData){
    this._pageEvent.hasNext = comData.hasNext ?? false;
    this._pageEvent.pagingState = comData.pagingState ?? PageEvent.noMore;
  }

  @override
  Future getData({String labelId, String cid, Map<String, dynamic> comReq}) {

    comReq = comReq ??  <String, dynamic>{}; 
    comReq[AppHttpConstant.PAGEING_STATE] = this._pageEvent.pagingState;

    switch (labelId) {
      
      default:
        return Future.delayed(new Duration(milliseconds: 1));
        break;
    }

  }

  @override
  Future onLoadMore({String labelId, String cid, Map<String, dynamic> comReq}) {

    return getData(labelId: labelId, cid: cid, comReq: comReq).then((result){
      List<T> list = result as List<T>;
      if(null != list && list.length > 0){
        if(this.comList == null) this.comList = List<T>();
        this.comList?.addAll(List.castFrom(list));
        this._comListSink?.add(UnmodifiableListView<T>(this.comList));
        if(!this._pageEvent.hasNext){
          this.refreshController?.loadNoData();
        }else{
          this.refreshController?.loadComplete();
        }
        
      }else{
        this.refreshController?.loadNoData();
      }
    }).catchError((e) {
      this.refreshController?.loadFailed();
      LogUtil.e('onLoadMore---------labelId: $labelId----cid: $cid------>>>>>$e');
    });

  }

  @override
  Future<void> onRefresh({String labelId, String cid, Map<String, dynamic> comReq, int greatThan = 0}) {

    LogUtil.v('-onRefresh---------------------->>> $labelId $cid--->$comReq' );
    this._pageEvent.pagingState = null;
    return getData(labelId: labelId, cid: cid, comReq: comReq).then((result){
      List<T> list = result as List<T>;
      LogUtil.v('onRefresh-----------1----------->>>list: ${list?.length}--hasNext:${this._pageEvent.hasNext}' );
      if(null != list && list.length > greatThan){
        if(this.comList == null) this.comList = List<T>();
        this.comList?.clear();
        this.comList?.addAll(List.castFrom(list));
        this._comListSink?.add(UnmodifiableListView<T>(this.comList));
        this.refreshController?.refreshCompleted();
      }else{
        this.refreshController?.refreshToIdle();
      }
      if(!this._pageEvent.hasNext){
        LogUtil.v('onRefresh-----------1---_pageEvent-------->>>list: ${!this._pageEvent.hasNext}' );
        this.refreshController?.loadNoData();
      }
     
    }).catchError((e) {
      this.refreshController?.refreshFailed();
      LogUtil.e('onRefresh----error-----labelId: $labelId----cid: $cid------>>>>>$e');
    });

  }
}

