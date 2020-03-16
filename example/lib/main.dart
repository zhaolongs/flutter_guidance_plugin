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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新手引导蒙版"),
      ),
      body: Stack(children:<Widget>[
      Column(children: <Widget>[
        FlatButton(
          key:_key1,
          child: Text("再次显示 引导蒙版"),
          onPressed: () {
            show1();
          },
        ),
        FlatButton(
          key:_key2,
          child: Text("显示 可滑动的引导蒙版"),
          onPressed: () {
            show2();
          },
        ),

        SizedBox(height: 33,),
        FlatButton(
          key:_key3,
          child: Text("显示 可滑动的引导蒙版2"),
          onPressed: () {
            show3();
          },
        ),

      ],),
        Align(alignment: Alignment.bottomCenter,child: Text("测试widghet",key:_key4),),
        Align(alignment: Alignment.bottomRight,child: Text("测试widghet",key:_key5),),
        Align(alignment: Alignment.bottomLeft,child: Text("测试widghet",key:_key6),),
        Align(alignment: Alignment(0,0.3),child: Text("测试widghet",key:_key7),),
        Align(alignment: Alignment(-1,0.3),child: Text("测试widghet",key:_key8),),
        Align(alignment: Alignment(1,0.4),child: Text("测试widghet",key:_key9),),
      ])
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


  ///这里是不可滑动的模拟数据
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

  ///这里是可滑动的模拟数据
  void show2() {
    ///获取模拟数据
    List<CurvePoint>  curvePointList = randomTestData();
    showBeginnerGuidance(context, curvePointList: curvePointList,logs: true,isSlide: true);
  }
  GlobalKey _key1 = GlobalKey();
  GlobalKey _key2 = GlobalKey();
  GlobalKey _key3 = GlobalKey();
  GlobalKey _key4 = GlobalKey();
  GlobalKey _key5 = GlobalKey();
  GlobalKey _key6 = GlobalKey();
  GlobalKey _key7 = GlobalKey();
  GlobalKey _key8 = GlobalKey();
  GlobalKey _key9 = GlobalKey();
  ///这里是根据KEY 自动计算位置信息的
  void show3(){
    List<GlobalKeyPoint>  globalKeyPointList =[];
    globalKeyPointList.add(GlobalKeyPoint(_key1,tipsMessage: "点击这里可显示蒙版引导效果哈"));
    globalKeyPointList.add(GlobalKeyPoint(_key2,tipsMessage: "点击这里可 再次显示 引导蒙版"));
    globalKeyPointList.add(GlobalKeyPoint(_key3,tipsMessage: "点击这里可 再次显示 引导蒙版 这里是自动计算坐标的"));
//
    globalKeyPointList.add(GlobalKeyPoint(_key4,tipsMessage: "测试widget"));
    globalKeyPointList.add(GlobalKeyPoint(_key5,tipsMessage: "测试widget"));
    globalKeyPointList.add(GlobalKeyPoint(_key6,tipsMessage: "测试widget"));
//
    globalKeyPointList.add(GlobalKeyPoint(_key7,tipsMessage: "测试widget"));
    globalKeyPointList.add(GlobalKeyPoint(_key8,tipsMessage: "测试widget"));
    globalKeyPointList.add(GlobalKeyPoint(_key9,tipsMessage: "测试widget"));

    showBeginnerGuidance(context, globalKeyPointList:globalKeyPointList ,logs: true,isSlide: true);
  }
}
