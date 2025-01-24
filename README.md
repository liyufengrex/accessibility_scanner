# accessibility_scanner

###### 该插件适用于安卓平台，基于 AccessibilityService「无障碍服务」 实现的扫码辅助功能。

>1.  可避免大部分输入法造成的扫码乱码现象
>2.  可避免焦点触发引起的键盘弹起

PS： 需要到系统设置->无障碍->服务 开启当前服务（下文说明）

### 使用方式

+ 添加依赖

在pubspec.yaml文件中进行引用：
```
dependencies:
  accessibility_scanner: ^1.0.0
```
+ 在应用根页面`initState`内添加判断开启扫码服务
```dart
  @override
void initState() {
  super.initState();
  // 检查扫码无障碍服务是否开启
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    checkAccessibilityScanner();
  });
```
```dart
  // 检查扫码无障碍服务是否开启
Future<void> checkAccessibilityScanner() async {
  bool isAccessibilityScannerEnabled = await AccessibilityScannerProvider.isAccessibilitySettingsOn();
  if (!isAccessibilityScannerEnabled) {
    // 未开启无障碍服务，引导用户去设置中打开
    openAccessibilitySettings();
  }
}
```
```dart
  // 弹窗开启扫码无障碍服务
void openAccessibilitySettings() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: const Text('本应用支持扫码服务，如需开启请点击“去设置”并找到您的应用，设置状态为启用，并依次点击返回，回到应用'),
        actions: [
          TextButton(
            onPressed: () async {
              AccessibilityScannerProvider.openAccessibilitySetting();
              Navigator.pop(context);
            },
            child: const Text('去设置'),
          ),
        ],
      );
    },
  );
}
```
+ 在任意页面可获取到扫码枪结果
```dart
    // 开始监听扫码服务
AccessibilityScannerProvider.listenScannerData((data) {
// 获取到扫码结果
setState(() {
scanData = data;
});
}, (error) {
// 暂无处理
});
```

### 提供API
```dart
import 'package:accessibility_scanner/accessibility_scanner.dart';

// 1. 判断无障碍扫码服务是否开启
bool isAccessibilityScannerEnabled = await AccessibilityScannerProvider.isAccessibilitySettingsOn()

// 2. 打开无障碍服务设置界面
AccessibilityScannerProvider.openAccessibilitySetting()

// 3. 实时获取扫码结果
AccessibilityScannerProvider.listenScannerData(
(data) {
// 获取到扫码结果
},
(error) {
// 错误信息
},
);
```
### 如何设置无障碍服务页面提示信息
```dart
在自己项目的 android -> values -> string.xml 添加配置

<string name="accessibility_service_description">请依次操作“返回”按钮，返回应用正常启用后，扫码器即可正常识别</string>
```
### 详细使用方式可查看 example ：
![scanner_demo_1.gif](https://upload-images.jianshu.io/upload_images/25776880-0328e5e6c33d5b3e.gif?imageMogr2/auto-orient/strip)
