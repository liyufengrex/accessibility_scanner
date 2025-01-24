
import 'package:flutter/services.dart';

import 'accessibility_scanner_platform_interface.dart';

abstract class AccessibilityScannerProvider {

  static const EventChannel eventChannel = EventChannel("accessibility_scanner_event");

  //判断无障碍服务是否开启
  static Future<bool> isAccessibilitySettingsOn() {
    return AccessibilityScannerPlatform.instance.isAccessibilitySettingsOn();
  }

  // 打开无障碍服务设置界面
  static Future<void> openAccessibilitySetting() {
    return AccessibilityScannerPlatform.instance.openAccessibilitySetting();
  }

  static void listenScannerData(onEvent, onError) {
    eventChannel.receiveBroadcastStream().listen(onEvent, onError: onError);
  }
}
