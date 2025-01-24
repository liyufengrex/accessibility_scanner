import 'package:flutter/material.dart';
import 'dart:async';
import 'package:accessibility_scanner/accessibility_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'accessibility_scanner_demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('无障碍服务扫码测试'),
        ),
        body: const TestScannerWidget(),
      ),
    );
  }
}

class TestScannerWidget extends StatefulWidget {
  const TestScannerWidget({super.key});

  @override
  State<TestScannerWidget> createState() => _TestScannerWidgetState();
}

class _TestScannerWidgetState extends State<TestScannerWidget> {
  String? scanData;

  @override
  void initState() {
    super.initState();
    // 检查扫码无障碍服务是否开启
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkAccessibilityScanner();
    });
    // 开始监听扫码服务
    AccessibilityScannerProvider.listenScannerData(
      (data) {
        // 获取到扫码结果
        setState(() {
          scanData = data;
        });
      },
      (error) {
        // 暂无处理
      },
    );
  }

  // 检查扫码无障碍服务是否开启
  Future<void> checkAccessibilityScanner() async {
    bool isAccessibilityScannerEnabled = await AccessibilityScannerProvider.isAccessibilitySettingsOn();
    if (!isAccessibilityScannerEnabled) {
      // 未开启无障碍服务，引导用户去设置中打开
      openAccessibilitySettings();
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('扫码结果：${scanData ?? ''}'),
    );
  }
}
