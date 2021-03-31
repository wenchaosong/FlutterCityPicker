import 'package:flutter/material.dart';
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
  CityPickerState createState() => CityPickerState();
}

class CityPickerState extends State<CityPickerWidget>
    with SingleTickerProviderStateMixin {
  CityPickerListener _cityPickerListener;

  TabController _tabController;

  // 当前下标
  int _index = 0;

  // 三级联动选择的position
  var _positions = [-1, -1, -1];

  // 初始化3个，其中两个文字置空
  List<Tab> _myTabs = <Tab>[Tab(text: '请选择'), Tab(text: ''), Tab(text: '')];

  // 省列表
  List<City> _provinceList = [];

  // 市列表
  List<City> _cityList = [];

  // 区列表
  List<City> _districtList = [];

  // 当前列表数据
  List<City> _mList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _myTabs.length);

    _cityPickerListener = widget.cityPickerListener;

    if (_cityPickerListener != null) {
      _cityPickerListener.loadProvinceData().then((value) {
        if (mounted) {
          setState(() {
            _provinceList = value;
            _mList = _provinceList;
          });
        }
      });
    }
  }

  /*void sort() {
    List<City> provList = [];
    for (int i = 0; i < _provinceList.length; i++) {
      provList.add(City(
          code: _provinceList[i].code,
          letter: PinyinHelper.getFirstWordPinyin(_provinceList[i].name)
              .substring(0, 1),
          name: _provinceList[i].name));
    }
    provList.sort((a, b) {
      return a.letter.compareTo(b.letter);
    });
    _mList = provList;
  }*/

  @override
  void dispose() {
    if (mounted) {
      _tabController?.dispose();
    }
    super.dispose();
  }

  /// 点击 tab
  /// 1.更新 tab UI
  /// 2.更新索引
  /// 3.更新当前列表
  void onTabClick(int index) {
    if (_myTabs[index].text.isEmpty) {
      // 拦截点击事件
      return;
    }
    if (mounted) {
      setState(() {
        _index = index;
        switch (index) {
          case 0:
            _mList = _provinceList;
            break;
          case 1:
            _mList = _cityList;
            break;
          case 2:
            _mList = _districtList;
            break;
        }
        if (_positions[index] >= 0) {
          _myTabs[_index] = Tab(text: _mList[_positions[index]].name);
        }
        //todo 滑动到选择的位置
      });
    }
  }

  /// 点击列表城市
  /// 1.把当前 tab 下选中的城市更新状态，更新 tab UI
  /// 2.保存当前列表选中的索引
  /// 3.判断是否点击最后一个tab，是就回调选择完成并关闭
  /// 4.移动 tab 回调请求
  void onCitySelected(int index) {
    switch (_index) {
      case 0:
        if (mounted) {
          setState(() {
            _myTabs[_index] = Tab(text: _mList[index].name);
            _myTabs[1] = Tab(text: '请选择');
            _myTabs[2] = Tab(text: '');
            _mList = [];
            _index = _index + 1;
            _positions = [index, -1, -1];
          });
        }
        _tabController.animateTo(1);
        _tabController.index = 1;

        _cityPickerListener
            .onProvinceSelected(
                _provinceList[index].code, _provinceList[index].name)
            .then((value) {
          if (mounted) {
            setState(() {
              _cityList = value;
              _mList = _cityList;
            });
          }
        });
        break;
      case 1:
        if (mounted) {
          setState(() {
            _myTabs[_index] = Tab(text: _mList[index].name);
            _myTabs[2] = Tab(text: '请选择');
            _mList = [];
            _index = _index + 1;
            _positions = [_positions[0], index, -1];
          });
        }
        _tabController.animateTo(2);
        _tabController.index = 2;

        _cityPickerListener
            .onCitySelected(_cityList[index].code, _cityList[index].name)
            .then((value) {
          if (mounted) {
            setState(() {
              _districtList = value;
              _mList = _districtList;
            });
          }
        });
        break;
      case 2:
        if (mounted) {
          setState(() {
            _myTabs[_index] = Tab(text: _mList[index].name);
            _mList = _districtList;
            _positions = [_positions[0], _positions[1], index];
          });
        }

        _cityPickerListener.onFinish(
          _provinceList[_positions[0]].code,
          _provinceList[_positions[0]].name,
          _cityList[_positions[1]].code,
          _cityList[_positions[1]].name,
          _districtList[_positions[2]].code,
          _districtList[_positions[2]].name,
        );
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
        unselectedLabelStyle: TextStyle(fontSize: widget.labelTextSize ?? 15),
        labelColor: widget.selectedLabelColor ?? Theme.of(context).primaryColor,
        labelStyle: TextStyle(fontSize: widget.labelTextSize ?? 15),
        tabs: _myTabs,
        onTap: (index) => onTabClick(index),
      ),
    );
  }

  /// 底部城市列表组件
  Widget _bottomListWidget() {
    if (_mList.length <= 0) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).dialogBackgroundColor,
      );
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).dialogBackgroundColor,
      child: ListView.builder(
        itemCount: _mList.length,
        itemBuilder: (_, index) {
          bool isSelect = _mList[index].name == _myTabs[_index].text;
          return InkWell(
            onTap: () => onCitySelected(index),
            child: Container(
              height: widget.itemExtent ?? 40,
              padding: EdgeInsets.only(left: widget.paddingLeft ?? 15),
              alignment: Alignment.centerLeft,
              child: Row(children: <Widget>[
                Offstage(
                  offstage: !isSelect,
                  child: widget.itemSelectedIconWidget ??
                      Icon(Icons.done,
                          color: Theme.of(context).primaryColor, size: 16),
                ),
                SizedBox(width: isSelect ? 3 : 0),
                Text(_mList[index].name,
                    style: isSelect
                        ? widget.itemSelectedTextStyle ??
                            TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor)
                        : widget.itemUnSelectedTextStyle ??
                            TextStyle(fontSize: 14, color: Colors.black54))
              ]),
            ),
          );
        },
      ),
    );
  }
}
