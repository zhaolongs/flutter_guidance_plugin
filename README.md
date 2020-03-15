# flutter_guidance_plugin
flutter新手蒙版引导功能插件



**题记**
  ——  执剑天涯，从你的点滴积累开始，所及之处，必精益求精，即是折腾每一天。
  
**重要消息**
*  [flutter中网络请求dio使用分析 视频教程在这里](https://edu.csdn.net/course/detail/27911)
* [Flutter 从入门实践到开发一个APP之UI基础篇  视频](https://edu.csdn.net/course/detail/25543)
* [Flutter 从入门实践到开发一个APP之开发实战基础篇](https://edu.csdn.net/course/detail/27035)
* [flutter跨平台开发一点一滴分析系列文章系列文章 在这里了](https://blog.csdn.net/zl18603543572/article/details/93532582)
***



最终实现的效果演示【左面ios】【右面android】
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200315115006380.gif)
***

> 本文将描述 在 flutter 项目中实现新手功能引导框功能
> 1、flutter_guidance_plugin 插件使用
> 2、组件 CustomPaint 与 CustomPainter 的使用分析
> 3、组件 WillPopScope 的使用分析
> 4、canvas 中手势识别 GestureDetector 使用分析
> 5、Container 实现蒙版效果
> 6、Canvas 绘制文本分析

#### 1 pub 引用 
在 flutter 项目中的配置文件 pubspec.yaml 中添加依赖 [插件源码在这里](https://github.com/zhaolongs/flutter_guidance_plugin)
```xml
  #新手蒙版引导插件
  flutter_guidance_plugin:
    #git 方式依赖
    git:
      #仓库地址
      url: https://github.com/zhaolongs/flutter_guidance_plugin.git
      # 分支
      ref: master
```

##### 2 创建引导使用
导包
```java
import 'package:flutter_guidance_plugin/flutter_guidance_plugin.dart';
```
创建指引数据

```java
  ///创建新手指引数据
  randomTestData(){
    List<CurvePoint> curvePointList = [];
    for (int i = 0; i < 5; i++) {
      ///创建指引
      CurvePoint curvePoint = CurvePoint(0, 0);
      if(i==0){
        ///x,y 指定指引位置 从0-1 ，手机屏幕左上角开始为（0，0）位置，右下角为(1,1)
        curvePoint.x = double.parse("0.5");
        curvePoint.y = double.parse("0.17");
        ///为引导框内显示的文字
        curvePoint.tipsMessage = "点击这里可 显示可滑动的引导蒙版";
      }else if(i==1){
        curvePoint.x = double.parse("0.5");
        curvePoint.y = double.parse("0.1");
        curvePoint.tipsMessage = "点击这里可 再次显示 引导蒙版";
      }else{
        curvePoint.x = double.parse("0.${_randomBit(3)}");
        curvePoint.y = double.parse("0.${_randomBit(3)}");
        curvePoint.tipsMessage = "这是随机的引导消息内容$i";
      }
      curvePointList.add(curvePoint);
    }
    return curvePointList;
  }
```

在这里我们使用到了 CurvePoint ，这是一个自定义的类，用来保存页面数据行为

```java
class CurvePoint {

  ///x,y 指定指引位置 从0-1 ，手机屏幕左上角开始为（0，0）位置，右下角为(1,1)
  double x;
  double y;
  ///为引导框内显示的文字
  String tipsMessage;
  String nextString;

  CurvePoint(this.x, this.y,
      {this.tipsMessage = "--", this.nextString = "下一步"});
}

```

然后触发蒙版指引-> 在刚刚进入页面时触发或者点击按钮时触发

```java
  void show1() {
    ///获取模拟数据
    List<CurvePoint>  curvePointList = randomTestData();
    ///参数一 上下文对象
    ///参数二 [curvePointList]用户指引数据集合
    ///参数三 [pointX][pointY] 当 curvePointList 为null 时起作用 可用作只有一个引导指引功能页面
    ///参数五 [isSlide] 为true 时，提示框可以移动
    ///参数六 [logs] 为true 时输出Log日志
    showBeginnerGuidance(context, curvePointList: curvePointList,pointX: 0,pointY: 0,isSlide:false ,logs: true);
  }

  void show2() {
    ///获取模拟数据
    List<CurvePoint>  curvePointList = randomTestData();
    showBeginnerGuidance(context, curvePointList: curvePointList,logs: true,isSlide: true);
  }
```

最终实现的效果就如上图中所示  [源码在这里](https://github.com/zhaolongs/flutter_guidance_plugin/blob/master/example/lib/main.dart)

#### 3、蒙版效果实现
在这里实现的蒙版效果从两方面来讲：
##### 3.1 一是
我们这里的蒙版引导层实际上是通过 Navigator push 了一个 Widget ，那么我们需要实现 push 出来的新在页面层要保持透明，那么在这里是这样实现的：

```java
  ///背景透明的跳转
  Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        ///GuideSplashPage 是引导页面具体实现
        return GuideSplashPage(curvePointList:curvePointList,pointX: pointX,pointY: pointY,textColor: tipsTextColor,isSlide:isSlide,clickCallback:clickCallback);
      }));
}
```

PageRouteBuilder 在 flutter 中用来自定义路由切换功能，在这里通过 pageBuilder 函数来构建将到 跳转的页面

对于参数  opaque ,我们可以理解为用来配置开启的页面背景是否透明，这里配置的为 false ，如果配置为 true，那么页面背景将不会透明。

在这个 PageRouteBuilder 中，我们还可以添加一个渐变动画，使用页面切换效果体验更佳

```java
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
```
这里我们添加了一个 transitionsBuilder ，它是用来控制页面效果效果的，例如这里添加了一个 FadeTransition 渐变过渡效果

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200315124221840.gif)
从上述图片效果中我们可以看到 引导蒙版层出现与消失的时候是有 透明度渐变的效果的。

##### 3.2 二是 
当新景透明后，我们需要设置一个如上述图片中的黑色蒙版效果，在这里使用的是 Container 填充整个页面，然后设置一个透明度的背景

```java
 Container(
     color: Color(0x90000000),
     ... ...
)
```

#### 4 Android 手机中返回键按钮事件的拦截

在我们的蒙版实现页面  GuideSplashPage 中，我们使用到了 组件 WillPopScope，在Flutter中通过WillPopScope来实现返回按钮拦截
```java
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
          child: ...
        ///在Android手机中，当点击后退按钮的时候，会回调此事件
        ///在这里返回 false 表示拦截事件
        onWillPop: () async {
          return Future.value(false);
        });
  }
```


##### 5 气泡提示实现
其实关于气泡提示实现我们也可以使用一张切图来实现，不过无小编喜欢搞事件，所以在这里使用了 三阶贝塞尔曲线 cubicTo 来绘制这个气泡，三阶贝塞尔曲线核心就是做好 控制点与目标点的计算，如下图小编绘制了坐标分析图

![气泡箭头坐标分析图1](https://img-blog.csdnimg.cn/20200315130220940.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3psMTg2MDM1NDM1NzI=,size_16,color_FFFFFF,t_70)

![气泡箭头坐标分析图2](https://img-blog.csdnimg.cn/2020031513033317.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3psMTg2MDM1NDM1NzI=,size_16,color_FFFFFF,t_70)

这的坐标计算代码比较多，所以小编就不放代码了，可以到源码中查看哈，三阶贝塞尔曲线 cubicTo [使用分析在这里。](https://blog.csdn.net/zl18603543572/article/details/104860632)

### 6 flutter 中 Canvas 绘制文本分析

Canvas 中并没有直接像 Android ios 中提供绘制文字的方法，在这里 我们是通过段落构建器来综合实现的绘制文本功能

```java
 ///[textWidth] 文本的宽度
  ///[textOffset] 文本绘制的开始位置 左上角
  ///[text] 绘制的文字内容
  void drawTextFunction(
      double textWidth, Offset textOffset, Canvas canvas, String text,
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
    ui.Paragraph paragraph = pb.build()..layout(pc);
    ///偏移量在这里指的是文字左上角的 位置
    canvas.drawParagraph(paragraph, textOffset);
  }
}
```

需要注意的是这里的ParagraphBuilder TextStyle 我们通过 ui. 别名来调用的，这是因为 

```java
import 'dart:ui' as ui; //这里用as取个别名，有库名冲突

import 'package:flutter/material.dart';
```

在这两个包内，存在相同名字的 ParagraphBuilder 与 TextStyle ，而我们需要使用 ui 包中的，所以在这里通过 别名调用。

#### 7 关于下一步点击事件
在这里，我们不能使用 Button 或者 InkWell 等，也不好使用，因为这里的下一步，我们是通过 Canvas 绘制出来的，Canvas 是不能绘制事件的，而且在这里，我们绘制的 下一步的按钮的位置也是不固定的
![下一步点击事件](https://img-blog.csdnimg.cn/20200315131755583.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3psMTg2MDM1NDM1NzI=,size_16,color_FFFFFF,t_70)

所以在这里，小编通过 

```java
			GestureDetector(
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
                    在这里放我们的 CustomPaint 画布绘制的内容
                  ],
                ),
              )
```
对于 onTap 点击事件来讲，我们这里进行了计算
```java

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

```
上述 使用到的 nextRect，是的个Rect,是用来记录引导层中下一步按钮的绘制位置信息的。



***
完毕，如有疑问请回复，也可以关注一下，小编最近正在搞事情 Java 、mybatis、springboot 、vue、react、Sql、android、ios 会持续记录