import 'dart:io';
import 'dart:ui';

import 'package:kuvia/common/common.dart';
import 'package:kuvia/resources/colors.dart';
import 'package:kuvia/resources/styles.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbar_text_color/flutter_statusbar_text_color.dart';


enum Themes {
    SYSTEM, DARK, LIGHT, 
}

class ThemeProvider extends ChangeNotifier {
  ThemeProvider({this.theme});
  Themes theme;

  static const Map<Themes, String> themes = {
    Themes.SYSTEM : "System", Themes.DARK: "Dark", Themes.LIGHT : "Light", 
  };

  Future setTheme(Themes theme) async {
    this.theme = theme;
    SpUtil.putString(Constant.KEY_THEME, themes[theme]);
    if(Platform.isIOS){
      if(theme == Themes.DARK){
        FlutterStatusbarTextColor.setTextColor(FlutterStatusbarTextColor.light);
      }else if(theme == Themes.LIGHT){
        FlutterStatusbarTextColor.setTextColor(FlutterStatusbarTextColor.dark);
      }
    }
  }

  getTheme({bool isDarkMode= false}) {
    String theme = SpUtil.getString(Constant.KEY_THEME);        // 如若SP存在KEY_THEME的值（即已经设置了主题模式），强制使用使用设置的主题，传入的isDarkMode不是影响因子
    LogUtil.e('ThemeProvider====theme===${SpUtil.isInitialized()}==>>>$theme');
    switch(theme){
      case "Dark":
        isDarkMode = true;
        break;
      case "Light":
        isDarkMode = false;
        break;
      default:
        break;
    }
    return ThemeData( 
      errorColor: isDarkMode ? AppColors.dark_red : AppColors.red,                    // 错误色
      brightness: isDarkMode ? Brightness.dark : Brightness.light,                    // 用程序的整体主题亮度
      primaryColor: isDarkMode ? AppColors.dark_app_main : AppColors.app_main,        // 主题色 粉红
      accentColor: isDarkMode ? AppColors.dark_app_main : AppColors.app_main,         // 前景色(按钮、文本、覆盖边缘效果等)
      indicatorColor: isDarkMode ? AppColors.dark_app_main : AppColors.app_main,      // Tab指示器颜色
      scaffoldBackgroundColor: isDarkMode ? AppColors.dark_bg_color : Colors.white,   // 页面背景色
      dialogBackgroundColor: isDarkMode ? AppColors.dark_material_bg : Colors.white,  // dialog背景色
      canvasColor: isDarkMode ? AppColors.dark_material_bg : Colors.white,            // 主要用于Material背景色
      cardColor: isDarkMode ? AppColors.dark_material_bg : Colors.white,              // 主要用于卡片背景色，如for you 的卡片，News的卡片
      textSelectionColor: AppColors.app_main.withAlpha(70),                           // 文字选择色（输入框复制粘贴菜单）
      textSelectionHandleColor: AppColors.app_main,                                   // 用于调整当前选定文本部分的句柄的颜色。
      dividerColor: isDarkMode ? AppColors.dark_line : AppColors.line,                // 分隔符(Dividers)和弹窗分隔符(PopupMenuDividers)的颜色

      textTheme: TextTheme(
        title: isDarkMode ? AppTextStyles.textDark : AppTextStyles.text,                        // 深色文字颜色 HeavyTextColor
        subtitle: isDarkMode ? AppTextStyles.textDarkGray13 : AppTextStyles.textGray13,         // 浅色文字颜色  lighTextColor
        subhead: isDarkMode ? AppTextStyles.headTextDarkGray12 : AppTextStyles.headTextGray12,  // 中等文字颜色  mediumTextColor
      body1: isDarkMode ? AppTextStyles.textDark : AppTextStyles.text,                          // 内容文字样式
        display1: isDarkMode ? AppTextStyles.textGray12 : AppTextStyles.textDark,    
        display2: isDarkMode ? AppTextStyles.priceTextDark : AppTextStyles.priceTextDark,         // 价格颜色
        display3: isDarkMode ? AppTextStyles.textDark : AppTextStyles.textWhite,
      ),
      inputDecorationTheme: InputDecorationTheme(
        prefixStyle: isDarkMode ? AppTextStyles.textHint14 : AppTextStyles.textDarkGray14,
        hintStyle: isDarkMode ? AppTextStyles.textHint14 : AppTextStyles.textDarkGray14,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        color: isDarkMode ? AppColors.dark_bg_color : Colors.white,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      dividerTheme: DividerThemeData(           // 与dividerColor应用不同，暂时应用于home News的border bottom
        color: isDarkMode ? AppColors.dark_bg_color : AppColors.line,
        space: 0.6,
        thickness: 0.6
      ),
      iconTheme: IconThemeData(
        color:  isDarkMode ? AppColors.dark_text : AppColors.text,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: isDarkMode ? AppColors.dark_text : AppColors.text,
        unselectedLabelColor:  isDarkMode ? AppColors.dark_unselected_item_color : AppColors.unselected_item_color,
      ),
     popupMenuTheme: PopupMenuThemeData(
       color:  isDarkMode ? Color.fromRGBO(40, 40, 40, 1.0) : AppConfig.placeHolderColor,
     )
    );
  }

}