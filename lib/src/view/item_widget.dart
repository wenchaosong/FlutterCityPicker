import 'package:flutter/material.dart';
import '../../src/listener/item_listener.dart';
import '../../city_picker.dart';

/// 城市列表组件
class ItemWidget extends StatefulWidget {
  /// 当前列表的索引
  final int index;

  /// 上一级城市代码
  final String code;

  /// 上一级城市名称
  final String name;

  /// item 高度
  final double itemExtent;

  /// 左边间距
  final double paddingLeft;

  /// 选中城市的图标组件
  final Widget itemSelectedIconWidget;

  /// 选中城市文字样式
  final TextStyle itemSelectedTextStyle;

  /// 未选中城市文字样式
  final TextStyle itemUnSelectedTextStyle;

  final CityPickerListener cityPickerListener;

  final ItemClickListener itemClickListener;

  ItemWidget({
    @required this.index,
    @required this.code,
    @required this.name,
    @required this.itemExtent,
    @required this.paddingLeft,
    @required this.itemSelectedIconWidget,
    @required this.itemSelectedTextStyle,
    @required this.itemUnSelectedTextStyle,
    @required this.cityPickerListener,
    @required this.itemClickListener,
  });

  @override
  State<StatefulWidget> createState() => ItemWidgetState();
}

class ItemWidgetState extends State<ItemWidget>
    with AutomaticKeepAliveClientMixin {
  CityPickerListener _cityPickerListener;
  ItemClickListener _itemClickListener;

  // 选中的名称
  String _title = "请选择";

  // 上次保存的名称
  String _preName = "";

  // 列表数据
  List<City> _mList = [];

  @override
  void initState() {
    super.initState();

    _itemClickListener = widget.itemClickListener;
    _cityPickerListener = widget.cityPickerListener;
    if (_cityPickerListener != null) {
      switch (widget.index) {
        case 0:
          _cityPickerListener.loadProvinceData().then((value) {
            if (mounted) {
              setState(() {
                _mList = value;
              });
            }
          });
          break;
        case 1:
          _cityPickerListener
              .onProvinceSelected(widget.code, widget.name)
              .then((value) {
            if (mounted) {
              setState(() {
                _mList = value;
                _preName = widget.name;
              });
            }
          });
          break;
        case 2:
          _cityPickerListener
              .onCitySelected(widget.code, widget.name)
              .then((value) {
            if (mounted) {
              setState(() {
                _mList = value;
                _preName = widget.name;
              });
            }
          });
          break;
      }
    }
  }

  /// 判断上一级数据是否变动，如果变动就更新
  @override
  void didUpdateWidget(covariant ItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_cityPickerListener != null) {
      switch (widget.index) {
        case 1:
          if (_preName.isNotEmpty &&
              widget.name.isNotEmpty &&
              _preName != widget.name) {
            _title = "";
            _cityPickerListener
                .onProvinceSelected(widget.code, widget.name)
                .then((value) {
              if (mounted) {
                setState(() {
                  _mList = value;
                });
              }
            });
          }
          if (widget.name.isNotEmpty) {
            if (mounted) {
              setState(() {
                _preName = widget.name;
              });
            }
          }
          break;
        case 2:
          if (_preName.isNotEmpty &&
              widget.name.isNotEmpty &&
              _preName != widget.name) {
            _title = "";
            _cityPickerListener
                .onCitySelected(widget.code, widget.name)
                .then((value) {
              if (mounted) {
                setState(() {
                  _mList = value;
                });
              }
            });
          }
          if (widget.name.isNotEmpty) {
            if (mounted) {
              setState(() {
                _preName = widget.name;
              });
            }
          }
          break;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).dialogBackgroundColor,
      child: ListView.builder(
        itemCount: _mList.length,
        itemBuilder: (_, index) {
          bool isSelect = _mList[index].name == _title;
          return InkWell(
            onTap: () {
              if (mounted) {
                setState(() {
                  _title = _mList[index].name;
                });
              }
              if (_itemClickListener != null) {
                _itemClickListener.onItemClick(widget.index, index, _mList);
              }
            },
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

  @override
  bool get wantKeepAlive => true;
}
