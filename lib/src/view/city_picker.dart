import 'package:flutter/material.dart';
import '../../src/listener/item_listener.dart';
import '../../src/model/tab.dart';
import '../../src/view/item_widget.dart';
import '../../src/listener/picker_listener.dart';
import '../../src/model/city.dart';

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

  /// item 高度
  final double itemExtent;

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
    this.itemExtent,
    this.titleWidget,
    this.closeWidget,
    this.tabHeight,
    this.showTabIndicator,
    this.tabIndicatorColor,
    this.tabIndicatorHeight,
    this.labelTextSize,
    this.selectedLabelColor,
    this.unselectedLabelColor,
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

  // 三级联动选择的position
  var _positions = [-1, -1, -1];

  List<TabTitle> _myTabs = [
    TabTitle(index: 0, title: "请选择", name: "", code: ""),
  ];

  // 省列表
  List<City> _provinceList = [];

  // 市列表
  List<City> _cityList = [];

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
  void onItemClick(int tabIndex, int position, List<City> data) {
    switch (tabIndex) {
      case 0:
        if (mounted) {
          setState(() {
            _provinceList = data;
            _positions = [position, -1, -1];
            _myTabs = [
              TabTitle(
                  index: 0, title: data[position].name, name: "", code: ""),
              TabTitle(
                  index: 1,
                  title: "请选择",
                  name: data[position].name,
                  code: data[position].code),
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
            _cityList = data;
            _positions = [_positions[0], position, -1];

            _myTabs = [
              TabTitle(
                  index: 0,
                  title: _provinceList[_positions[0]].name,
                  name: "",
                  code: ""),
              TabTitle(
                  index: 1, title: data[position].name, name: "", code: ""),
              TabTitle(
                  index: 2,
                  title: "请选择",
                  name: data[position].name,
                  code: data[position].code),
            ];
            _tabController = TabController(vsync: this, length: _myTabs.length);
          });
        }
        _tabController.animateTo(2);
        _tabController.index = 2;
        break;
      case 2:
        _positions = [_positions[0], _positions[1], position];

        if (_cityPickerListener != null) {
          _cityPickerListener.onFinish(
            _provinceList[_positions[0]].code,
            _provinceList[_positions[0]].name,
            _cityList[_positions[1]].code,
            _cityList[_positions[1]].name,
            data[position].code,
            data[position].name,
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
          itemExtent: widget.itemExtent,
          paddingLeft: widget.paddingLeft,
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
