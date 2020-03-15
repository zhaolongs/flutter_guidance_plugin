
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guidance_plugin/src/guide_logs.dart';

import 'curve_painter.dart';

class GuideSplashPage extends StatefulWidget {
  ///用户指引行为
  Color textColor;
  double pointX = 0;
  double pointY = 0;

  ///是否可滑动
  bool isSlide = false;

  List<CurvePoint> curvePointList;
  Function(bool isEnd) clickCallback;
  GuideSplashPage(
      {this.curvePointList,
      this.textColor = Colors.black,
      this.pointX = 0,
      this.pointY = 0,
      this.isSlide = false,this.clickCallback});

  @override
  State<StatefulWidget> createState() {
    return _GuidePageState();
  }
}

class _GuidePageState extends State<GuideSplashPage> {
  ///当前可点击的下一步
  Rect nextRect;
  int currentPointIndex = 0;

  ///滑动记录的点位
  Offset slideOffset;

  @override
  void initState() {
    super.initState();

    if (widget.curvePointList == null || widget.curvePointList.length == 0) {
      widget.curvePointList = [];
      widget.curvePointList.add(CurvePoint(widget.pointX, widget.pointY));
    }
  }

  @override
  Widget build(BuildContext context) {
    double padding = (MediaQuery.of(context).size.width / 9);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ///在Flutter中通过WillPopScope来实现返回按钮拦截
    return WillPopScope(
        child: Container(
          height: height,
          width: width,
          color: Color(0x90000000),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: new Material(
              color: Color(0x00ffffff),
              type: MaterialType.transparency,
              child: GestureDetector(
                onTapUp: (TapUpDetails detail) {
                  GuideLogs.e('onTapUp');
                  onTap(context, detail);
                },
                /*横向拖动的开始状态*/
                onHorizontalDragStart: (startDetails) {
                  GuideLogs.e('拖动的开始');
                  if (widget.isSlide) {
                    setState(() {
                      slideOffset = startDetails.globalPosition;
                    });
                  }
                },
                onHorizontalDragUpdate: (startDetails) {
                  GuideLogs.e('位置变化 dx:${startDetails.globalPosition.dx}  dy:${startDetails.globalPosition.dy}');
                  if (widget.isSlide) {
                    setState(() {
                     slideOffset = startDetails.globalPosition;
                    });
                  }
                },
                /*横向拖动的结束状态*/
                onHorizontalDragEnd: (endDetails) {
                  GuideLogs.e('拖动的结束');
                  if (widget.isSlide) {
                    setState(() {
                      slideOffset = Offset.zero;
                    });
                  }
                },
                child: Stack(
                  children: <Widget>[
                    buildCustomPainter(),
                  ],
                ),
              ),
            ),
          ),
        ),
        ///在Android手机中，当点击后退按钮的时候，会回调此事件
        ///在这里返回 false 表示拦截事件
        onWillPop: () async {
          return Future.value(false);
        });
  }

  ///用户计算下一步的点击事件
  void onTap(BuildContext context, TapUpDetails detail) {
    Offset globalPosition = detail.globalPosition;
    GuideLogs.e("onTapUp 点击了 ${globalPosition.dx}  ${globalPosition.dy}");
    if (nextRect != null) {
      ///获取当前 下一步的区域
      double left = nextRect.left - 60;
      double right = nextRect.right + 60;
      double bottom = nextRect.bottom + 60;
      double top = nextRect.top - 60;
      ///获取当前屏幕上手指点击的位置
      double dx = globalPosition.dx;
      double dy = globalPosition.dy;

      if (dx > left && dx < right && dy > top && dy < bottom) {
        if (currentPointIndex < widget.curvePointList.length - 1) {
          ///如果当前不是最后一页面，那么取出下一页的内容信息
          setState(() {
            currentPointIndex++;
          });
          ///蒙版中点击下一步的回调事件
          if(widget.clickCallback!=null){
            widget.clickCallback(false);
          }
        } else {
          ///如果是最后一页退出蒙版引导
          if(widget.clickCallback!=null){
            widget.clickCallback(true);
          }
          Navigator.of(context).pop();
        }
      }
    }
  }

  ///记录下一步按钮位置的回调
  void liserClickCallback(Rect rect) {
    this.nextRect = rect;
  }

  Widget buildCustomPainter() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    ///获取当前指引信息
    CurvePoint curvePoint = widget.curvePointList[currentPointIndex];

    ///画布由CustomPaint小部件创建并提供
    return CustomPaint(
      size: Size(width, height),

      ///这是CustomPainter类的一个实例，它在画布上绘制绘画的第一层
      painter: CurvePainter(widget.textColor, curvePoint.x, curvePoint.y,textTip: curvePoint.tipsMessage,
          clickLiser: liserClickCallback,slideOffset:slideOffset),
//      painter: CurvePainter(
//          widget.textColor, widget.pointX / width, widget.pointY / height,
//          textTip: curvePoint.tipsMessage, clickLiser: liserClickCallback),

      ///完成绘画之后，子画构将显示在绘画的顶部。
//      child: Center(
//        child: Text("Blade Runner"),
//      ),

      ///foregroundPaint：最后，这个油漆绘制在前两个图层的顶部
      ///foregroundPainter:CurvePainter(widget.textColor, 0.4, 0.4),
    );
  }
}
