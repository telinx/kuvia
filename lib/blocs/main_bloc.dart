
import 'package:kuvia/blocs/bloc_index.dart';
import 'package:kuvia/data/protocol/models.dart';
import 'package:kuvia/data/repository/dumei_repository.dart';
import 'package:kuvia/theme/theme_provider.dart';

import 'bloc_provider.dart';

class MainBloc implements BlocBase {
  
  DumeiRepository dumeiRepository = DumeiRepository.getInstance();
  // 主题
  ComBloc<ThemeProvider> themeBloc = ComBloc<ThemeProvider>(com: ThemeProvider(theme: Themes.SYSTEM));

  // 首页bottomNavi下标
  ComBloc<int>  mainBottomNaviIndexBloc = ComBloc<int>(com: 0);

  /// 首页tab
  ComListBloc<TabModel> tabModelListBloc = ComListBloc<TabModel>(comList: null);

   /// 首页tab 列表数据
  Map<String, ComListBloc<NewsModel>> tabArticleModelListStreamMap = {};

  // 首页bottomNavi下标
  ComBloc<RankModel>  rankModelBloc = ComBloc<RankModel>(com: RankModel());


  @override
  void dispose() {
  }

  @override
  Future getData({String labelId}) {
    return null;
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
