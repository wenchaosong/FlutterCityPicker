import 'package:flutter/material.dart';

/// 自定义高度的容器
class CustomLayoutDelegate extends SingleChildLayoutDelegate {
  /// 动画的完成度，用来获取位置
  final double? progress;

  /// 高度
  final double? height;

  CustomLayoutDelegate({
    this.progress,
    this.height,
  });

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
        minHeight: 0,
        maxHeight: height!,
      );

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0, size.height - childSize.height * progress!);
  }

  @override
  bool shouldRelayout(CustomLayoutDelegate oldDelegate) => true;
}
