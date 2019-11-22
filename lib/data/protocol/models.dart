
import 'dart:convert';

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

class TabModel {
  int id;
  String name;
  String webName;
  int queneIndex;
  String remark;

  TabModel({
    this.id, 
    this.name, 
    this.webName,
    this.queneIndex,
    this.remark,
  });

  TabModel.fromJson(Map<String, dynamic> jsonData)
    : id = jsonData['id'],
      name = jsonData['name'],
      webName = jsonData['webName'],
      queneIndex = jsonData['queneIndex'],
      remark = jsonData['remark'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'webName': webName,
    'queneIndex': queneIndex,
    'remark': remark
  };

  @override
  String toString() {
    return jsonEncode(this);
  }
}

class RankModel {
  List<NewsModel> channel48Rank;
  List<NewsModel> channelWeekHotRank;
  List<NewsModel> channelWeekCommentRank;
  List<NewsModel> channelMonthRank;

  RankModel({
    this.channel48Rank, 
    this.channelWeekHotRank, 
    this.channelWeekCommentRank,
    this.channelMonthRank,
  });

  RankModel.fromJson(Map<String, dynamic> jsonData)
    : channel48Rank = jsonData['channel48rank'],
      channelWeekHotRank = jsonData['channelweekhotrank'],
      channelWeekCommentRank = jsonData['channelweekcommentrank'],
      channelMonthRank = jsonData['channelmonthrank'];

  Map<String, dynamic> toJson() => {
    'channel48Rank': channel48Rank,
    'channelWeekHotRank': channelWeekHotRank,
    'channelWeekCommentRank': channelWeekCommentRank,
    'channelMonthRank': channelMonthRank
  };

  @override
  String toString() {
    return jsonEncode(this);
  }
}

class NewsModel    {
    int    newsid;
    String    title;
    String v;
    String    orderdate;
    String    postdate;
    String    description;
    String    image;
    String slink;
    int    hitcount;
    int    commentcount;
    int    cid;
    String    url;
    int    live;
    String lapinid;
    bool forbidcomment;
    List<String> imagelist;
    String c;
    String client;
    bool    isad;
    int    sid;
    String    postDateStr;  //PostDateStr
    String    hitCountStr;     //HitCountStr
    String    wapNewsUrl;   //WapNewsUrl
    List<String> newsTips;        //NewsTips
    
    String newsSource;      //newssource
    String newsAuthor;      //newsauthor
    String detail;          //detail

    NewsModel.fromJson(Map<String, dynamic> jsonData)
      : newsid = jsonData['newsid'],
        title = jsonData['title'],
        v = jsonData['v'],
        orderdate = jsonData['orderdate'],
        postdate = jsonData['postdate'],
        description = jsonData['description'],
        image = jsonData['image'],
        slink = jsonData['slink'],
        hitcount = jsonData['hitcount'],
        commentcount = jsonData['commentcount'],
        cid = jsonData['cid'],
        url = jsonData['url'],
        live = jsonData['live'],
        lapinid = jsonData['lapinid'],
        forbidcomment = jsonData['forbidcomment'],
        imagelist = jsonData['imagelist'],
        c = jsonData['c'],
        client = jsonData['client'],
        isad = jsonData['isad'],
        sid = jsonData['sid'],
        postDateStr = jsonData['PostDateStr'],  //PostDateStr
        hitCountStr = jsonData['HitCountStr'],     //HitCountStr
        wapNewsUrl = jsonData['WapNewsUrl'],   //WapNewsUrl
        newsTips = jsonData['NewsTips'],        //NewsTips

        newsSource = jsonData['newssource'],      //newssource
        newsAuthor = jsonData['newsauthor'],      //newsauthor
        detail = jsonData['detail'] ;

  Map<String, dynamic> toJson() => {
      'newsid' : newsid,
      'title' : title,
      'v' : v,
      'orderdate' : orderdate,
      'postdate' : postdate,
      'description' : description,
      'image' : image,
      'slink' : slink,
      'hitcount' : hitcount,
      'commentcount' : commentcount,
      'cid' : cid,
      'url' : url,
      'live' : live,
      'lapinid' : lapinid,
      'forbidcomment' : forbidcomment,
      'imagelist' : imagelist,
      'c' : c,
      'client' : client,
      'isad' : isad,
      'sid' : sid,
      'postDateStr' : postDateStr,  //PostDateStr
      'hitCountStr' : hitCountStr,     //HitCountStr
      'wapNewsUrl' : wapNewsUrl,   //WapNewsUrl
      'newsTips' : newsTips,        //NewsTips

      'newsSource' : newsSource,      //newssource
      'newsAuthor' : newsAuthor,      //newsauthor
      'detail' : detail,   
      };

  @override
  String toString() {
    return jsonEncode(this);
  }
}

//<title>
// <![CDATA[ 华为可折叠“翻盖”手机专利渲染图曝光 ]]>
// </title>
// <link>
// <![CDATA[ https://www.ithome.com/0/457/563.htm ]]>
// </link>
// <newstype/>
// <stime>2019/11/21 15:21:43</stime>
// <etime>2019/11/22 15:11:00</etime>
// <opentype>1</opentype>
// <device>3,5,6,7,8,9</device>
// <image>
// http://img.ithome.com/newsuploadfiles/focus/dd64b905-e754-4b84-b5f5-954ba7f0be10.jpg
// </image>

class BannerModel {
  String title;
  String link;
  String newsType;
  String sTime;
  String eTime;
  int openType;
  String device;
  String image;

  BannerModel.fromJson(Map<String, dynamic> jsonData)
      : title = jsonData['title'],
        link = jsonData['link'],
        newsType = jsonData['newstype'],
        sTime = jsonData['stime'],
        eTime = jsonData['etime'],
        openType = jsonData['opentype'],
        device = jsonData['device'],
        image = jsonData['image'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'link': link,
        'newsType': newsType,
        'sTime': sTime,
        'eTime': eTime,
        'openType': openType,
        'device': device,
        'image': image,
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
