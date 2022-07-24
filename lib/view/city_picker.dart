import 'package:flutter/material.dart';
import 'package:flutter_city_picker/model/address.dart';

import '../city_picker.dart';
import '../listener/item_listener.dart';
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

  /// 是否启用街道
  final bool? enableStreet;

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

  /// 初始值
  final Address? initialAddress;

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
    this.enableStreet,
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
    this.initialAddress,
    required this.cityPickerListener,
  });

  @override
  State<StatefulWidget> createState() => CityPickerState();
}

class CityPickerState extends State<CityPickerWidget>
    with TickerProviderStateMixin
    implements ItemClickListener {
  TabController? _tabController;
  PageController? _pageController;

  bool _hasInitialValue = false;

  List<TabTitle> _myTabs = [];

  // 省级名称
  String? _provinceName;

  // 省级代码
  String? _provinceCode;

  // 市级名称
  String? _cityName;

  // 市级代码
  String? _cityCode;

  // 区级名称
  String? _districtName;

  // 区级代码
  String? _districtCode;

  // 街道名称
  String? _streetName;

  // 街道代码
  String? _streetCode;

  @override
  void initState() {
    super.initState();
    _hasInitialValue = widget.initialAddress != null;
    _myTabs = _hasInitialValue
        ? [
            TabTitle(
                index: 0,
                title: widget.initialAddress!.province?.name,
                name: '',
                code: ''),
            TabTitle(
              index: 1,
              title: widget.initialAddress!.city?.name,
              name: widget.initialAddress!.province?.name,
              code: widget.initialAddress!.province?.code,
            ),
            TabTitle(
              index: 2,
              title: widget.initialAddress!.district?.name,
              name: widget.initialAddress!.city?.name,
              code: widget.initialAddress!.city?.code,
            ),
            if (widget.enableStreet == true)
              TabTitle(
                index: 3,
                title: widget.initialAddress!.street == null
                    ? '请选择'
                    : widget.initialAddress!.street!.name,
                name: widget.initialAddress!.district?.name,
                code: widget.initialAddress!.district?.code,
              ),
          ]
        : [
            TabTitle(index: 0, title: '请选择', name: '', code: ''),
          ];
    _initValue();
  }

  @override
  void dispose() {
    if (mounted) {
      _tabController?.dispose();
      _pageController?.dispose();
    }
    super.dispose();
  }

  void _initValue() {
    if (_hasInitialValue) {
      final address = widget.initialAddress!;
      _provinceName = address.province!.name!;
      _provinceCode = address.province!.code!;
      _cityName = address.city!.name!;
      _cityCode = address.city!.code!;
      _districtName = address.district!.name!;
      _districtCode = address.district!.code!;
      if (widget.enableStreet == true) {
        _streetName = address.street?.name;
        _streetCode = address.street?.code;
        _tabController =
            TabController(vsync: this, length: _myTabs.length, initialIndex: 3);
        _pageController = PageController(initialPage: 3);
      } else {
        _tabController =
            TabController(vsync: this, length: _myTabs.length, initialIndex: 2);
        _pageController = PageController(initialPage: 2);
      }
    } else {
      _tabController = TabController(vsync: this, length: _myTabs.length);
      _pageController = PageController();
    }
  }

  @override
  void onItemClick(int tabIndex, String name, String code) {
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
        if (widget.enableStreet!) {
          _districtName = name;
          _districtCode = code;
          _myTabs = [
            TabTitle(index: 0, title: _provinceName, name: "", code: ""),
            TabTitle(index: 1, title: _cityName, name: "", code: ""),
            TabTitle(index: 2, title: _districtName, name: "", code: ""),
            TabTitle(
                index: 3,
                title: "请选择",
                name: _districtName,
                code: _districtCode),
          ];
          _tabController = TabController(
              vsync: this, length: _myTabs.length, initialIndex: 2);
          _pageController!.jumpToPage(3);
          _tabController!.animateTo(3);
          if (mounted) {
            setState(() {});
          }
        } else {
          _districtName = name;
          _districtCode = code;
          widget.cityPickerListener?.onFinish(Address(
            province: AddressNode(code: _provinceCode, name: _provinceName),
            city: AddressNode(code: _cityCode, name: _cityName),
            district: AddressNode(code: _districtCode, name: _districtName),
          ));
          Navigator.pop(context);
        }
        break;
      case 3:
        _streetName = name;
        _streetCode = code;
        widget.cityPickerListener?.onFinish(Address(
          province: AddressNode(code: _provinceCode, name: _provinceName),
          city: AddressNode(code: _cityCode, name: _cityName),
          district: AddressNode(code: _districtCode, name: _districtName),
          street: AddressNode(code: _streetCode, name: _streetName),
        ));
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
          return Text("${data.title ?? ""}",
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
          title: tab.title,
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
