
import 'package:kuvia/blocs/bloc_index.dart';
import 'package:kuvia/data/repository/dumei_repository.dart';
import 'package:kuvia/theme/theme_provider.dart';

import 'bloc_provider.dart';

class MainBloc implements BlocBase {

  // 主题
  ComBloc<ThemeProvider> themeBloc = ComBloc<ThemeProvider>(com: ThemeProvider(theme: Themes.SYSTEM));

  DumeiRepository dumeiRepository = DumeiRepository.getInstance();

  /// 首页bottomNavi下标
  ComBloc<int>  mainBottomNaviIndexBloc = ComBloc<int>(com: 0);

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
