import 'package:flutter/material.dart';

import 'listener/picker_listener.dart';
import 'view/city_picker.dart';
import 'view/popup_route.dart';

/// 外部调用
class CityPicker {
  /// 展示
  static void show({
    @required BuildContext context,
    ThemeData theme,
    int duration = 200,
    double opacity = 0.5,
    bool dismissible = true,
    double height = 400.0,
    double titleHeight,
    double corner,
    double paddingLeft,
    double itemExtent,
    Widget titleWidget,
    Widget closeWidget,
    double tabHeight,
    bool showTabIndicator = true,
    Color tabIndicatorColor,
    double tabIndicatorHeight,
    double labelTextSize,
    Color selectedLabelColor,
    Color unselectedLabelColor,
    Widget itemSelectedIconWidget,
    TextStyle itemSelectedTextStyle,
    TextStyle itemUnSelectedTextStyle,
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
            itemExtent: itemExtent,
            titleWidget: titleWidget,
            closeWidget: closeWidget,
            showTabIndicator: showTabIndicator,
            tabIndicatorColor: tabIndicatorColor,
            tabIndicatorHeight: tabIndicatorHeight,
            labelTextSize: labelTextSize,
            selectedLabelColor: selectedLabelColor,
            unselectedLabelColor: unselectedLabelColor,
            itemSelectedIconWidget: itemSelectedIconWidget,
            itemSelectedTextStyle: itemSelectedTextStyle,
            itemUnSelectedTextStyle: itemUnSelectedTextStyle,
            cityPickerListener: cityPickerListener,
          )),
    );
  }
}
