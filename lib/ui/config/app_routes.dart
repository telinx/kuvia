
class AppRoutes{
  AppRoutes._();

  static AppRoutes _instance;

  static AppRoutes getInstance() {
    if (_instance == null) {
      _instance = AppRoutes._();
    }
    return _instance;
  }


  // Widget get forYouPage => const ForYouPage();

  // Widget homePage(
  //   {@required String labelId, @required List<TabModel> tabModelList}
  // ) => HomePage(labelId: labelId, tabModelList: tabModelList);
  
}