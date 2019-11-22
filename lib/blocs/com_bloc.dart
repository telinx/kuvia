import 'package:kuvia/blocs/bloc_index.dart';
import 'package:kuvia/data/repository/dumei_repository.dart';
import 'package:kuvia/utils/util_index.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';

class ComBloc<T> implements BlocBase {

  /// 构建实例以被调用方法
  static ComBloc _instance;

  static ComBloc getInstance() {
    if (_instance == null) {
      _instance = ComBloc();
    }
    return _instance;
  }

  ComBloc({this.com});

  BehaviorSubject<T> comData = BehaviorSubject<T>();

  Sink<T> get _comSink => comData.sink;

  Stream<T> get comStream => comData.stream;

  T com;

  DumeiRepository dumeiRepository = DumeiRepository.getInstance();

  @override
  void dispose() {
    comData.close();
  }

  @override
  Future getData({String labelId, Map<String, dynamic> comReq}) {
    LogUtil.v('start getData------->>>>>>>>${DateTime.now()}');
    int dioStartTime = DateTime.now().millisecond;
    switch (labelId) {
      default:
        return Future.delayed(new Duration(seconds: 1));
        break;
    }
  }

  @override
  Future onLoadMore({String labelId}) {
    return null;
  }

  @override
  Future onRefresh({String labelId}) {
    return null;
  }

}