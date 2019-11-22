import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowUtil{
  static void showSnackBar(BuildContext context, String msg){
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text('$msg'),),
    );
  }

}