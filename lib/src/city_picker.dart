import 'package:flutter/material.dart';

import 'listener/picker_listener.dart';
import 'view/city_picker.dart';
import 'view/popup_route.dart';

/// 外部调用
class CityPicker {
  /// 展示
  static void show({
    @required BuildContext context,
    // 主题颜色
    ThemeData theme,
    // 底部弹出框动画时间
    int duration = 200,
    // 背景透明度
    double opacity = 0.5,
    // 点击外部是否消失
    bool dismissible = true,
    // 高度
    double height = 400.0,
    // 标题高度
    double titleHeight,
    // 顶部圆角
    double corner,
    // 距离左边的间距
    double paddingLeft,
    // 标题组件
    Widget titleWidget,
    // 关闭图标组件
    Widget closeWidget,
    // tab 高度
    double tabHeight,
    // 是否显示指示器
    bool showTabIndicator = true,
    // 指示器颜色
    Color tabIndicatorColor,
    // 指示器高度
    double tabIndicatorHeight,
    // tab 字体大小
    double labelTextSize,
    // tab 选中的字体颜色
    Color selectedLabelColor,
    // tab 未选中的字体颜色
    Color unselectedLabelColor,
    // item 头部高度
    double itemHeadHeight,
    // item 头部背景颜色
    Color itemHeadBackgroundColor,
    // item 头部分割线颜色
    Color itemHeadLineColor,
    // item 头部分割线高度
    double itemHeadLineHeight,
    // item 头部文字样式
    TextStyle itemHeadTextStyle,
    // item 高度
    double itemHeight,
    // 列表选中的图标组件
    Widget itemSelectedIconWidget,
    // 列表选中的文字样式
    TextStyle itemSelectedTextStyle,
    // 列表未选中的文字样式
    TextStyle itemUnSelectedTextStyle,
    // 地址选择器监听事件
    @required CityPickerListener cityPickerListener,
  }) {
    Navigator.of(context, rootNavigator: true).push(
      CustomPopupRoute(
          theme: theme ?? Theme.of(context),
          duration: duration,
          opacity: opacity,
          dismissible: dismissible,
          child: CityPickerWidget(
            height: height,
            titleHeight: titleHeight,
            corner: corner,
            paddingLeft: paddingLeft,
            titleWidget: titleWidget,
            closeWidget: closeWidget,
            tabHeight: tabHeight,
            showTabIndicator: showTabIndicator,
            tabIndicatorColor: tabIndicatorColor,
            tabIndicatorHeight: tabIndicatorHeight,
            labelTextSize: labelTextSize,
            selectedLabelColor: selectedLabelColor,
            unselectedLabelColor: unselectedLabelColor,
            itemHeadHeight: itemHeadHeight,
            itemHeadBackgroundColor: itemHeadBackgroundColor,
            itemHeadLineColor: itemHeadLineColor,
            itemHeadLineHeight: itemHeadLineHeight,
            itemHeadTextStyle: itemHeadTextStyle,
            itemHeight: itemHeight,
            itemSelectedIconWidget: itemSelectedIconWidget,
            itemSelectedTextStyle: itemSelectedTextStyle,
            itemUnSelectedTextStyle: itemUnSelectedTextStyle,
            cityPickerListener: cityPickerListener,
          )),
    );
  }
}
