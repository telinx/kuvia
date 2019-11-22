


import 'package:kuvia/data/net/dio_util.dart';
DioUtil dioUtil = DioUtil.getInstance();
class DumeiRepository {

  DumeiRepository._();

  static DumeiRepository _instance;

  static DumeiRepository getInstance() {
    if (_instance == null) {
      _instance = DumeiRepository._();
    }
    return _instance;
  }
  

}
