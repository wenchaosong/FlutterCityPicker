import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import '../../src/model/section_city.dart';
import '../../src/listener/item_listener.dart';
import '../../city_picker.dart';
import 'listview_section.dart';

/// 城市列表组件
class ItemWidget extends StatefulWidget {
  /// 当前列表的索引
  final int index;

  /// 上一级城市代码
  final String code;

  /// 上一级城市名称
  final String name;

  /// 左边间距
  final double paddingLeft;

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

  final CityPickerListener cityPickerListener;

  final ItemClickListener itemClickListener;

  ItemWidget({
    @required this.index,
    @required this.code,
    @required this.name,
    @required this.paddingLeft,
    @required this.itemHeadHeight,
    @required this.itemHeadBackgroundColor,
    @required this.itemHeadLineColor,
    @required this.itemHeadLineHeight,
    @required this.itemHeadTextStyle,
    @required this.itemHeight,
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
  List<SectionCity> _mList = [];

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
                _mList = sortCity(value);
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
                _mList = sortCity(value);
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
                _mList = sortCity(value);
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
                  _mList = sortCity(value);
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
                  _mList = sortCity(value);
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

  /// 排序数据
  List<SectionCity> sortCity(List<City> value) {
    // 先排序
    List<City> _cityList = [];
    value.forEach((city) {
      String letter = PinyinHelper.getFirstWordPinyin(city.name)
          .substring(0, 1)
          .toUpperCase();
      _cityList.add(City(code: city.code, letter: letter, name: city.name));
    });
    _cityList.sort((a, b) => a.letter.compareTo(b.letter));
    // 组装数据
    List<SectionCity> _sectionList = [];
    String _letter = "A";
    List<City> _cityList2 = [];
    for (int i = 0; i < _cityList.length; i++) {
      if (_letter == _cityList[i].letter) {
        _cityList2.add(_cityList[i]);
      } else {
        if (_cityList2.length > 0) {
          _sectionList.add(SectionCity(letter: _letter, data: _cityList2));
        }
        _cityList2 = [];
        _cityList2.add(_cityList[i]);
        _letter = _cityList[i].letter;
      }
      if (i == _cityList.length - 1) {
        if (_cityList2.length > 0) {
          _sectionList.add(SectionCity(letter: _letter, data: _cityList2));
        }
      }
    }
    return _sectionList;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).dialogBackgroundColor,
      child: ExpandableListView(
        builder: SliverExpandableChildDelegate<City, SectionCity>(
            sectionList: _mList,
            headerBuilder: (context, sectionIndex, index) {
              return Container(
                width: double.infinity,
                height: widget.itemHeadHeight ?? 30,
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                    width: widget.itemHeadLineHeight ?? 0.1,
                    color: widget.itemHeadLineColor ?? Colors.black38,
                  )),
                  color: widget.itemHeadBackgroundColor ??
                      Theme.of(context).dialogBackgroundColor,
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: widget.paddingLeft ?? 15),
                child: Text(_mList[sectionIndex].letter,
                    style: widget.itemHeadTextStyle ??
                        TextStyle(fontSize: 15, color: Colors.black)),
              );
            },
            itemBuilder: (context, sectionIndex, itemIndex, index) {
              City city = _mList[sectionIndex].data[itemIndex];
              bool isSelect = city.name == _title;
              return InkWell(
                onTap: () {
                  if (mounted) {
                    setState(() {
                      _title = city.name;
                    });
                  }
                  if (_itemClickListener != null) {
                    _itemClickListener.onItemClick(
                        widget.index, city.name, city.code);
                  }
                },
                child: Container(
                  height: widget.itemHeight ?? 40,
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
                    Text(city.name,
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
            }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
