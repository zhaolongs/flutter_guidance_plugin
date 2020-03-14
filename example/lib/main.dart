import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_guidance_plugin/flutter_guidance_plugin.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {





  _randomBit(int len) {
    String scopeF = "123456789";//首位
    String scopeC = "0123456789";//中间
    String result = "";
    for (int i = 0; i < len; i++) {
      if (i == 1) {
        result = scopeF[Random().nextInt(scopeF.length)];
      } else {
        result = result + scopeC[Random().nextInt(scopeC.length)];
      }
    }
    return result;
  }String result = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(milliseconds: 2),(){
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


  void show1(){
    List<CurvePoint> curvePointList =[];

    for(int i=0;i<23;i++){
      CurvePoint curvePoint = CurvePoint(0,0);
      curvePoint.x=double.parse("0.${_randomBit(3)}");
      curvePoint.y=double.parse("0.${_randomBit(3)}");
      curvePoint.tipsMessage="这是引导消息内容$i";
      curvePointList.add(curvePoint);
    }
    showBeginnerGuidance(context,curvePointList:curvePointList);
  }
  void show2(){
    List<CurvePoint> curvePointList =[];

    for(int i=0;i<1;i++){
      CurvePoint curvePoint = CurvePoint(0,0);
      curvePoint.x=double.parse("0.${_randomBit(3)}");
      curvePoint.y=double.parse("0.${_randomBit(3)}");
      curvePoint.tipsMessage="这是引导消息内容$i";
      curvePointList.add(curvePoint);
    }
    showBeginnerGuidance(context,curvePointList:curvePointList);
  }

}
