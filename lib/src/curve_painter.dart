import 'dart:math';
import 'dart:ui' as ui; //这里用as取个别名，有库名冲突

import 'package:flutter/material.dart';
import 'package:flutter_guidance_plugin/src/guide_logs.dart';

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


///提示框的位置
enum CurverAlign {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

///箭头的位置
enum ArrowsAlign {
  top,
  bottomtLeft,
  bottomtRight,
}

class CurvePainter extends CustomPainter {
  double pointX = 0;
  double pointY = 0;

  double pointWidth = 0;
  double pointHeight = 0;

  ///为true时显示指引的矩形
  bool isShowReact;

  ///文字颜色
  Color textColor;

  ///对齐位置
  CurverAlign curverAlign = CurverAlign.topRight;
  ArrowsAlign curverArrowsAlign = ArrowsAlign.bottomtRight;

  ///提示文字
  String textTip = "这里是旱这里是旱这里是旱这里是旱这里是旱这里是旱这里是旱这里是旱这里是旱这里是旱";
  String defaultTextTip = "请输入提示文字";

  ///下一步文字颜色
  Color nextTextColor = Colors.black;

  ///下一步文字
  String nextTextTip;

  ///
  Offset slideOffset;
  Offset preSlideOffset;
  Function(Rect rect) clickLiser;

  CurvePainter(this.textColor, this.pointX, this.pointY,
      {this.clickLiser, this.textTip, this.nextTextTip = "下一步", this.slideOffset,this.pointHeight,this.pointWidth,this.isShowReact});

  ///实际的绘画发生在这里
  @override
  void paint(Canvas canvas, Size size) {

    canvas.save();
    //屏幕高,这里不是一直成立,像当有Center 父控件的时候就不成立
    double height = size.height;
    //屏幕宽
    double width = size.width;
    GuideLogs.e("当前指示点 x $pointX y $pointY");

    ///计算箭头的位置
    ///外面传来的是 0-1
    ///坐标轴从手机的屏幕左上角为原点 左上角 x=0,y=0, 右下角 x=1,y=1
    if (pointX < 0) {
      pointX = 0;
    } else if (pointX > 1) {
      pointX = 1.0;
    }

    if (pointY < 0) {
      pointY = 0;
    } else if (pointY > 1) {
      pointY = 1.0;
    }


    curverArrowsAlign = ArrowsAlign.top;
    curverAlign = CurverAlign.center;
//
    if (pointY <= 0.3) {
      ///屏幕的上部分 箭头在上 提示框在中
      curverArrowsAlign = ArrowsAlign.top;
      if (pointX < 0.5) {
        curverAlign = CurverAlign.center;
      } else {
        curverAlign = CurverAlign.centerRight;
      }
    } else if (pointY > 0.3 && pointY < 0.6) {
      if (pointX < 0.3) {
        curverArrowsAlign = ArrowsAlign.bottomtLeft;
        curverAlign = CurverAlign.topLeft;
      } else {
        curverArrowsAlign = ArrowsAlign.bottomtRight;
        curverAlign = CurverAlign.topRight;
      }
    } else {
      if (pointX < 0.3) {
        curverArrowsAlign = ArrowsAlign.bottomtLeft;
        curverAlign = CurverAlign.centerLeft;
      } else {
        curverArrowsAlign = ArrowsAlign.bottomtRight;
        curverAlign = CurverAlign.centerRight;
      }
    }

    double ex = pointX * width;
    double ey = pointY * height;


    /**
     * A点来控制 对齐位置
     */
    double left = (width - 214) / 2;
    double top = 64;
    if (slideOffset == null || slideOffset == Offset.zero) {
      if (curverAlign == CurverAlign.topCenter) {
        ///顶部居中
        left = (width - 214) / 2;
        top = 64;
      } else if (curverAlign == CurverAlign.topLeft) {
        ///顶部左对齐
        left = (width - 214) / 2;
        top = 64;
      } else if (curverAlign == CurverAlign.topRight) {
        ///顶部右对齐
        left = width - 214;
        top = 64;
      } else if (curverAlign == CurverAlign.center) {
        ///居中
        left = (width - 214) / 2;
        top = height / 2 - 20;
      } else if (curverAlign == CurverAlign.centerLeft) {
        ///居中左对齐
        left = 0;
        top = height / 2 - 20;
      } else if (curverAlign == CurverAlign.centerRight) {
        ///居中右对齐
        left = width - 214;
        top = height / 2 - 20;
      } else if (curverAlign == CurverAlign.bottomCenter) {
        ///居中底部
        left = (width - 214) / 2;
        top = height - 100;
      } else if (curverAlign == CurverAlign.bottomLeft) {
        ///居中左对齐
        left = 0;
        top = height - 100;
      } else if (curverAlign == CurverAlign.bottomRight) {
        ///居中右对齐
        left = width - 214;
        top = height - 100;
      }
      preSlideOffset = Offset(top, left);
    } else {
      left = slideOffset.dx - 20;
      top = slideOffset.dy - 20;
    }

    CurvePoint A = CurvePoint(left, top);

    ///TODO 这还没写好
    ///
    drawBackgroundFunction(canvas,ex,ey,size);

    ///绘制箭头在右下角的内容
    if (curverArrowsAlign == ArrowsAlign.bottomtRight) {
      ey-=pointHeight;
      drawArrowsBottomRight(canvas, A, size, ex, ey);
    } else if (curverArrowsAlign == ArrowsAlign.bottomtLeft) {
      ey-=pointHeight;
      drawArrowsBottomLeft(canvas, A, size, ex, ey);
    } else if (curverArrowsAlign == ArrowsAlign.top) {
      drawArrowsTopLeft(canvas, A, size, ex, ey);
    }

    canvas.restore();
  }

  ///你的绘画依赖于一个变量并且该变量发生了变化，那么你在这里返回true，
  ///这样Flutter就知道它必须调用paint方法来重绘你的绘画。否则，在此处返回false表示您不需要重绘
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Rect rect2;
  void drawBackgroundFunction(Canvas canvas,double ex,double ey,Size size) {
    ///绘制蒙版背景
    Paint backgroundPaint = new Paint();
    backgroundPaint.color=Color(0x90000000);
    canvas.drawRect(Rect.fromLTRB(0, 0, 0, 0), backgroundPaint);

    //绘制两个矩形
    Rect rect1 = Rect.fromCircle(center: Offset(0.0, 0.0), radius:size.height);
    if(isShowReact&&pointWidth!=null&&pointWidth!=0&&pointHeight!=null&&pointHeight!=0){
        rect2 = Rect.fromLTRB(ex, ey-pointHeight,ex+pointWidth,ey);
    }else{
      rect2 = Rect.fromCircle(center: Offset(0, 0), radius: 0.0);
    }
    //分别绘制外部圆角矩形和内部的圆角矩形
    RRect outer = RRect.fromRectAndRadius(rect1, Radius.circular(0));
    RRect inner = RRect.fromRectAndRadius(rect2, Radius.circular(pointWidth/5));
    canvas.drawDRRect(outer, inner, backgroundPaint);
  }

  double wRadious = 214 / 2;
  double hRadious = 55;

  void drawArrowsTopLeft(Canvas canvas, CurvePoint A, Size size, double ex,
      double ey) {
    var paint = Paint();
    paint.color = Colors.white;
    var path = Path();

    CurvePoint a1 = CurvePoint(A.x, A.y - 24);
    CurvePoint a2 = CurvePoint(A.x, A.y + 33);

    CurvePoint F = CurvePoint(A.x + 28, A.y - 38);
    CurvePoint f1 = CurvePoint(F.x - 8, F.y + 9);
    CurvePoint f2 = CurvePoint(F.x + 15, F.y - 10);

    ///在这里的E点就是 指向提示的位置 203 133
    CurvePoint E = CurvePoint(ex, ey);
    CurvePoint e1 = CurvePoint(E.x, E.y);
    CurvePoint e2 = CurvePoint(E.x, E.y);

    CurvePoint B = CurvePoint(A.x + 100, A.y - 55);
    CurvePoint b1 = CurvePoint(B.x - 52, B.y);
    CurvePoint b2 = CurvePoint(B.x + 66, B.y);

    CurvePoint C = CurvePoint(A.x + 214, A.y);
    CurvePoint c1 = CurvePoint(C.x, C.y - 30);
    CurvePoint c2 = CurvePoint(C.x, C.y + 30);

    CurvePoint G = CurvePoint(A.x + 110, A.y + 55);
    CurvePoint g1 = CurvePoint(G.x + 66, G.y);
    CurvePoint g2 = CurvePoint(G.x - 52, G.y + 1);

    ///A点
    path.moveTo(A.x, A.y);

    /// 绘制到 F点
    path.cubicTo(a1.x, a1.y, f1.x, f1.y, F.x, F.y);

    /// 绘制到 E点
    path.cubicTo(f2.x, f2.y, e1.x, e1.y, E.x, E.y);

    /// 绘制到 B点
    path.cubicTo(e2.x, e2.y, b1.x, b1.y, B.x, B.y);

    /// 绘制到 C点（214, 55）
    path.cubicTo(b2.x, b2.y, c1.x, c1.y, C.x, C.y);

    /// 绘制到 G点（111,110）
    path.cubicTo(c2.x, c2.y, g1.x, g1.y, G.x, G.y);

    path.cubicTo(g2.x, g2.y, a2.x, a2.y, A.x, A.y);

    ///绘制 Path
    canvas.drawPath(path, paint);




    ///绘制点位置
    canvas.drawCircle(Offset(ex, ey), 4, paint);

    ///绘制文本
    drawTextFunction(
        C.x - A.x - 40, Offset(A.x + 20, A.y - 20), canvas, textTip);

    ///绘制下一步
    drawNextFunction(A, B, C, G,size,canvas, nextTextTip);
  }

  ///绘制箭头在右下角的内容
  void drawArrowsBottomRight(Canvas canvas, CurvePoint A,Size size,
      double ex, double ey) {
    var paint = Paint();
    paint.color = Colors.white;
    var path = Path();

    CurvePoint a1 = CurvePoint(A.x, A.y - 30);
    CurvePoint a2 = CurvePoint(A.x, A.y + 31);

    CurvePoint B = CurvePoint(A.x + 100, A.y - 55);
    CurvePoint b1 = CurvePoint(B.x - 52, B.y);
    CurvePoint b2 = CurvePoint(B.x + 66, B.y);

    CurvePoint C = CurvePoint(A.x + 214, A.y);
    CurvePoint c1 = CurvePoint(C.x, C.y - 30);
    CurvePoint c2 = CurvePoint(C.x, C.y + 15);

    CurvePoint D = CurvePoint(A.x + 188, A.y + 38);
    CurvePoint d1 = CurvePoint(D.x + 16, D.y - 11);
    CurvePoint d2 = CurvePoint(D.x - 6, D.y + 2);

    ///在这里的E点就是 指向提示的位置 203 133
    CurvePoint E = CurvePoint(ex, ey);
    CurvePoint e1 = CurvePoint(A.x + 208, A.y + 75);
    CurvePoint e2 = CurvePoint(A.x + 198, A.y + 81);

    CurvePoint F = CurvePoint(A.x + 157, A.y + 52);
    CurvePoint f1 = CurvePoint(F.x + 5, F.y - 3);
    CurvePoint f2 = CurvePoint(F.x - 14, F.y + 1);

    CurvePoint G = CurvePoint(A.x + 111, A.y + 55);
    CurvePoint g1 = CurvePoint(G.x + 15, G.y);
    CurvePoint g2 = CurvePoint(G.x - 63, G.y + 1);

    ///A点
    path.moveTo(A.x, A.y);

    /// 绘制到 B点（100，0）
    path.cubicTo(a1.x, a1.y, b1.x, b1.y, B.x, B.y);

    /// 绘制到 C点（214, 55）
    path.cubicTo(b2.x, b2.y, c1.x, c1.y, C.x, C.y);

    /// 绘制到 D点（188, 93）
    path.cubicTo(c2.x, c2.y, d1.x, d1.y, D.x, D.y);

    /// 绘制到 E点（203,133）
    path.cubicTo(d2.x, d2.y, e1.x, e1.y, E.x, E.y);

    /// 绘制到 F点（157,107）
    path.cubicTo(e2.x, e2.y, f1.x, f1.y, F.x, F.y);

    /// 绘制到 G点（111,110）
    path.cubicTo(f2.x, f2.y, g1.x, g1.y, G.x, G.y);

    /// 绘制到 A点（0, 55）闭合
    path.cubicTo(g2.x, g2.y, a2.x, a2.y, A.x, A.y);

    ///绘制 Path
    canvas.drawPath(path, paint);

    ///绘制点位置
    canvas.drawCircle(Offset(ex, ey), 4, paint);

    ///绘制文本
    drawTextFunction(
        C.x - A.x - 40, Offset(A.x + 20, A.y - 20), canvas, textTip);

    ///绘制下一步
    drawNextFunction(A, B, C, G,size,canvas, nextTextTip);
  }

  void drawArrowsBottomLeft(Canvas canvas, CurvePoint A, Size size,
      double ex, double ey) {
    var paint = Paint();
    paint.color = Colors.white;
    var path = Path();

    CurvePoint a1 = CurvePoint(A.x, A.y - 30);
    CurvePoint a2 = CurvePoint(A.x, A.y + 22);

    CurvePoint B = CurvePoint(A.x + 100, A.y - 55);
    CurvePoint b1 = CurvePoint(B.x - 52, B.y);
    CurvePoint b2 = CurvePoint(B.x + 66, B.y);

    CurvePoint C = CurvePoint(A.x + 214, A.y);
    CurvePoint c1 = CurvePoint(C.x, C.y - 30);
    CurvePoint c2 = CurvePoint(C.x, C.y + 30);

    CurvePoint G = CurvePoint(A.x + 110, A.y + 55);
    CurvePoint g1 = CurvePoint(G.x + 66, G.y);
    CurvePoint g2 = CurvePoint(G.x - 52, G.y + 1);

    CurvePoint D = CurvePoint(A.x + 52, A.y + 47);
    CurvePoint d1 = CurvePoint(D.x + 6, D.y + 2);
    CurvePoint d2 = CurvePoint(D.x - 6, D.y - 6);

    ///在这里的E点就是 指向提示的位置 203 133
    CurvePoint E = CurvePoint(ex, ey);
    CurvePoint e1 = CurvePoint(E.x, E.y);
    CurvePoint e2 = CurvePoint(E.x, E.y);

    CurvePoint F = CurvePoint(A.x + 28, A.y + 38);
    CurvePoint f1 = CurvePoint(F.x + 5, F.y - 3);
    CurvePoint f2 = CurvePoint(F.x - 8, F.y - 9);

    ///A点
    path.moveTo(A.x, A.y);

    /// 绘制到 B点（100，0）
    path.cubicTo(a1.x, a1.y, b1.x, b1.y, B.x, B.y);

    /// 绘制到 C点（214, 55）
    path.cubicTo(b2.x, b2.y, c1.x, c1.y, C.x, C.y);

    /// 绘制到 G点（111,110）
    path.cubicTo(c2.x, c2.y, g1.x, g1.y, G.x, G.y);

    /// 绘制到 D点（188, 93）
    path.cubicTo(g2.x, g2.y, d1.x, d1.y, D.x, D.y);

    /// 绘制到 E点（203,133）
    path.cubicTo(d2.x, d2.y, e1.x, e1.y, E.x, E.y);
//
//     /// 绘制到 F点（157,107）
    path.cubicTo(e2.x, e2.y, f1.x, f1.y, F.x, F.y);
//
//     /// 绘制到 A点（0, 55）闭合
    path.cubicTo(f2.x, f2.y, a2.x, a2.y, A.x, A.y);

    ///绘制 Path
    canvas.drawPath(path, paint);

    ///绘制点位置
    canvas.drawCircle(Offset(ex, ey), 4, paint);

    ///绘制文本
    drawTextFunction(
        C.x - A.x - 40, Offset(A.x + 20, A.y - 20), canvas, textTip);

    ///绘制下一步
    drawNextFunction(A, B, C, G,size,canvas, nextTextTip);
  }


  void drawNextFunction(CurvePoint A, CurvePoint B, CurvePoint C, CurvePoint G,Size size, Canvas canvas,
      String text,
      {Color textColor = Colors.blue}) {

    double nextX=0;
    double nextY=0;

    if(curverAlign==CurverAlign.centerRight){
      if(curverArrowsAlign==ArrowsAlign.top){
        ///下面 参考点 G
        nextY = G.y+44*2;
        nextX = G.x-120;
      }else{
        ///上面 参考点 B点
        nextY = B.y-44*2;
        nextX = B.x-120;
      }
    }else if(curverAlign==CurverAlign.centerLeft){
      if(curverArrowsAlign==ArrowsAlign.top){
        ///下面 参考点 G
        nextY = G.y+44*2;
        nextX = G.x+120;
      }else{
        ///上面 参考点 B点
        nextY = B.y-44*2;
        nextX = B.x+120;
      }
    }else if(curverAlign==CurverAlign.center){
      if(curverArrowsAlign==ArrowsAlign.top){
        ///下面 参考点 G
        nextY = G.y+44*2;
        nextX = G.x;
      }else{
        ///上面 参考点 B点
        nextY = B.y-44*2;
        nextX = B.x;
      }
    }else{
      nextY = size.height/2-44;
      nextX = size.width/2-60;
    }

    if(nextX<0){
      nextX=0;
    }else if(nextX+120>size.width){
      nextX = size.width-120;
    }

    var paint = Paint();
    paint.color = Colors.white;
    //用Rect构建一个边长50,中心点坐标为100,100的矩形
    Rect rect =
    Rect.fromCenter(center: Offset(nextX, nextY), width: 120, height: 44);
    //根据上面的矩形,构建一个圆角矩形
    RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(22.0));
    canvas.drawRRect(rrect, paint);

    ///点击区域位置记录
    if (clickLiser != null) {
      clickLiser(rect);
    }

    drawTextFunction(rect.width,Offset(rect.left,rect.top+10),canvas,"下一步");

  }

  ///[textWidth] 文本的宽度
  ///[textOffset] 文本绘制的开始位置 左上角
  ///[text] 绘制的文字内容
  void drawTextFunction(double textWidth, Offset textOffset, Canvas canvas,
      String text,
      {Color textColor = Colors.blue}) {
    ///创建画笔
    var textPaint = Paint();

    ///设置画笔颜色
    textPaint.color = textColor;

    /// 新建一个段落建造器，然后将文字基本信息填入;
    ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 15.0,
    ));

    ///设置文字的样式
    pb.pushStyle(ui.TextStyle(color: textColor));

    if (text == null || text.length == 0) {
      text = "--";
    } else if (text.length > 20) {
      text = text.substring(0, 20);
      text += "...";
    }
    pb.addText(text);
    // 设置文本的宽度约束
    ui.ParagraphConstraints pc = ui.ParagraphConstraints(width: textWidth);
    // 这里需要先layout,将宽度约束填入，否则无法绘制
    ui.Paragraph paragraph = pb.build()
      ..layout(pc);

    ///偏移量在这里指的是文字左上角的 位置
    canvas.drawParagraph(paragraph, textOffset);
  }


}

class CurvePainter1 extends CustomPainter {
  ///实际的绘画发生在这里
  @override
  void paint(Canvas canvas, Size size) {
    ///创建画笔
    var paint = Paint();

    ///设置画笔的颜色
    paint.color = Colors.blue;

    ///创建路径
    var path = Path();

    ///A点 设置初始绘制点
    path.moveTo(0, 55);

    /// 绘制到 B点（100，0）
    path.cubicTo(0, 25, 48, 0, 100, 0);

    /// 绘制到 C点（214, 55）
    path.cubicTo(166, 0, 214, 25, 214, 55);

    ///绘制 Path
    canvas.drawPath(path, paint);
  }

  ///你的绘画依赖于一个变量并且该变量发生了变化，那么你在这里返回true，
  ///这样Flutter就知道它必须调用paint方法来重绘你的绘画。否则，在此处返回false表示您不需要重绘
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
