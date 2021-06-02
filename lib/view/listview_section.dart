import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ExpandableListView extends BoxScrollView {
  ///same as ListView
  final SliverExpandableChildDelegate builder;

  ExpandableListView({
    required this.builder,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    double? cacheExtent,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  }) : super(
          scrollDirection: Axis.vertical,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          cacheExtent: cacheExtent,
          semanticChildCount: builder.sectionList.length,
          dragStartBehavior: dragStartBehavior,
        );

  @override
  Widget buildChildLayout(BuildContext context) {
    return SliverExpandableList(
      builder: builder,
    );
  }
}

///Section widget information.
class ExpandableSectionContainerInfo {
  Widget? header;
  Widget? content;
  final List<Widget>? children;
  final int? listIndex;
  final List<int>? sectionRealIndexes;
  final bool? separated;

  final ExpandableListController? controller;
  final int? sectionIndex;
  final bool? sticky;

  ExpandableSectionContainerInfo({
    this.header,
    this.content,
    this.children,
    this.listIndex,
    this.sectionRealIndexes,
    this.separated,
    this.controller,
    this.sectionIndex,
    this.sticky,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpandableSectionContainerInfo &&
          runtimeType == other.runtimeType &&
          header == other.header &&
          content == other.content &&
          children == other.children &&
          listIndex == other.listIndex &&
          sectionRealIndexes == other.sectionRealIndexes &&
          separated == other.separated &&
          controller == other.controller &&
          sectionIndex == other.sectionIndex &&
          sticky == other.sticky;

  @override
  int get hashCode =>
      header.hashCode ^
      content.hashCode ^
      children.hashCode ^
      listIndex.hashCode ^
      sectionRealIndexes.hashCode ^
      separated.hashCode ^
      controller.hashCode ^
      sectionIndex.hashCode ^
      sticky.hashCode;
}

///Section widget that contains header and content widget.
///You can return a custom [ExpandableSectionContainer]
///by [SliverExpandableChildDelegate.sectionBuilder], but only
///[header] and [content] field could be changed.
///
class ExpandableSectionContainer extends MultiChildRenderObjectWidget {
  final ExpandableSectionContainerInfo info;

  ExpandableSectionContainer({
    required this.info,
  }) : super(children: [info.content!, info.header!]);

  @override
  RenderExpandableSectionContainer createRenderObject(BuildContext context) {
    var renderSliver =
        context.findAncestorRenderObjectOfType<RenderSliverList>();
    return RenderExpandableSectionContainer(
      renderSliver: renderSliver,
      scrollable: Scrollable.of(context),
      controller: this.info.controller,
      sticky: this.info.sticky,
      listIndex: this.info.listIndex,
      sectionRealIndexes: this.info.sectionRealIndexes,
      separated: this.info.separated,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderExpandableSectionContainer renderObject) {
    renderObject
      ..scrollable = Scrollable.of(context)!
      ..controller = this.info.controller
      ..sticky = this.info.sticky
      ..listIndex = this.info.listIndex
      ..sectionRealIndexes = this.info.sectionRealIndexes
      ..separated = this.info.separated;
  }
}

///Render [ExpandableSectionContainer]
class RenderExpandableSectionContainer extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  bool? _sticky;
  ScrollableState? _scrollable;
  ExpandableListController? _controller;
  RenderSliverList? _renderSliver;
  int? _listIndex;
  int? _stickyIndex = -1;

  ///[sectionIndex, section in SliverList index].
  List<int>? _sectionRealIndexes;

  /// is SliverList has separator
  bool? _separated;

  RenderExpandableSectionContainer({
    @required ScrollableState? scrollable,
    ExpandableListController? controller,
    sticky = true,
    int? listIndex = -1,
    List<int>? sectionRealIndexes = const [],
    bool? separated = false,
    RenderBox? header,
    RenderBox? content,
    RenderSliverList? renderSliver,
  })  : _scrollable = scrollable,
        _controller = controller,
        _sticky = sticky,
        _listIndex = listIndex,
        _sectionRealIndexes = sectionRealIndexes,
        _separated = separated,
        _renderSliver = renderSliver {
    if (content != null) {
      add(content);
    }
    if (header != null) {
      add(header);
    }
  }

  List<int> getSectionRealIndexes() {
    return _sectionRealIndexes!;
  }

  set sectionRealIndexes(List<int>? value) {
    if (_sectionRealIndexes == value) {
      return;
    }
    _sectionRealIndexes = value;
    markNeedsLayout();
  }

  bool getSeparated() {
    return _separated!;
  }

  set separated(bool? value) {
    if (_separated == value) {
      return;
    }
    _separated = value;
    markNeedsLayout();
  }

  ScrollableState getScrollable() {
    return _scrollable!;
  }

  set scrollable(ScrollableState value) {
    if (_scrollable == value) {
      return;
    }
    final ScrollableState? oldValue = _scrollable;
    _scrollable = value;
    markNeedsLayout();
    if (attached) {
      oldValue!.position.removeListener(markNeedsLayout);
      if (_sticky!) {
        _scrollable!.position.addListener(markNeedsLayout);
      }
    }
  }

  ExpandableListController? get controller => _controller;

  set controller(ExpandableListController? value) {
    if (_controller == value) {
      return;
    }
    _controller = value;
    markNeedsLayout();
  }

  bool getSticky() {
    return _sticky!;
  }

  set sticky(bool? value) {
    if (_sticky == value) {
      return;
    }
    _sticky = value;
    markNeedsLayout();
    if (attached && !_sticky!) {
      _scrollable!.position.removeListener(markNeedsLayout);
    }
  }

  int getListIndex() {
    return _listIndex!;
  }

  set listIndex(int? value) {
    if (_listIndex == value) {
      return;
    }
    _listIndex = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData)
      child.parentData = MultiChildLayoutParentData();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (getSticky()) {
      _scrollable!.position.addListener(markNeedsLayout);
    }
  }

  @override
  void detach() {
    _scrollable!.position.removeListener(markNeedsLayout);
    super.detach();
  }

  RenderBox? get content => firstChild;

  RenderBox? get header => lastChild;

  @override
  double computeMinIntrinsicWidth(double height) {
    return max(header!.getMinIntrinsicWidth(height),
        content!.getMinIntrinsicWidth(height));
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return max(header!.getMaxIntrinsicWidth(height),
        content!.getMaxIntrinsicWidth(height));
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return header!.getMinIntrinsicHeight(width) +
        content!.getMinIntrinsicHeight(width);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return header!.getMaxIntrinsicHeight(width) +
        content!.getMaxIntrinsicHeight(width);
  }

  @override
  void performLayout() {
    assert(childCount == 2);

    //layout two child
    BoxConstraints exactlyConstraints = constraints.loosen();
    header!.layout(exactlyConstraints, parentUsesSize: true);
    content!.layout(exactlyConstraints, parentUsesSize: true);

    double width =
        max(constraints.minWidth, max(header!.size.width, content!.size.width));
    double height =
        max(constraints.minHeight, header!.size.height + content!.size.height);
    size = Size(width, height);
    assert(size.width == constraints.constrainWidth(width));
    assert(size.height == constraints.constrainHeight(height));

    //calc content offset
    positionChild(content!, Offset(0, header!.size.height));

    double sliverListOffset = _getSliverListVisibleScrollOffset();
    if (_controller!.containerOffsets.length <= _listIndex! ||
        (_listIndex! > 0 && _controller!.containerOffsets[_listIndex!]! <= 0)) {
      _refreshContainerLayoutOffsets();
    }

    double? currContainerOffset = -1;
    if (_listIndex! < _controller!.containerOffsets.length) {
      currContainerOffset = _controller!.containerOffsets[_listIndex!];
    }
    bool containerPainted = (_listIndex == 0 && currContainerOffset == 0) ||
        currContainerOffset! > 0;
    if (!containerPainted) {
      positionChild(header!, Offset.zero);
      return;
    }
    double minScrollOffset = _listIndex! >= _controller!.containerOffsets.length
        ? 0
        : _controller!.containerOffsets[_listIndex!]!;
    double maxScrollOffset = minScrollOffset + size.height;

    //when [ExpandableSectionContainer] size changed, SliverList may give a wrong
    // layoutOffset at first time, so check offsets for store right layoutOffset
    // in [containerOffsets].
    if (_listIndex! < _controller!.containerOffsets.length) {
      currContainerOffset = _controller!.containerOffsets[_listIndex!];
      int nextListIndex = _listIndex! + 1;
      if (nextListIndex < _controller!.containerOffsets.length &&
          _controller!.containerOffsets[nextListIndex]! < maxScrollOffset) {
        _controller!.containerOffsets =
            _controller!.containerOffsets.sublist(0, nextListIndex);
      }
    }

    if (sliverListOffset > minScrollOffset &&
        sliverListOffset <= maxScrollOffset) {
      if (_stickyIndex != _listIndex) {
        _stickyIndex = _listIndex;
        if (_controller != null) {
          //ensure callback 100% percent.
          _controller!.updatePercent(_controller!.switchingSectionIndex, 1);
          //update sticky index
          _controller!.stickySectionIndex = sectionIndex;
        }
      }
    } else if (sliverListOffset <= 0) {
      if (_controller != null) {
        _controller!.stickySectionIndex = -1;
        _stickyIndex = -1;
      }
    } else {
      _stickyIndex = -1;
    }

    //calc header offset
    double currHeaderOffset = 0;
    double headerMaxOffset = content!.size.height;
    if (_sticky! && isStickyChild && sliverListOffset > minScrollOffset) {
      currHeaderOffset = sliverListOffset - minScrollOffset;
    }
    positionChild(header!, Offset(0, min(currHeaderOffset, headerMaxOffset)));

    //callback header hide percent
    if (_controller != null) {
      if (currHeaderOffset >= headerMaxOffset && currHeaderOffset <= height) {
        double switchingPercent =
            (currHeaderOffset - headerMaxOffset) / header!.size.height;
        _controller!.updatePercent(sectionIndex, switchingPercent);
      } else if (sliverListOffset < minScrollOffset + content!.size.height &&
          _controller!.switchingSectionIndex == sectionIndex) {
        //ensure callback 0% percent.
        _controller!.updatePercent(sectionIndex, 0);
        //reset switchingSectionIndex
        _controller!.updatePercent(-1, 1);
      }
    }
  }

  bool get isStickyChild => _listIndex == _stickyIndex;

  int? get sectionIndex => getSeparated() ? _listIndex! ~/ 2 : _listIndex;

  double _getSliverListVisibleScrollOffset() {
    return _renderSliver!.constraints.overlap +
        _renderSliver!.constraints.scrollOffset;
  }

  void _refreshContainerLayoutOffsets() {
    _renderSliver!.visitChildren((renderObject) {
      var containerParentData =
          renderObject.parentData as SliverMultiBoxAdaptorParentData;

      while (
          _controller!.containerOffsets.length <= containerParentData.index!) {
        _controller!.containerOffsets.add(0);
      }
      if (containerParentData.layoutOffset != null) {
        _controller!.containerOffsets[containerParentData.index!] =
            containerParentData.layoutOffset;
      }
    });
  }

  void positionChild(RenderBox child, Offset offset) {
    final MultiChildLayoutParentData childParentData =
        child.parentData as MultiChildLayoutParentData;
    childParentData.offset = offset;
  }

  Offset childOffset(RenderBox child) {
    final MultiChildLayoutParentData childParentData =
        child.parentData as MultiChildLayoutParentData;
    return childParentData.offset;
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}

typedef ExpandableHeaderBuilder = Widget Function(
    BuildContext context, int sectionIndex, int index);
typedef ExpandableItemBuilder = Widget Function(
    BuildContext context, int sectionIndex, int itemIndex, int index);
typedef ExpandableSeparatorBuilder = Widget Function(
    BuildContext context, bool isSectionSeparator, int index);
typedef ExpandableSectionBuilder = Widget Function(
    BuildContext context, ExpandableSectionContainerInfo containerInfo);

/// A scrollable list of widgets arranged linearly, support expand/collapse item and
/// sticky header.
/// all build options are set in [SliverExpandableChildDelegate], this is to avoid
/// [SliverExpandableList] use generics.
class SliverExpandableList extends SliverList {
  final SliverExpandableChildDelegate builder;

  SliverExpandableList({
    required this.builder,
  }) : super(delegate: builder.delegate);
}

/// A delegate that supplies children for [SliverExpandableList] using
/// a builder callback.
class SliverExpandableChildDelegate<T, S extends ExpandableListSection<T>> {
  ///data source
  final List sectionList;

  ///build section header
  final ExpandableHeaderBuilder? headerBuilder;

  ///build section item
  final ExpandableItemBuilder itemBuilder;

  ///build header and item separator, if pass null, SliverList has no separators.
  ///default null.
  final ExpandableSeparatorBuilder? separatorBuilder;

  ///whether to sticky the header.
  final bool sticky;

  ///store section real index in SliverList, format: [sectionList index, SliverList index].
  final List<int> sectionRealIndexes;

  ///use this return a custom content widget, when use this builder, headerBuilder
  ///is invalid.
  ExpandableSectionBuilder? sectionBuilder;

  ///expandable list controller, listen sticky header index scroll offset etc.
  ExpandableListController? controller;

  ///sliver list builder
  late SliverChildBuilderDelegate delegate;

  ///if value is true, when section is collapsed, all child widget in section widget will be removed.
  bool removeItemsOnCollapsed = true;

  SliverExpandableChildDelegate(
      {required this.sectionList,
      required this.itemBuilder,
      this.controller,
      this.separatorBuilder,
      this.headerBuilder,
      this.sectionBuilder,
      this.sticky = true,
      this.removeItemsOnCollapsed = true,
      bool addAutomaticKeepAlives = true,
      bool addRepaintBoundaries = true,
      bool addSemanticIndexes = true})
      : assert(headerBuilder == null || sectionBuilder == null),
        sectionRealIndexes = _buildSectionRealIndexes(sectionList) {
    if (controller == null) {
      controller = ExpandableListController();
    }
    if (separatorBuilder == null) {
      delegate = SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          int sectionIndex = index;
          S section = sectionList[sectionIndex];
          int sectionRealIndex = sectionRealIndexes[sectionIndex];
          int itemRealIndex = sectionRealIndex;

          bool hasChildren =
              ((removeItemsOnCollapsed && !section.isSectionExpanded()) ||
                  section.getItems() == null);
          var children = hasChildren
              ? <Widget>[]
              : List.generate(
                  section.getItems()!.length,
                  (i) =>
                      itemBuilder(context, sectionIndex, i, ++itemRealIndex));
          var containerInfo = ExpandableSectionContainerInfo(
            separated: false,
            listIndex: index,
            sectionIndex: sectionIndex,
            sectionRealIndexes: sectionRealIndexes,
            sticky: sticky,
            controller: controller,
            header: null,
            content: Column(
              children: children,
            ),
            children: children,
          );
          Widget? container = sectionBuilder != null
              ? sectionBuilder!(context, containerInfo)
              : null;
          if (container == null) {
            containerInfo
              ..header =
                  headerBuilder!(context, sectionIndex, sectionRealIndex);
            container = ExpandableSectionContainer(
              info: containerInfo,
            );
          }
          return container;
        },
        childCount: sectionList.length,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
      );
    } else {
      delegate = SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final int sectionIndex = index ~/ 2;
          Widget itemView;
          S section = sectionList[sectionIndex];
          int sectionRealIndex = sectionRealIndexes[sectionIndex];
          if (index.isEven) {
            int sectionChildCount =
                _computeSemanticChildCount(section.getItems()?.length ?? 0);
            int itemRealIndex = sectionRealIndex;

            bool hasChildren =
                ((removeItemsOnCollapsed && !section.isSectionExpanded()) ||
                    section.getItems() == null);
            var children = hasChildren
                ? <Widget>[]
                : List.generate(
                    sectionChildCount,
                    (i) => i.isEven
                        ? itemBuilder(
                            context, sectionIndex, i ~/ 2, ++itemRealIndex)
                        : separatorBuilder!(context, false, itemRealIndex - 1));

            var containerInfo = ExpandableSectionContainerInfo(
              separated: true,
              listIndex: index,
              sectionIndex: sectionIndex,
              sectionRealIndexes: sectionRealIndexes,
              sticky: sticky,
              controller: controller,
              header: null,
              children: children,
              content: Column(
                children: children,
              ),
            );
            Widget? container = sectionBuilder != null
                ? sectionBuilder!(context, containerInfo)
                : null;
            if (container == null) {
              containerInfo
                ..header =
                    headerBuilder!(context, sectionIndex, sectionRealIndex);
              container = ExpandableSectionContainer(
                info: containerInfo,
              );
            }
            return container;
          } else {
            itemView = separatorBuilder!(context, true,
                sectionIndex + (section.getItems()?.length ?? 0));
          }
          return itemView;
        },
        childCount: _computeSemanticChildCount(sectionList.length),
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        semanticIndexCallback: (Widget _, int index) {
          return index.isEven ? index ~/ 2 : null;
        },
      );
    }
  }

  static int _computeSemanticChildCount(int itemCount) {
    return max(0, itemCount * 2 - 1);
  }

  static List<int>
      _buildSectionRealIndexes<T, S extends ExpandableListSection<T>>(
          List sectionList) {
    int calcLength = sectionList.length - 1;
    List<int> sectionRealIndexes = [];
    if (calcLength < 0) {
      return sectionRealIndexes;
    }
    sectionRealIndexes.add(0);
    int realIndex = 0;
    for (int i = 0; i < calcLength; i++) {
      S section = sectionList[i];
      //each section model should not null.
      realIndex += 1 + (section.getItems()?.length ?? 0);
      sectionRealIndexes.add(realIndex);
    }
    return sectionRealIndexes;
  }
}

///Used to provide information for each section, each section model
///should implement [ExpandableListSection<Item Model>].
abstract class ExpandableListSection<T> {
  bool isSectionExpanded();

  void setSectionExpanded(bool expanded);

  List<T>? getItems();
}

///Controller for listen sticky header offset and current sticky header index.
class ExpandableListController extends ChangeNotifier {
  ///switchingSection scroll percent, [0.1-1.0], 1.0 mean that the last sticky section
  ///is completely hidden.
  double _percent = 1;
  int? _switchingSectionIndex = -1;
  int? _stickySectionIndex = -1;

  ExpandableListController();

  ///store [ExpandableSectionContainer] information. [SliverList index, layoutOffset].
  ///don't modify it.
  List<double?> containerOffsets = [];

  double get percent => _percent;

  int? get switchingSectionIndex => _switchingSectionIndex;

  ///get pinned header index
  int? get stickySectionIndex => _stickySectionIndex;

  updatePercent(int? sectionIndex, double percent) {
    if (_percent == percent && _switchingSectionIndex == sectionIndex) {
      return;
    }
    _switchingSectionIndex = sectionIndex;
    _percent = percent;
    notifyListeners();
  }

  set stickySectionIndex(int? value) {
    if (_stickySectionIndex == value) {
      return;
    }
    _stickySectionIndex = value;
    notifyListeners();
  }

  void forceNotifyListeners() {
    notifyListeners();
  }

  @override
  String toString() {
    return 'ExpandableListController{_percent: $_percent, _switchingSectionIndex: $_switchingSectionIndex, _stickySectionIndex: $_stickySectionIndex}';
  }
}

///Check if need rebuild [ExpandableAutoLayoutWidget]
abstract class ExpandableAutoLayoutTrigger {
  ExpandableListController get controller;

  bool needBuild();
}

///Default [ExpandableAutoLayoutTrigger] implementation, auto build when
///switch sticky header index.
class ExpandableDefaultAutoLayoutTrigger
    implements ExpandableAutoLayoutTrigger {
  final ExpandableListController _controller;

  double _percent = 0;
  int? _stickyIndex = 0;

  ExpandableDefaultAutoLayoutTrigger(this._controller) : super();

  @override
  bool needBuild() {
    if (_percent == _controller.percent &&
        _stickyIndex == _controller.stickySectionIndex) {
      return false;
    }
    _percent = _controller.percent;
    _stickyIndex = _controller.stickySectionIndex;
    return true;
  }

  @override
  ExpandableListController get controller => _controller;
}

///Wrap header widget, when controller is set, the widget will rebuild
///when [trigger] condition matched.
class ExpandableAutoLayoutWidget extends StatefulWidget {
  ///listen sticky header hide percent, [0.0-0.1].
  final ExpandableAutoLayoutTrigger? trigger;

  ///build section header
  final WidgetBuilder? builder;

  ExpandableAutoLayoutWidget({this.builder, this.trigger});

  @override
  _ExpandableAutoLayoutWidgetState createState() =>
      _ExpandableAutoLayoutWidgetState();
}

class _ExpandableAutoLayoutWidgetState
    extends State<ExpandableAutoLayoutWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.trigger != null) {
      widget.trigger!.controller.addListener(_onChange);
    }
  }

  void _onChange() {
    if (widget.trigger!.needBuild()) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.trigger != null) {
      widget.trigger!.controller.removeListener(_onChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: widget.builder!(context),
    );
  }
}
