


import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:kuvia/common/common.dart';
import 'package:kuvia/data/api/apis.dart';
import 'package:kuvia/data/net/dio_util.dart';
import 'package:kuvia/data/protocol/models.dart';
import 'package:kuvia/utils/util_index.dart';
import 'package:xml2json/xml2json.dart';

DioUtil dioUtil = DioUtil.getInstance();
final Xml2Json myTransformer = Xml2Json();
class DumeiRepository {

  DumeiRepository._();

  static DumeiRepository _instance;

  static DumeiRepository getInstance() {
    if (_instance == null) {
      _instance = DumeiRepository._();
    }
    return _instance;
  }
  

  /// 获取文章详情
  Future <List<NewsModel>> getNewsModelList(Map<String, dynamic> comReq) async {

    LogUtil.v("getUserFollowingList------comReq--->>>" + comReq.toString());
    // LogUtil.v("getUserFollowingList------url---+++11>>>" + DumeiApi.getPath(path: DumeiApi.USER_MY_FOLLOW_LIST));
    Response<dynamic> response = await dioUtil.requestPure(
      Method.get, 
      DumeiApi.NEWSLIST,
      queryParameters:comReq
    );
    List<NewsModel> list;
    Map<String, dynamic> resMap = Utils.decodeData(response);
    if (resMap[AppHttpConstant.SUCCESS] != AppConstant.STATUS_SUCCESS) {
      return new Future.error('something gona wrong...');
    }
    if (resMap[AppHttpConstant.RESULT] != null && resMap[AppHttpConstant.RESULT] is List) {
      list = resMap[AppHttpConstant.RESULT].map((value) {
        return NewsModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  /// 排行榜
  Future <RankModel> getRankNewsModelList(Map<String, dynamic> comReq) async {

    LogUtil.v("getUserFollowingList------comReq--->>>" + comReq.toString());
    // LogUtil.v("getUserFollowingList------url---+++11>>>" + DumeiApi.getPath(path: DumeiApi.USER_MY_FOLLOW_LIST));
    Response<dynamic> response = await dioUtil.requestPure(
      Method.get, 
      DumeiApi.NEWSLIST,
      queryParameters:comReq
    );
    
    Map<String, dynamic> resMap = Utils.decodeData(response);
    if (resMap[AppHttpConstant.SUCCESS] != AppConstant.STATUS_SUCCESS) {
      return new Future.error('something gona wrong...');
    }
    RankModel rankModel = RankModel(
      channel48Rank: this._transfer2NewsModelList(resMap['channel48rank']),
      channelWeekHotRank: this._transfer2NewsModelList(resMap['channelweekhotrank']),
      channelWeekCommentRank: this._transfer2NewsModelList(resMap['channel48rank']),
      channelMonthRank: this._transfer2NewsModelList(resMap['channelmonthrank']),
    );
    return rankModel;
  }

  /// 转NewsModelList
  List<NewsModel> _transfer2NewsModelList(dynamic val){
    List<NewsModel> list  = val.map((value) {
      return NewsModel.fromJson(value);
    }).toList();
    return list;
  }

  /// 获取相关文章
  Future <List<NewsModel>> getRelateNewsModelList(Map<String, dynamic> comReq) async {

    LogUtil.v("getUserFollowingList------comReq--->>>" + comReq.toString());
    // LogUtil.v("getUserFollowingList------url---+++11>>>" + DumeiApi.getPath(path: DumeiApi.USER_MY_FOLLOW_LIST));
    Response<dynamic> response = await dioUtil.requestPure(
      Method.get, 
      DumeiApi.RELATENEWS,
      queryParameters:comReq
    );
    if (null == response.data) {
      return new Future.error('something gona wrong...');
    }
    List<NewsModel> list;
    Map<String, dynamic> resMap = json.decode('${response.data}'.replaceAll('response.data', ''));
    if (null != resMap) {
      list = resMap[AppHttpConstant.RESULT].map((value) {
        return NewsModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  /// 获取详情
  Future <NewsModel> getNewsContent(Map<String, dynamic> comReq, NewsModel newsModel) async {

    LogUtil.v("getUserFollowingList------comReq--->>>" + comReq.toString());
    Response<dynamic> response = await dioUtil.requestPure(
      Method.get, 
      DumeiApi.NEWSCONTENT,
      queryParameters:comReq
    );
    dynamic resultData = this._transferXml2JsonData(response.data);
    if (null == resultData) {
      return new Future.error('something gona wrong...');
    }
    newsModel.newsAuthor = resultData[AppHttpConstant.NEWSSOURCE];
    newsModel.newsSource = resultData[AppHttpConstant.NEWSSOURCE];
    newsModel.detail = resultData[AppHttpConstant.DETAIL];
    return newsModel;
  }

  /// 获取BANNER
  Future <List<BannerModel>> getBannerModelList(Map<String, dynamic> comReq) async {

    LogUtil.v("getUserFollowingList------comReq--->>>" + comReq.toString());
    // LogUtil.v("getUserFollowingList------url---+++11>>>" + DumeiApi.getPath(path: DumeiApi.USER_MY_FOLLOW_LIST));
    Response<dynamic> response = await dioUtil.requestPure(
      Method.get, 
      DumeiApi.BANNER,
      queryParameters:comReq
    );
    List<BannerModel> list;
    dynamic resultData = this._transferXml2JsonData(response.data);
    if (null == resultData) {
      return new Future.error('something gona wrong...');
    }
    list = resultData.map((value) {
      return BannerModel.fromJson(value);
    }).toList();
    return list;
  }

  /// 解析xml数据
  dynamic _transferXml2JsonData(dynamic data){
    myTransformer.parse('$data');
    Map<String, dynamic> resMap = json.decode(myTransformer.toGData());
    if (null == resMap || null == resMap[AppHttpConstant.RSS] || null  == resMap[AppHttpConstant.RSS][AppHttpConstant.CHANNEL]) {
      return null;
    }
    return resMap[AppHttpConstant.RSS][AppHttpConstant.CHANNEL];
  }

}
