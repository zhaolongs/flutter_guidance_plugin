
import 'package:flutter/cupertino.dart';

class CurvePoint {

  ///x,y 指定指引位置 从0-1 ，手机屏幕左上角开始为（0，0）位置，右下角为(1,1)
  double x;
  double y;

  ///要指示的区域透明
  double eWidth;
  double eHeight;

  ///为引导框内显示的文字
  String tipsMessage;
  String nextString;

  ///为true时显示指引的矩形
  bool isShowReact;

  CurvePoint(this.x, this.y,
      {this.tipsMessage = "--", this.nextString = "下一步",this.eWidth=0, this.eHeight=0,this.isShowReact=false});
}

class GlobalKeyPoint {

  ///widget 对应key 程序自动判断
  GlobalKey key;

  ///为引导框内显示的文字
  String tipsMessage;
  String nextString;
  ///为true时显示指引的矩形
  bool isShowReact;

  GlobalKeyPoint(this.key,
      {this.tipsMessage = "--", this.nextString = "下一步",this.isShowReact=false});
}

