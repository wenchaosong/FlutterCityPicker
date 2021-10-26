import 'package:flutter/material.dart';

import '../city_picker.dart';
import '../listener/item_listener.dart';
import '../listener/picker_listener.dart';
import '../model/tab.dart';
import '../view/item_widget.dart';
import 'inherited_widget.dart';
import 'layout_delegate.dart';

/// 省市区选择器
///
/// 从服务器获取数据
///
class CityPickerWidget extends StatefulWidget {
  /// 组件高度
  final double? height;

  /// 标题高度
  final double? titleHeight;

  /// 顶部圆角
  final double? corner;

  /// 左边间距
  final double? paddingLeft;

  /// 标题样式
  final Widget? titleWidget;

  /// 关闭图标组件
  final Widget? closeWidget;

  /// tab 高度
  final double? tabHeight;

  /// 是否显示 indicator
  final bool? showTabIndicator;

  /// indicator 颜色
  final Color? tabIndicatorColor;

  /// indicator 高度
  final double? tabIndicatorHeight;

  /// label 文字大小
  final double? labelTextSize;

  /// 选中 label 颜色
  final Color? selectedLabelColor;

  /// 未选中 label 颜色
  final Color? unselectedLabelColor;

  /// item 头部高度
  final double? itemHeadHeight;

  /// item 头部背景颜色
  final Color? itemHeadBackgroundColor;

  /// item 头部分割线颜色
  final Color? itemHeadLineColor;

  /// item 头部分割线高度
  final double? itemHeadLineHeight;

  /// item 头部文字样式
  final TextStyle? itemHeadTextStyle;

  /// item 高度
  final double? itemHeight;

  /// 索引组件宽度
  final double? indexBarWidth;

  /// 索引组件 item 高度
  final double? indexBarItemHeight;

  /// 索引组件背景颜色
  final Color? indexBarBackgroundColor;

  /// 索引组件文字样式
  final TextStyle? indexBarTextStyle;

  /// 选中城市的图标组件
  final Widget? itemSelectedIconWidget;

  /// 选中城市文字样式
  final TextStyle? itemSelectedTextStyle;

  /// 未选中城市文字样式
  final TextStyle? itemUnSelectedTextStyle;

  /// 监听事件
  final CityPickerListener? cityPickerListener;

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
    this.indexBarWidth,
    this.indexBarItemHeight,
    this.indexBarBackgroundColor,
    this.indexBarTextStyle,
    this.itemSelectedIconWidget,
    this.itemSelectedTextStyle,
    this.itemUnSelectedTextStyle,
    required this.cityPickerListener,
  });

  @override
  State<StatefulWidget> createState() => CityPickerState();
}

class CityPickerState extends State<CityPickerWidget>
    with TickerProviderStateMixin
    implements ItemClickListener {
  CityPickerListener? _cityPickerListener;

  TabController? _tabController;
  PageController? _pageController;

  List<TabTitle> _myTabs = [
    TabTitle(index: 0, title: "请选择", name: "", code: ""),
  ];

  // 省级名称
  String? _provinceName = "";

  // 省级代码
  String? _provinceCode = "";

  // 市级名称
  String? _cityName = "";

  // 市级代码
  String? _cityCode = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _myTabs.length);
    _pageController = PageController();

    _cityPickerListener = widget.cityPickerListener;
  }

  @override
  void dispose() {
    if (mounted) {
      _tabController?.dispose();
      _pageController?.dispose();
    }
    super.dispose();
  }

  @override
  void onItemClick(int? tabIndex, String? name, String? code) {
    switch (tabIndex) {
      case 0:
        _provinceName = name;
        _provinceCode = code;
        _myTabs = [
          TabTitle(index: 0, title: _provinceName, name: "", code: ""),
          TabTitle(
              index: 1, title: "请选择", name: _provinceName, code: _provinceCode),
        ];
        _tabController = TabController(vsync: this, length: _myTabs.length);
        _pageController!.jumpToPage(1);
        _tabController!.animateTo(1);
        if (mounted) {
          setState(() {});
        }
        break;
      case 1:
        _cityName = name;
        _cityCode = code;
        _myTabs = [
          TabTitle(index: 0, title: _provinceName, name: "", code: ""),
          TabTitle(index: 1, title: _cityName, name: "", code: ""),
          TabTitle(index: 2, title: "请选择", name: _cityName, code: _cityCode),
        ];
        _tabController =
            TabController(vsync: this, length: _myTabs.length, initialIndex: 1);
        _pageController!.jumpToPage(2);
        _tabController!.animateTo(2);
        if (mounted) {
          setState(() {});
        }
        break;
      case 2:
        if (_cityPickerListener != null) {
          _cityPickerListener!.onFinish(
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
    final route = CustomInheritedWidget.of(context)!.router;
    return AnimatedBuilder(
      animation: route.animation!,
      builder: (BuildContext context, Widget? child) => CustomSingleChildLayout(
          delegate: CustomLayoutDelegate(
              progress: route.animation!.value, height: widget.height),
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
      height: widget.titleHeight,
      decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.corner!),
              topRight: Radius.circular(widget.corner!))),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            widget.titleWidget ??
                Container(
                  padding: EdgeInsets.only(left: widget.paddingLeft!),
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
                  width: widget.titleHeight,
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
      height: widget.tabHeight,
      color: Theme.of(context).dialogBackgroundColor,
      child: TabBar(
        controller: _tabController,
        onTap: (index) {
          _pageController!.jumpToPage(index);
        },
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: EdgeInsets.only(left: widget.paddingLeft!),
        indicator: widget.showTabIndicator!
            ? UnderlineTabIndicator(
                insets: EdgeInsets.only(left: widget.paddingLeft!),
                borderSide: BorderSide(
                    width: widget.tabIndicatorHeight!,
                    color: widget.tabIndicatorColor ??
                        Theme.of(context).primaryColor),
              )
            : BoxDecoration(),
        indicatorColor:
            widget.tabIndicatorColor ?? Theme.of(context).primaryColor,
        unselectedLabelColor: widget.unselectedLabelColor ?? Colors.black54,
        labelColor: widget.selectedLabelColor ?? Theme.of(context).primaryColor,
        tabs: _myTabs.map((data) {
          return Text(data.title!,
              style: TextStyle(fontSize: widget.labelTextSize));
        }).toList(),
      ),
    );
  }

  /// 底部城市列表组件
  Widget _bottomListWidget() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        _tabController!.animateTo(index);
      },
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
          indexBarWidth: widget.indexBarWidth,
          indexBarItemHeight: widget.indexBarItemHeight,
          indexBarBackgroundColor: widget.indexBarBackgroundColor,
          indexBarTextStyle: widget.indexBarTextStyle,
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
