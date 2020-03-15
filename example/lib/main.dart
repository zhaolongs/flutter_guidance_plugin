import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_guidance_plugin/flutter_guidance_plugin.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(home: MyApp(),));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _randomBit(int len) {
    String scopeF = "123456789"; //首位
    String scopeC = "0123456789"; //中间
    String result = "";
    for (int i = 0; i < len; i++) {
      if (i == 1) {
        result = scopeF[Random().nextInt(scopeF.length)];
      } else {
        result = result + scopeC[Random().nextInt(scopeC.length)];
      }
    }
    return result;
  }

  String result = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(milliseconds: 5),(){
      show1();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新手引导蒙版"),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text("再次显示 引导蒙版"),
                  onPressed: () {
                    show1();
                  },
                ),
                FlatButton(
                  child: Text("显示 可滑动的引导蒙版"),
                  onPressed: () {
                    show2();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

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
}
