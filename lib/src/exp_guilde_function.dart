import 'package:flutter/cupertino.dart';

import 'curve_painter.dart';
import 'guide_logs.dart';
import 'guide_page.dart';

///是否输出日志
///显示新手蒙版引导页面
/// 更多信息可查看 https://blog.csdn.net/zl18603543572
///[context]当前上下文对象
///[curvePointList] 需要引导的位置信息  List，
///   CurvePoint 中 x,y 指定指引位置 从0-1 ，手机屏幕左上角开始为（0，0）位置，右下角为(1,1)
///   CurvePoint tipsMessage 为引导框内显示的文字
/// [pointX][pointY]用来设定单点指引，当 [curvePointList] 为 null 的时候起作用
/// [tipsTextColor] 气泡提示框的内容文字颜色
/// [isSlide] 是否可滑动气泡
/// [logs] 是否输出日志
/// [clickCallback] 点击下一步的回调事件 参数 isEnd 为true 时表示最后一页指引
void showBeginnerGuidance(BuildContext context,
    {List<CurvePoint> curvePointList,
      double pointX = 0,
      double pointY = 0,
      Color tipsTextColor,
      bool isSlide = false,
      bool logs = false,
      Function(bool isEnd) clickCallback}) {
  GuideLogs.isLogs = logs;

  ///背景透明的跳转
  Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    pageBuilder: (context, animation, secondaryAnimation) {
      ///GuideSplashPage 是引导页面具体实现
      return GuideSplashPage(
          curvePointList: curvePointList,
          pointX: pointX,
          pointY: pointY,
          textColor: tipsTextColor,
          isSlide: isSlide,
          clickCallback: clickCallback);
    },
    transitionsBuilder: (BuildContext context, Animation<double> animation1,
        Animation<double> animation2, Widget child) {
      ///  渐变过渡
      return FadeTransition(
        ///渐变过渡 0.0-1.0
        opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          ///动画样式
          parent: animation1,
          ///动画曲线
          curve: Curves.fastOutSlowIn,
        ),),
        child: child,
      );
    },),);
}
