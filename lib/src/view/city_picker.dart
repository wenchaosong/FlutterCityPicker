import 'package:flutter/material.dart';

import '../../src/listener/item_listener.dart';
import '../../src/listener/picker_listener.dart';
import '../../src/model/tab.dart';
import '../../src/view/item_widget.dart';
import 'inherited_widget.dart';
import 'layout_delegate.dart';

/// 省市区选择器
///
/// 从服务器获取数据
///
class CityPickerWidget extends StatefulWidget {
  /// 组件高度
  final double height;

  /// 标题高度
  final double titleHeight;

  /// 顶部圆角
  final double corner;

  /// 左边间距
  final double paddingLeft;

  /// 标题样式
  final Widget titleWidget;

  /// 关闭图标组件
  final Widget closeWidget;

  /// tab 高度
  final double tabHeight;

  /// 是否显示 indicator
  final bool showTabIndicator;

  /// indicator 颜色
  final Color tabIndicatorColor;

  /// indicator 高度
  final double tabIndicatorHeight;

  /// label 文字大小
  final double labelTextSize;

  /// 选中 label 颜色
  final Color selectedLabelColor;

  /// 未选中 label 颜色
  final Color unselectedLabelColor;

  /// item 头部高度
  final double itemHeadHeight;

  /// item 头部背景颜色
  final Color itemHeadBackgroundColor;

  /// item 头部分割线颜色
  final Color itemHeadLineColor;

  /// item 头部分割线高度
  final double itemHeadLineHeight;

  /// item 头部文字样式
  final TextStyle itemHeadTextStyle;

  /// item 高度
  final double itemHeight;

  /// 选中城市的图标组件
  final Widget itemSelectedIconWidget;

  /// 选中城市文字样式
  final TextStyle itemSelectedTextStyle;

  /// 未选中城市文字样式
  final TextStyle itemUnSelectedTextStyle;

  /// 监听事件
  final CityPickerListener cityPickerListener;

  CityPickerWidget({
    this.height,
    this.titleHeight,
    this.corner,
    this.paddingLeft,
    this.titleWidget,
    this.closeWidget,
    this.tabHeight,
    this.showTabIndicator,
    this.tabIndicatorColor,
    this.tabIndicatorHeight,
    this.labelTextSize,
    this.selectedLabelColor,
    this.unselectedLabelColor,
    this.itemHeadHeight,
    this.itemHeadBackgroundColor,
    this.itemHeadLineColor,
    this.itemHeadLineHeight,
    this.itemHeadTextStyle,
    this.itemHeight,
    this.itemSelectedIconWidget,
    this.itemSelectedTextStyle,
    this.itemUnSelectedTextStyle,
    @required this.cityPickerListener,
  });

  @override
  State<StatefulWidget> createState() => CityPickerState();
}

class CityPickerState extends State<CityPickerWidget>
    with TickerProviderStateMixin
    implements ItemClickListener {
  CityPickerListener _cityPickerListener;

  TabController _tabController;

  List<TabTitle> _myTabs = [
    TabTitle(index: 0, title: "请选择", name: "", code: ""),
  ];

  // 省级名称
  String _provinceName = "";

  // 省级代码
  String _provinceCode = "";

  // 市级名称
  String _cityName = "";

  // 市级代码
  String _cityCode = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _myTabs.length);
    _cityPickerListener = widget.cityPickerListener;
  }

  @override
  void dispose() {
    if (mounted) {
      _tabController?.dispose();
    }
    super.dispose();
  }

  @override
  void onItemClick(int tabIndex, String name, String code) {
    switch (tabIndex) {
      case 0:
        if (mounted) {
          setState(() {
            _provinceName = name;
            _provinceCode = code;
            _myTabs = [
              TabTitle(index: 0, title: _provinceName, name: "", code: ""),
              TabTitle(
                  index: 1,
                  title: "请选择",
                  name: _provinceName,
                  code: _provinceCode),
            ];
            _tabController = TabController(vsync: this, length: _myTabs.length);
          });
        }
        _tabController.animateTo(1);
        _tabController.index = 1;
        break;
      case 1:
        if (mounted) {
          setState(() {
            _cityName = name;
            _cityCode = code;

            _myTabs = [
              TabTitle(index: 0, title: _provinceName, name: "", code: ""),
              TabTitle(index: 1, title: _cityName, name: "", code: ""),
              TabTitle(
                  index: 2, title: "请选择", name: _cityName, code: _cityCode),
            ];
            _tabController = TabController(vsync: this, length: _myTabs.length);
          });
        }
        _tabController.animateTo(2);
        _tabController.index = 2;
        break;
      case 2:
        if (_cityPickerListener != null) {
          _cityPickerListener.onFinish(
            _provinceCode,
            _provinceName,
            _cityCode,
            _cityName,
            code,
            name,
          );
        }
        Navigator.pop(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final route = CustomInheritedWidget.of(context).router;
    return AnimatedBuilder(
      animation: route.animation,
      builder: (BuildContext context, Widget child) => CustomSingleChildLayout(
          delegate: CustomLayoutDelegate(
              progress: route.animation.value, height: widget.height),
          child: GestureDetector(
            child: Material(
                color: Colors.transparent,
                child: Container(
                    width: double.infinity,
                    child: Column(children: <Widget>[
                      _topTextWidget(),
                      Expanded(
                        child: Column(children: <Widget>[
                          _middleTabWidget(),
                          Expanded(child: _bottomListWidget())
                        ]),
                      )
                    ]))),
          )),
    );
  }

  /// 头部文字组件
  Widget _topTextWidget() {
    return Container(
      height: widget.titleHeight ?? 50,
      decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.corner ?? 20),
              topRight: Radius.circular(widget.corner ?? 20))),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            widget.titleWidget ??
                Container(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    '请选择所在地区',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            InkWell(
                onTap: () => {Navigator.pop(context)},
                child: Container(
                  width: widget.titleHeight ?? 50,
                  height: double.infinity,
                  child: widget.closeWidget ?? Icon(Icons.close, size: 26),
                )),
          ]),
    );
  }

  /// 中间 tab 组件
  Widget _middleTabWidget() {
    return Container(
      width: double.infinity,
      height: widget.tabHeight ?? 40,
      color: Theme.of(context).dialogBackgroundColor,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: EdgeInsets.only(left: widget.paddingLeft ?? 15),
        indicator: widget.showTabIndicator
            ? UnderlineTabIndicator(
                insets: EdgeInsets.only(left: widget.paddingLeft ?? 15),
                borderSide: BorderSide(
                    width: widget.tabIndicatorHeight ?? 3,
                    color: widget.tabIndicatorColor ??
                        Theme.of(context).primaryColor),
              )
            : BoxDecoration(),
        indicatorColor:
            widget.tabIndicatorColor ?? Theme.of(context).primaryColor,
        unselectedLabelColor: widget.unselectedLabelColor ?? Colors.black54,
        labelColor: widget.selectedLabelColor ?? Theme.of(context).primaryColor,
        tabs: _myTabs.map((data) {
          return Text(data.title,
              style: TextStyle(fontSize: widget.labelTextSize ?? 15));
        }).toList(),
      ),
    );
  }

  /// 底部城市列表组件
  Widget _bottomListWidget() {
    return TabBarView(
      controller: _tabController,
      children: _myTabs.map((tab) {
        return ItemWidget(
          index: tab.index,
          code: tab.code,
          name: tab.name,
          paddingLeft: widget.paddingLeft,
          itemHeadHeight: widget.itemHeadHeight,
          itemHeadBackgroundColor: widget.itemHeadBackgroundColor,
          itemHeadLineColor: widget.itemHeadLineColor,
          itemHeadLineHeight: widget.itemHeadLineHeight,
          itemHeadTextStyle: widget.itemHeadTextStyle,
          itemHeight: widget.itemHeight,
          itemSelectedIconWidget: widget.itemSelectedIconWidget,
          itemSelectedTextStyle: widget.itemSelectedTextStyle,
          itemUnSelectedTextStyle: widget.itemUnSelectedTextStyle,
          cityPickerListener: widget.cityPickerListener,
          itemClickListener: this,
        );
      }).toList(),
    );
  }
}
