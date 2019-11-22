
import 'dart:convert';

import 'package:kuvia/blocs/bloc_index.dart';
import 'package:kuvia/common/common.dart';
import 'package:kuvia/utils/util_index.dart';

class ComData {
  int total;
  List rows;
  String pagingState;
  bool hasNext = true;

  ComData.fromJson(Map<String, dynamic> jsonData)
      : hasNext = jsonData['hasNext'],
        pagingState = jsonData['pagingState'],
        total = jsonData['total'],
        rows = jsonData['rows'] ?? [];
}


class ComListResp<T> {
  int status;
  List<T> list;

  ComListResp(this.status, this.list);
}

class ReposModel {
  String id;
  String title;
  String desc;
  String author;
  String link;
  String projectLink;
  String envelopePic;
  String superChapterName;
  int publishTime;
  bool collect;

  ReposModel.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['id'],
        title = jsonData['title'],
        desc = jsonData['desc'],
        author = jsonData['author'],
        link = jsonData['link'],
        projectLink = jsonData['projectLink'],
        envelopePic = jsonData['envelopePic'],
        superChapterName = jsonData['superChapterName'],
        publishTime = jsonData['publishTime'],
        collect = jsonData['collect'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'desc': desc,
        'author': author,
        'link': link,
        'projectLink': projectLink,
        'envelopePic': envelopePic,
        'superChapterName': superChapterName,
        'publishTime': publishTime,
        'collect': collect,
      };

  @override
  String toString() {
    return jsonEncode(this);
  }
}

class BannerModel {
  String title;
  String id;
  String url;
  String imagePath;

  BannerModel.fromJson(Map<String, dynamic> jsonData)
      : title = jsonData['title'],
        id = jsonData['id'],
        url = jsonData['url'],
        imagePath = jsonData['imagePath'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'id': id,
        'url': url,
        'imagePath': imagePath,
      };

  @override
  String toString() {
   return jsonEncode(this);
  }
}



class CapitalModel {
  String id;
  String userId;
  String articleId;
  String newUserId;
  double amount;
  int flowType; 
  String createdAt;
  String remark;
  String flowTypeValue;

  CapitalModel({
    this.id, 
    this.userId, 
    this.articleId,
    this.newUserId,
    this.amount,
    this.flowType, 
    this.createdAt, 
    this.remark, 
    this.flowTypeValue
  });

  CapitalModel.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['id'],
        userId = jsonData['userId'],
        articleId = jsonData['articleId'],
        newUserId = jsonData['newUserId'],
        amount = jsonData['amount'],
        flowType = jsonData['flowType'],
        createdAt = jsonData['createdAt'],
        remark = jsonData['remark'],
        flowTypeValue = jsonData['flowTypeValue'];


  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'articleId' : articleId,
        'newUserId' : newUserId,
        'amount': amount,
        'flowType': flowType,
        'createdAt': createdAt,
        'remark': remark,
        'flowTypeValue': flowTypeValue,
      };

  @override
  String toString() {
    return jsonEncode(this);
  }

}
