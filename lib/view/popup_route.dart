import 'package:flutter/material.dart';

import 'inherited_widget.dart';

/// 弹窗组件，整体框架组件
class CustomPopupRoute<T> extends PopupRoute<T> {
  /// 主题
  final ThemeData? theme;

  /// 弹窗动画时间
  final int? duration;

  /// 是否点击外部取消
  final bool? dismissible;

  /// 背景透明度
  final double? opacity;

  /// 子组件
  final Widget? child;

  CustomPopupRoute({
    this.theme,
    this.duration,
    this.dismissible,
    this.opacity,
    this.child,
  });

  @override
  Duration get transitionDuration => Duration(milliseconds: duration!);

  @override
  Color get barrierColor => Color.fromRGBO(0, 0, 0, opacity!);

  @override
  bool get barrierDismissible => dismissible!;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget bottomSheet = MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: CustomInheritedWidget(router: this, child: child!),
    );
    if (theme != null) {
      bottomSheet = Theme(data: theme!, child: bottomSheet);
    }
    return bottomSheet;
  }
}
