import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';
import 'dimens.dart';

class AppTextStyles {
  static const TextStyle textSize12 = const TextStyle(
    fontSize: Dimens.font_sp12,
  );
  static const TextStyle textSize16 = const TextStyle(
    fontSize: Dimens.font_sp16,
  );
  static const TextStyle textBold14 = const TextStyle(
      fontSize: Dimens.font_sp14,
      fontWeight: FontWeight.bold
  );
  static const TextStyle textBold16 = const TextStyle(
      fontSize: Dimens.font_sp16,
      fontWeight: FontWeight.bold
  );
  static const TextStyle textBold18 = const TextStyle(
    fontSize: Dimens.font_sp18,
    fontWeight: FontWeight.bold
  );
  static const TextStyle textBold24 = const TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold
  );
  static const TextStyle textBold26 = const TextStyle(
      fontSize: 26.0,
      fontWeight: FontWeight.bold
  );
 
  static const TextStyle textGray14 = const TextStyle(
    fontSize: Dimens.font_sp14,
    color: AppColors.text_gray,
  );
  static const TextStyle textDarkGray14 = const TextStyle(
    fontSize: Dimens.font_sp14,
    color: AppColors.dark_text_gray,
  );

  static const TextStyle textWhite14 = const TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colors.white,
  );
  
  static const TextStyle text = const TextStyle(
    fontSize: Dimens.font_sp14,
    color: AppColors.text,
    // https://github.com/flutter/flutter/issues/40248
    textBaseline: TextBaseline.alphabetic
  );
  static const TextStyle textDark = const TextStyle(
    fontSize: Dimens.font_sp14,
    color: AppColors.dark_text,
    textBaseline: TextBaseline.alphabetic
  );

  static const TextStyle textDarkLight = const TextStyle(
    fontSize: Dimens.font_sp14,
    color: AppColors.dark_text,
    textBaseline: TextBaseline.alphabetic
  );

  static const TextStyle textWhite = const TextStyle(
    fontSize: Dimens.font_sp14,
    color: AppColors.text_white,
    textBaseline: TextBaseline.alphabetic
  );

  static const TextStyle textGray12 = const TextStyle(
    fontSize: Dimens.font_sp12,
    color: AppColors.text_gray,
    fontWeight: FontWeight.normal
  );

  static const TextStyle textDarkGray12 = const TextStyle(
    fontSize: Dimens.font_sp12,
    color: AppColors.dark_text_gray,
    fontWeight: FontWeight.normal
  );

  static const TextStyle textGray13 = const TextStyle(
    fontSize: Dimens.font_sp13,
    color: AppColors.text_gray,
    fontWeight: FontWeight.normal
  );

  static const TextStyle textDarkGray13 = const TextStyle(
    fontSize: Dimens.font_sp12,
    color: AppColors.dark_text_gray,
    fontWeight: FontWeight.normal
  );
  
  static const TextStyle headTextGray12 = const TextStyle(
    fontSize: Dimens.font_sp12,
    color: AppColors.head_text_gray,
    fontWeight: FontWeight.normal
  );
  
  static const TextStyle headTextDarkGray12 = const TextStyle(
    fontSize: Dimens.font_sp12,
    color: AppColors.dark_text_gray,
    fontWeight: FontWeight.normal
  );

  static const TextStyle priceText = const TextStyle(
    fontSize: Dimens.font_sp12,
    color: AppColors.price_text,
    fontWeight: FontWeight.normal
  );
  static const TextStyle priceTextDark = const TextStyle(
    fontSize: Dimens.font_sp12,
    color: AppColors.dark_price_text,
    fontWeight: FontWeight.normal
  );
  
  static const TextStyle textHint14 = const TextStyle(
    fontSize: Dimens.font_sp14,
    color: AppColors.dark_unselected_item_color
  );

}


class Decorations {
  static Decoration bottom = BoxDecoration(
    border: Border(bottom: BorderSide(width: 0.33, color: AppColors.divider))
  );
}
/// 间隔
class Gaps {
  static const Widget empty = const SizedBox();
  /// 水平间隔
  static Widget hGap5 = new SizedBox(width: Dimens.gap_dp5);
  static Widget hGap10 = new SizedBox(width: Dimens.gap_dp10);
  static Widget hGap15 = new SizedBox(width: Dimens.gap_dp15);

  /// 垂直间隔
  static Widget vGap5 = new SizedBox(height: Dimens.gap_dp5);
  static Widget vGap10 = new SizedBox(height: Dimens.gap_dp10);
  static Widget vGap15 = new SizedBox(height: Dimens.gap_dp15);
}


