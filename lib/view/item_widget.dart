import 'dart:math';

import 'package:flutter/material.dart';

import '../listener/item_listener.dart';
import '../model/address.dart';
import '../model/section_city.dart';
import 'listview_section.dart';

/// 城市列表组件
class ItemWidget extends StatefulWidget {
  final double? height;

  /// 当前列表的索引
  final int? index;

  /// 数据
  final List<SectionCity>? list;

  /// 选中 tab
  final String? title;

  /// 选择文字
  final String? selectText;

  /// 背景颜色
  final Color? backgroundColor;

  /// 左边间距
  final double? paddingLeft;

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

  final ItemClickListener? itemClickListener;

  const ItemWidget({
    Key? key,
    this.height,
    this.index,
    this.list,
    this.title,
    this.selectText,
    this.backgroundColor,
    this.paddingLeft,
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
    this.itemClickListener,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ItemWidgetState();
}

class ItemWidgetState extends State<ItemWidget>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  late String? _title = widget.title ?? widget.selectText ?? "请选择";

  // 列表数据
  List<SectionCity> _mList = [];

  @override
  void initState() {
    super.initState();

    _mList = widget.list ?? [];
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    if (mounted) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.list != widget.list) {
      _mList = widget.list ?? [];
      if (mounted) {
        setState(() {});
      }
    }
  }

  /// 点击索引，列表滑动
  void clickIndexBar(int index) {
    if (index == 0) {
      _scrollController.jumpTo(0);
      return;
    }
    double position = 0;
    int length = 0;
    // 计算位置
    for (int i = 0; i < _mList.length; i++) {
      if (_mList[index].letter == _mList[i].letter) {
        position = i * widget.itemHeadHeight! + length * widget.itemHeight!;
      }
      length += _mList[i].data!.length;
    }
    _scrollController.jumpTo(position);
  }

  /// 获取索引
  int _getIndex(double offset) {
    double h =
        (widget.height! - (_mList.length * widget.indexBarItemHeight! + 4)) / 2;
    int index = (offset - h) ~/ widget.indexBarItemHeight!;
    return min(index, _mList.length - 1);
  }

  /// 点击区域
  RenderBox? _getRenderBox(BuildContext context) {
    RenderObject? renderObject = context.findRenderObject();
    RenderBox? box;
    if (renderObject != null) {
      box = renderObject as RenderBox;
    }
    return box;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: widget.backgroundColor ?? Theme.of(context).dialogBackgroundColor,
      child: Stack(
        children: [
          ExpandableListView(
            controller: _scrollController,
            builder: SliverExpandableChildDelegate<AddressNode, SectionCity>(
              sectionList: _mList,
              headerBuilder: (context, sectionIndex, index) {
                return Container(
                  width: double.infinity,
                  height: widget.itemHeadHeight,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      width: widget.itemHeadLineHeight!,
                      color: widget.itemHeadLineColor ?? Colors.black38,
                    )),
                    color: widget.itemHeadBackgroundColor ??
                        Theme.of(context).dialogBackgroundColor,
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: widget.paddingLeft!),
                  child: Text(
                    _mList[sectionIndex].letter!,
                    style: widget.itemHeadTextStyle ??
                        const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                );
              },
              itemBuilder: (context, sectionIndex, itemIndex, index) {
                AddressNode city = _mList[sectionIndex].data![itemIndex];
                bool isSelect = city.name == _title;
                return InkWell(
                  onTap: () {
                    _title = city.name!;
                    if (mounted) {
                      setState(() {});
                    }
                    widget.itemClickListener!
                        .onItemClick(widget.index!, city.name!, city.code!);
                  },
                  child: Container(
                    width: double.infinity,
                    height: widget.itemHeight,
                    padding: EdgeInsets.only(left: widget.paddingLeft!),
                    alignment: Alignment.centerLeft,
                    child: Row(children: [
                      Offstage(
                        offstage: !isSelect,
                        child: widget.itemSelectedIconWidget ??
                            Icon(Icons.done,
                                color: Theme.of(context).primaryColor,
                                size: 16),
                      ),
                      SizedBox(width: isSelect ? 3 : 0),
                      Text(city.name!,
                          style: isSelect
                              ? widget.itemSelectedTextStyle ??
                                  TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  )
                              : widget.itemUnSelectedTextStyle ??
                                  const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ))
                    ]),
                  ),
                );
              },
            ),
          ),
          Positioned(
            right: widget.paddingLeft,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: widget.indexBarWidth,
              child: GestureDetector(
                onVerticalDragDown: (DragDownDetails details) {
                  RenderBox? box = _getRenderBox(context);
                  if (box == null) return;
                  int index = _getIndex(details.localPosition.dy);
                  if (index >= 0) {
                    clickIndexBar(index);
                  }
                },
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  int index = _getIndex(details.localPosition.dy);
                  if (index >= 0) {
                    clickIndexBar(index);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_mList.length, (index) {
                    return _indexBarItem(index);
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _indexBarItem(int index) {
    // 有4种类型
    int type = 0;
    if (index == 0 && index == _mList.length - 1) {
      // 只有1个
      type = 1;
    } else if (index == 0) {
      // 顶部
      type = 2;
    } else if (index == _mList.length - 1) {
      // 底部
      type = 3;
    } else {
      // 中间
      type = 4;
    }
    return Container(
      width: widget.indexBarWidth,
      height: (index == 0 || index == _mList.length - 1)
          ? widget.indexBarItemHeight! + 2
          : widget.indexBarItemHeight!,
      alignment: Alignment.center,
      padding: type == 2
          ? const EdgeInsets.only(top: 1)
          : type == 3
              ? const EdgeInsets.only(bottom: 1)
              : const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: widget.indexBarBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: (type == 1 || type == 2)
              ? const Radius.circular(50)
              : const Radius.circular(0),
          topRight: (type == 1 || type == 2)
              ? const Radius.circular(50)
              : const Radius.circular(0),
          bottomLeft: (type == 1 || type == 3)
              ? const Radius.circular(50)
              : const Radius.circular(0),
          bottomRight: (type == 1 || type == 3)
              ? const Radius.circular(50)
              : const Radius.circular(0),
        ),
      ),
      child: Text(
        _mList[index].letter!,
        style: widget.indexBarTextStyle ??
            const TextStyle(fontSize: 14, color: Colors.black54),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
