// 图片关闭按钮
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';


class CloseFloatButtom extends StatelessWidget {
  CloseFloatButtom({
    Key key,
    this.bgSize = 24.0,
    this.theme = 'light',
    this.color = Colors.white,
    this.clickPadding = 20.0,
  }) : padding = bgSize*0.27,  super(key: key);

  final double bgSize;
  final String theme;
  final Color color;
  final double padding;
  final double clickPadding;

  @override
  Widget build(BuildContext context) {

    Widget _buildCloseIcon() {
      return Container(
        padding : EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Theme.of(context).textTheme.title.color.withOpacity(0.4),
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: theme == 'light'
        ?
        Icon(AntDesign.close, size: 20.0)
        // Container(
        //   width: double.infinity,
        //   height: double.infinity,
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage('assets/images/close.png'),
        //       fit: BoxFit.cover
        //     ),
        //   ),
        // )
        :
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/close-light.png'),
              fit: BoxFit.cover
            ),
          ),
        )
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: SafeArea(
        top: true,
        child: Container(
          width: this.bgSize + this.clickPadding,
          height: this.bgSize + this.clickPadding,
          padding: EdgeInsets.all(this.clickPadding/2),
          color: Colors.red.withOpacity(0.0),
          child: Center(
            child: _buildCloseIcon()
          ),
        )
      )
    );
  }
}