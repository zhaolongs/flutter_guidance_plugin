
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
                      widget.pointX = startDetails.globalPosition.dx;
                      widget.pointY = startDetails.globalPosition.dy;
                    });
                  }
                },
                onHorizontalDragUpdate: (startDetails) {
                  GuideLogs.e('位置变化 dx:${startDetails.globalPosition.dx}  dy:${startDetails.globalPosition.dy}');
                  if (widget.isSlide) {
                    setState(() {
                      widget.pointX = startDetails.globalPosition.dx;
                      widget.pointY = startDetails.globalPosition.dy;
                    });
                  }
                },
                /*横向拖动的结束状态*/
                onHorizontalDragEnd: (endDetails) {
                  GuideLogs.e('拖动的结束');
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
        onWillPop: () async {
          return Future.value(false);
        });
  }

  ///用户计算下一步的点击事件
  void onTap(BuildContext context, TapUpDetails detail) {
    Offset globalPosition = detail.globalPosition;
    GuideLogs.e("onTapUp 点击了 ${globalPosition.dx}  ${globalPosition.dy}");
    if (nextRect != null) {
      double left = nextRect.left - 60;
      double right = nextRect.right + 60;
      double bottom = nextRect.bottom + 60;
      double top = nextRect.top - 60;
      double dx = globalPosition.dx;
      double dy = globalPosition.dy;

      if (dx > left && dx < right && dy > top && dy < bottom) {
        if (currentPointIndex < widget.curvePointList.length - 1) {
          setState(() {
            currentPointIndex++;
          });
          if(widget.clickCallback!=null){
            widget.clickCallback(false);
          }
        } else {
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
//      painter: CurvePainter(widget.textColor, curvePoint.x, curvePoint.y,textTip: curvePoint.tipsMessage,
//          clickLiser: liserClickCallback),
      painter: CurvePainter(
          widget.textColor, widget.pointX / width, widget.pointY / height,
          textTip: curvePoint.tipsMessage, clickLiser: liserClickCallback),

      ///完成绘画之后，子画构将显示在绘画的顶部。
//      child: Center(
//        child: Text("Blade Runner"),
//      ),

      ///foregroundPaint：最后，这个油漆绘制在前两个图层的顶部
      ///foregroundPainter:CurvePainter(widget.textColor, 0.4, 0.4),
    );
  }
}
