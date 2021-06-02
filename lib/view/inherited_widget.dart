import 'package:flutter/material.dart';

import 'popup_route.dart';

/// 数据共享传递组件
class CustomInheritedWidget extends InheritedWidget {
  /// 组件的实例
  final CustomPopupRoute router;

  CustomInheritedWidget({Key? key, required this.router, required Widget child})
      : super(key: key, child: child);

  static CustomInheritedWidget? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(CustomInheritedWidget oldWidget) {
    return oldWidget.router != router;
  }
}
