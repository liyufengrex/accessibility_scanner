import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'accessibility_scanner_method_channel.dart';

abstract class AccessibilityScannerPlatform extends PlatformInterface {
  /// Constructs a AccessibilityScannerPlatform.
  AccessibilityScannerPlatform() : super(token: _token);

  static final Object _token = Object();

  static AccessibilityScannerPlatform _instance = MethodChannelAccessibilityScanner();

  static AccessibilityScannerPlatform get instance => _instance;

  static set instance(AccessibilityScannerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> isAccessibilitySettingsOn() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> openAccessibilitySetting() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
