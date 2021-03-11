import 'package:flutter/material.dart';
import 'picker_popup_route.dart';

class InheritRouteWidget extends InheritedWidget {
  final CityPickerRoute router;

  InheritRouteWidget({Key key, @required this.router, Widget child})
      : super(key: key, child: child);

  static InheritRouteWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(InheritRouteWidget oldWidget) {
    return oldWidget.router != router;
  }
}
