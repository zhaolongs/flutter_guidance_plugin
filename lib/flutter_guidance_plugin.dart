import 'dart:async';

import 'package:flutter/services.dart';

export 'package:flutter_guidance_plugin/src/exp_guilde_function.dart';
export 'package:flutter_guidance_plugin/src/curve_painter.dart';
class FlutterGuidancePlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_guidance_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
