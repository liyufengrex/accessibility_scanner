import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'accessibility_scanner_platform_interface.dart';

/// An implementation of [AccessibilityScannerPlatform] that uses method channels.
class MethodChannelAccessibilityScanner extends AccessibilityScannerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('accessibility_scanner_method');

  @override
  Future<bool> isAccessibilitySettingsOn() async {
    final isAccessibilityOPen =
        await methodChannel.invokeMethod<bool>('isAccessibilityOPen');
    return isAccessibilityOPen ?? false;
  }

  @override
  Future<void> openAccessibilitySetting() async {
    methodChannel.invokeMethod<String>('openAccessibilitySetting');
  }
}
