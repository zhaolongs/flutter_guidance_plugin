import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_guidance_plugin/src/guide_logs.dart';

import 'curve_painter.dart';
import 'guide_bean.dart';

class GuideSplashPage extends StatefulWidget {
  ///用户指引行为
  double pointX = 0;
  double pointY = 0;


  ///提示文字颜色
  Color tipsTextColor;
  ///提示文字背景颜色
  Color tipsBackgroundColor;
  ///提示文字内容
  String textTip ;
  ///提示文字大小
  double tipsTextSize;


  ///下一步文字颜色
  Color nextTextColor ;
  ///下一步背景颜色
  Color nextBackgroundColor;
  ///下一步文字
  String nextTextTip;
  ///下一步文字大小
  double nextTextSize;


  ///是否可滑动
  bool isSlide = false;

  ///需要引导的位置信息  List，GlobalKey widget 位置主键标识
  ///还是要转换成 List<CurvePoint>
  List<GlobalKeyPoint> globalKeyPointList;
  List<CurvePoint> curvePointList;
  Function(bool isEnd) clickCallback;

  GuideSplashPage({this.globalKeyPointList,
    this.curvePointList,
    this.tipsTextColor = Colors.blue,
    this.tipsBackgroundColor = Colors.white,
    this.tipsTextSize=16.0,
    ///下一步文字颜色
    this. nextTextColor ,
    ///下一步背景颜色
    this. nextBackgroundColor,
    ///下一步文字
    this. nextTextTip,
    ///下一步文字大小
    this. nextTextSize,
    this.pointX = 0,
    this.pointY = 0,
    this.isSlide = false,
    this.clickCallback});

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

    // 监听widget渲染完成
    WidgetsBinding.instance.addPostFrameCallback((duration){
      ///页面初始化完成后再构建数据
     controllerInitData();
    });
  }
  void controllerInitData() {


    if ((widget.globalKeyPointList == null ||
        widget.globalKeyPointList.length == 0) &&
        (widget.curvePointList == null || widget.curvePointList.length == 0)) {
      widget.curvePointList = [];
      widget.curvePointList.add(CurvePoint(widget.pointX, widget.pointY,tipsMessage:widget.textTip));
    } else if (widget.globalKeyPointList != null &&
        widget.globalKeyPointList.length > 0) {

      widget.curvePointList = [];

      ///获取当前屏幕的宽与高
      double screenWidth2 = MediaQuery
          .of(context)
          .size
          .width;
      double screenHeight2 = MediaQuery
          .of(context)
          .size
          .height;

      ///转换数据
      ///将 GlobalKeyPoint数据转为 CurvePoint 类型数据
      for (GlobalKeyPoint pointBean in widget.globalKeyPointList) {
        if (pointBean.key != null && pointBean.key.currentContext != null) {
          //获取position
          RenderBox renderBox = pointBean.key.currentContext.findRenderObject();
          ///获取 Offset
          Offset offset1 = renderBox.localToGlobal(Offset.zero);
          ///获取 Size
          //获取size
          Size size1 = renderBox.size;

          ///构建使用数据结构
          ///计算比例
          CurvePoint curvePoint = CurvePoint(
              offset1.dx / screenWidth2, (offset1.dy +size1.height) / screenHeight2,
              tipsMessage: pointBean.tipsMessage,
              nextString: pointBean.nextString,eWidth: size1.width,eHeight: size1.height,isShowReact: pointBean.isShowReact);


          widget.curvePointList.add(curvePoint);

          GuideLogs.e(
              "获取到的位置信息 dx ${offset1.dx}  dy  ${offset1
                  .dy}  screenWidht $screenWidth2  screenHeight $screenHeight2 eWidth${size1.width} eHeight${size1.height}");
        } else {
          GuideLogs.e("空数据 ");
        }
      }

      setState(() {

      });
    }
  }
  @override
  Widget build(BuildContext context) {
    double padding = (MediaQuery
        .of(context)
        .size
        .width / 9);
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    ///在Flutter中通过WillPopScope来实现返回按钮拦截
    return WillPopScope(
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
              GuideLogs.e(
                  '位置变化 dx:${startDetails.globalPosition
                      .dx}  dy:${startDetails.globalPosition.dy}');
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
        ///在Android手机中，当点击后退按钮的时候，会回调此事件
        ///在这里返回 false 表示拦截事件
        onWillPop: () async {
          return Future.value(false);
        });
  }

  ///用户计算下一步的点击事件
  void onTap(BuildContext context, TapUpDetails detail) {

    if(widget.curvePointList==null){
      Navigator.of(context).pop();
    }

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
          if (widget.clickCallback != null) {
            widget.clickCallback(false);
          }
        } else {
          ///如果是最后一页退出蒙版引导
          if (widget.clickCallback != null) {
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
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    if(widget.curvePointList==null||widget.curvePointList.length==0){
      return Container(height: height,width: width,color: Color(0x000000),);
    }

    ///获取当前指引信息
    CurvePoint curvePoint = widget.curvePointList[currentPointIndex];

    ///画布由CustomPaint小部件创建并提供
    return CustomPaint(
      size: Size(width, height),

      ///这是CustomPainter类的一个实例，它在画布上绘制绘画的第一层
      painter: CurvePainter(widget.tipsTextColor, curvePoint.x, curvePoint.y,
          tipsBackgroundColor: widget.tipsBackgroundColor,
          tipsTextSize: widget.tipsTextSize,
          textTip: curvePoint.tipsMessage,
          nextBackgroundColor: widget.nextBackgroundColor,
          nextTextSize: widget.nextTextSize,
          nextTextColor: widget.nextTextColor,
          nextTextTip: curvePoint.nextString,
          pointHeight: curvePoint.eHeight,
          pointWidth: curvePoint.eWidth,

          clickLiser: liserClickCallback,
          isShowReact: curvePoint.isShowReact,
          slideOffset: slideOffset),
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
