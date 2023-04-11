import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ExpandableListView extends BoxScrollView {
  ///same as ListView
  final SliverExpandableChildDelegate builder;

  ExpandableListView({
    Key? key,
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
          key: key,
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
  final SliverChildBuilderDelegate? childDelegate;
  final int listIndex;
  final List<int> sectionRealIndexes;
  final bool separated;

  final ExpandableListController controller;
  final int sectionIndex;
  final bool sticky;
  final bool overlapsContent;

  ExpandableSectionContainerInfo(
      {this.header,
      this.content,
      this.childDelegate,
      required this.listIndex,
      required this.sectionRealIndexes,
      required this.separated,
      required this.controller,
      required this.sectionIndex,
      required this.sticky,
      required this.overlapsContent});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpandableSectionContainerInfo &&
          runtimeType == other.runtimeType &&
          header == other.header &&
          content == other.content &&
          childDelegate == other.childDelegate &&
          listIndex == other.listIndex &&
          sectionRealIndexes == other.sectionRealIndexes &&
          separated == other.separated &&
          controller == other.controller &&
          sectionIndex == other.sectionIndex &&
          sticky == other.sticky &&
          overlapsContent == other.overlapsContent;

  @override
  int get hashCode =>
      (header?.hashCode ?? 0) ^
      (content?.hashCode ?? 0) ^
      (childDelegate?.hashCode ?? 0) ^
      listIndex.hashCode ^
      sectionRealIndexes.hashCode ^
      separated.hashCode ^
      controller.hashCode ^
      sectionIndex.hashCode ^
      sticky.hashCode ^
      overlapsContent.hashCode;
}

///Section widget that contains header and content widget.
///You can return a custom [ExpandableSectionContainer]
///by [SliverExpandableChildDelegate.sectionBuilder], but only
///[header] and [content] field could be changed.
///
class ExpandableSectionContainer extends MultiChildRenderObjectWidget {
  final ExpandableSectionContainerInfo info;

  ExpandableSectionContainer({
    Key? key,
    required this.info,
  }) : super(key: key, children: [info.content!, info.header!]);

  @override
  RenderExpandableSectionContainer createRenderObject(BuildContext context) {
    var renderSliver =
        context.findAncestorRenderObjectOfType<RenderExpandableSliverList>()!;
    return RenderExpandableSectionContainer(
      renderSliver: renderSliver,
      scrollable: Scrollable.of(context),
      controller: info.controller,
      sticky: info.sticky,
      overlapsContent: info.overlapsContent,
      listIndex: info.listIndex,
      sectionRealIndexes: info.sectionRealIndexes,
      separated: info.separated,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderExpandableSectionContainer renderObject) {
    renderObject
      ..scrollable = Scrollable.of(context)
      ..controller = info.controller
      ..sticky = info.sticky
      ..overlapsContent = info.overlapsContent
      ..listIndex = info.listIndex
      ..sectionRealIndexes = info.sectionRealIndexes
      ..separated = info.separated;
  }
}

///Render [ExpandableSectionContainer]
class RenderExpandableSectionContainer extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  bool _sticky;
  bool _overlapsContent;
  ScrollableState _scrollable;
  ExpandableListController _controller;
  final RenderExpandableSliverList _renderSliver;
  int _listIndex;
  int _stickyIndex = -1;

  ///[sectionIndex, section in SliverList index].
  List<int> _sectionRealIndexes;

  /// is SliverList has separator
  bool _separated;

  RenderExpandableSectionContainer({
    required ScrollableState scrollable,
    required ExpandableListController controller,
    sticky = true,
    overlapsContent = false,
    int listIndex = -1,
    List<int> sectionRealIndexes = const [],
    bool separated = false,
    required RenderExpandableSliverList renderSliver,
  })  : _scrollable = scrollable,
        _controller = controller,
        _sticky = sticky,
        _overlapsContent = overlapsContent,
        _listIndex = listIndex,
        _sectionRealIndexes = sectionRealIndexes,
        _separated = separated,
        _renderSliver = renderSliver;

  List<int> get sectionRealIndexes => _sectionRealIndexes;

  set sectionRealIndexes(List<int> value) {
    if (_sectionRealIndexes == value) {
      return;
    }
    _sectionRealIndexes = value;
    markNeedsLayout();
  }

  bool get separated => _separated;

  set separated(bool value) {
    if (_separated == value) {
      return;
    }
    _separated = value;
    markNeedsLayout();
  }

  ScrollableState get scrollable => _scrollable;

  set scrollable(ScrollableState value) {
    //when collapse last section, Sliver list not callback correct offset, so layout again.
    if (_renderSliver.sizeChanged) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (attached) {
          clearContainerLayoutOffsets();
          markNeedsLayout();
        }
      });
    }
    if (_scrollable == value) {
      return;
    }
    final ScrollableState oldValue = _scrollable;
    _scrollable = value;
    markNeedsLayout();
    if (attached) {
      oldValue.widget.controller?.removeListener(markNeedsLayout);
      if (_sticky) {
        _scrollable.widget.controller?.addListener(markNeedsLayout);
      }
    }
  }

  ExpandableListController get controller => _controller;

  set controller(ExpandableListController value) {
    if (_controller == value) {
      return;
    }
    _controller = value;
    markNeedsLayout();
  }

  bool get sticky => _sticky;

  set sticky(bool value) {
    if (_sticky == value) {
      return;
    }
    _sticky = value;
    markNeedsLayout();
    if (attached && !_sticky) {
      _scrollable.widget.controller?.removeListener(markNeedsLayout);
    }
  }

  bool get overlapsContent => _overlapsContent;

  set overlapsContent(bool value) {
    if (_overlapsContent == value) {
      return;
    }
    _overlapsContent = value;
    markNeedsLayout();
  }

  int get listIndex => _listIndex;

  set listIndex(int value) {
    if (_listIndex == value) {
      return;
    }
    _listIndex = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (sticky) {
      _scrollable.widget.controller?.addListener(markNeedsLayout);
    }
  }

  @override
  void detach() {
    _scrollable.widget.controller?.removeListener(markNeedsLayout);
    super.detach();
  }

  RenderBox get content => firstChild!;

  RenderBox get header => lastChild!;

  @override
  double computeMinIntrinsicWidth(double height) {
    return _overlapsContent
        ? math.max(header.getMinIntrinsicWidth(height),
            content.getMinIntrinsicWidth(height))
        : header.getMinIntrinsicWidth(height) +
            content.getMinIntrinsicWidth(height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _overlapsContent
        ? math.max(header.getMaxIntrinsicWidth(height),
            content.getMaxIntrinsicWidth(height))
        : header.getMaxIntrinsicWidth(height) +
            content.getMaxIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _overlapsContent
        ? math.max(header.getMinIntrinsicHeight(width),
            content.getMinIntrinsicHeight(width))
        : header.getMinIntrinsicHeight(width) +
            content.getMinIntrinsicHeight(width);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _overlapsContent
        ? math.max(header.getMaxIntrinsicHeight(width),
            content.getMaxIntrinsicHeight(width))
        : header.getMaxIntrinsicHeight(width) +
            content.getMaxIntrinsicHeight(width);
  }

  @override
  void performLayout() {
    assert(childCount == 2);

    //layout two child
    BoxConstraints exactlyConstraints = constraints.loosen();
    header.layout(exactlyConstraints, parentUsesSize: true);
    content.layout(exactlyConstraints, parentUsesSize: true);

    //header's size should not large than content's size.
    double headerLogicalExtent = _overlapsContent ? 0 : header.size.height;

    double width = math.max(
        constraints.minWidth, math.max(header.size.width, content.size.width));
    double height = math.max(
        constraints.minHeight,
        math.max(
            header.size.height, headerLogicalExtent + content.size.height));
    size = Size(width, height);
    assert(size.width == constraints.constrainWidth(width));
    assert(size.height == constraints.constrainHeight(height));

    //calc content offset
    positionChild(content, Offset(0, headerLogicalExtent));

    checkRefreshContainerOffset();

    double sliverListOffset = _getSliverListVisibleScrollOffset();
    double currContainerOffset = -1;
    if (_listIndex < _controller.containerOffsets.length) {
      currContainerOffset = _controller.containerOffsets[_listIndex]!;
    }
    bool containerPainted = (_listIndex == 0 && currContainerOffset == 0) ||
        currContainerOffset > 0;
    if (!containerPainted) {
      positionChild(header, Offset.zero);
      return;
    }
    double minScrollOffset = _listIndex >= _controller.containerOffsets.length
        ? 0
        : _controller.containerOffsets[_listIndex]!;
    double maxScrollOffset = minScrollOffset + size.height;

    //when [ExpandableSectionContainer] size changed, SliverList may give a wrong
    // layoutOffset at first time, so check offsets for store right layoutOffset
    // in [containerOffsets].
    if (_listIndex < _controller.containerOffsets.length) {
      currContainerOffset = _controller.containerOffsets[_listIndex]!;
      int nextListIndex = _listIndex + 1;
      if (nextListIndex < _controller.containerOffsets.length &&
          _controller.containerOffsets[nextListIndex]! < maxScrollOffset) {
        _controller.containerOffsets =
            _controller.containerOffsets.sublist(0, nextListIndex);
      }
    }

    if (sliverListOffset > minScrollOffset &&
        sliverListOffset <= maxScrollOffset) {
      if (_stickyIndex != _listIndex) {
        _stickyIndex = _listIndex;
        _controller.updatePercent(_controller.switchingSectionIndex, 1);
        //update sticky index
        _controller.stickySectionIndex = sectionIndex;
      }
    } else if (sliverListOffset <= 0) {
      _controller.stickySectionIndex = -1;
      _stickyIndex = -1;
    } else {
      _stickyIndex = -1;
    }

    //calc header offset
    double currHeaderOffset = 0;
    double headerMaxOffset = height - header.size.height;
    if (_sticky && isStickyChild && sliverListOffset > minScrollOffset) {
      currHeaderOffset = sliverListOffset - minScrollOffset;
    }
    positionChild(
        header, Offset(0, math.min(currHeaderOffset, headerMaxOffset)));

    //callback header hide percent
    if (currHeaderOffset >= headerMaxOffset && currHeaderOffset <= height) {
      double switchingPercent =
          (currHeaderOffset - headerMaxOffset) / header.size.height;
      _controller.updatePercent(sectionIndex, switchingPercent);
    } else if (sliverListOffset < minScrollOffset + headerMaxOffset &&
        _controller.switchingSectionIndex == sectionIndex) {
      //ensure callback 0% percent.
      _controller.updatePercent(sectionIndex, 0);
      //reset switchingSectionIndex
      _controller.updatePercent(-1, 1);
    }
  }

  bool get isStickyChild => _listIndex == _stickyIndex;

  int get sectionIndex => separated ? _listIndex ~/ 2 : _listIndex;

  double _getSliverListVisibleScrollOffset() {
    return _renderSliver.constraints.overlap +
        _renderSliver.constraints.scrollOffset;
  }

  void clearContainerLayoutOffsets() {
    _controller.containerOffsets.clear();
  }

  void _refreshContainerLayoutOffsets(String reason) {
    _renderSliver.visitChildren((renderObject) {
      var containerParentData =
          renderObject.parentData as SliverMultiBoxAdaptorParentData;

      while (
          _controller.containerOffsets.length <= containerParentData.index!) {
        _controller.containerOffsets.add(0);
      }
      if (containerParentData.layoutOffset != null) {
        _controller.containerOffsets[containerParentData.index!] =
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

  void checkRefreshContainerOffset() {
    int length = _controller.containerOffsets.length;
    if (_listIndex >= length ||
        (_listIndex > 0 && _controller.containerOffsets[_listIndex]! <= 0)) {
      _refreshContainerLayoutOffsets("zero size");
      return;
    }
    for (int i = 0; i < _listIndex && _listIndex < length - 1; i++) {
      double currOffset = _controller.containerOffsets[i]?.toDouble() ?? 0;
      double nextOffset = _controller.containerOffsets[i + 1]?.toDouble() ?? 0;
      if (currOffset > nextOffset) {
        _refreshContainerLayoutOffsets(
            "offset invalid: $currOffset->$nextOffset");
        break;
      }
    }
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
    Key? key,
    required this.builder,
  }) : super(key: key, delegate: builder.delegate);

  @override
  RenderSliverList createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return RenderExpandableSliverList(childManager: element)
      ..expandStateList = _buildExpandStateList();
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderExpandableSliverList renderObject) {
    var oldRenderList = renderObject.expandStateList;
    renderObject.expandStateList = _buildExpandStateList();
    if (!renderObject.sizeChanged &&
        listEquals(oldRenderList, renderObject.expandStateList)) {
      renderObject.sizeChanged = true;
    }
    super.updateRenderObject(context, renderObject);
  }

  List<bool> _buildExpandStateList() {
    List<ExpandableListSection> sectionList = builder.sectionList;
    return List.generate(
        sectionList.length, (index) => sectionList[index].isSectionExpanded());
  }
}

class RenderExpandableSliverList extends RenderSliverList {
  /// Creates a sliver that places multiple box children in a linear array along
  /// the main axis.
  ///
  /// The [childManager] argument must not be null.
  List<bool> expandStateList = [];
  bool sizeChanged = false;

  RenderExpandableSliverList({
    required RenderSliverBoxChildManager childManager,
  }) : super(childManager: childManager);

  @override
  void performLayout() {
    super.performLayout();
    sizeChanged = false;
  }
}

/// A delegate that supplies children for [SliverExpandableList] using
/// a builder callback.
class SliverExpandableChildDelegate<T, S extends ExpandableListSection<T>> {
  ///data source
  final List<S> sectionList;

  ///build section header
  final ExpandableHeaderBuilder? headerBuilder;

  ///build section item
  final ExpandableItemBuilder itemBuilder;

  ///build header and item separator, if pass null, SliverList has no separators.
  ///default null.
  final ExpandableSeparatorBuilder? separatorBuilder;

  ///whether to sticky the header.
  final bool sticky;

  /// Whether the header should be drawn on top of the content
  /// instead of before.
  final bool overlapsContent;

  ///store section real index in SliverList, format: [sectionList index, SliverList index].
  final List<int> sectionRealIndexes;

  ///use this return a custom content widget, when use this builder, headerBuilder
  ///is invalid.
  /// See also:
  ///
  ///  * <https://github.com/tp7309/flutter_sticky_and_expandable_list/blob/master/example/lib/example_custom_section.dart>,
  ///  a description of what ExpandableSectionBuilder are and how to use it.
  ///
  ExpandableSectionBuilder? sectionBuilder;

  ///expandable list controller, listen sticky header index scroll offset etc.
  ExpandableListController? controller;

  ///sliver list builder
  late SliverChildBuilderDelegate delegate;

  ///if value is true, when section is collapsed, all child widget in section widget will be removed.
  @Deprecated("unused property")
  final bool removeItemsOnCollapsed;

  SliverExpandableChildDelegate(
      {required this.sectionList,
      required this.itemBuilder,
      this.controller,
      this.separatorBuilder,
      this.headerBuilder,
      this.sectionBuilder,
      this.sticky = true,
      this.overlapsContent = false,
      this.removeItemsOnCollapsed = true,
      bool addAutomaticKeepAlives = true,
      bool addRepaintBoundaries = true,
      bool addSemanticIndexes = true})
      : assert(
          (headerBuilder != null && sectionBuilder == null) ||
              (headerBuilder == null && sectionBuilder != null),
          'You must specify either headerBuilder or sectionBuilder.',
        ),
        sectionRealIndexes = _buildSectionRealIndexes(sectionList) {
    controller ??= ExpandableListController();
    if (separatorBuilder == null) {
      delegate = SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          int sectionIndex = index;
          S section = sectionList[sectionIndex];
          int sectionRealIndex = sectionRealIndexes[sectionIndex];

          int sectionChildCount = section.getItems()?.length ?? 0;
          if (!section.isSectionExpanded()) {
            sectionChildCount = 0;
          }
          var childBuilderDelegate = SliverChildBuilderDelegate(
              (context, i) => itemBuilder(
                  context, sectionIndex, i, sectionRealIndex + i + 1),
              childCount: sectionChildCount);
          var containerInfo = ExpandableSectionContainerInfo(
            separated: false,
            listIndex: index,
            sectionIndex: sectionIndex,
            sectionRealIndexes: sectionRealIndexes,
            sticky: sticky,
            overlapsContent: overlapsContent,
            controller: controller!,
            header: Container(),
            content: Container(),
            childDelegate: childBuilderDelegate,
          );
          Widget? container = sectionBuilder != null
              ? sectionBuilder!(context, containerInfo)
              : null;
          if (container == null) {
            containerInfo
              ..header = headerBuilder!(context, sectionIndex, sectionRealIndex)
              ..content = buildDefaultContent(context, containerInfo);
            container = ExpandableSectionContainer(
              info: containerInfo,
            );
          }
          assert(containerInfo.header != null);
          assert(containerInfo.content != null);
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
            if (!section.isSectionExpanded()) {
              sectionChildCount = 0;
            }
            var childBuilderDelegate = SliverChildBuilderDelegate((context, i) {
              int itemRealIndex = sectionRealIndex + (i ~/ 2) + 1;
              if (i.isEven) {
                return itemBuilder(
                    context, sectionIndex, i ~/ 2, itemRealIndex);
              } else {
                return separatorBuilder!(context, false, itemRealIndex);
              }
            }, childCount: sectionChildCount);
            var containerInfo = ExpandableSectionContainerInfo(
              separated: true,
              listIndex: index,
              sectionIndex: sectionIndex,
              sectionRealIndexes: sectionRealIndexes,
              sticky: sticky,
              overlapsContent: overlapsContent,
              controller: controller!,
              header: Container(),
              content: Container(),
              childDelegate: childBuilderDelegate,
            );
            Widget? container = sectionBuilder != null
                ? sectionBuilder!(context, containerInfo)
                : null;
            if (container == null) {
              containerInfo
                ..header =
                    headerBuilder!(context, sectionIndex, sectionRealIndex)
                ..content = buildDefaultContent(context, containerInfo);
              container = ExpandableSectionContainer(
                info: containerInfo,
              );
            }
            assert(containerInfo.header != null);
            assert(containerInfo.content != null);
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

  ///By default, build a Column widget for layout all children's size.
  static Widget buildDefaultContent(
      BuildContext context, ExpandableSectionContainerInfo containerInfo) {
    var childDelegate = containerInfo.childDelegate;
    if (childDelegate != null) {
      var children =
          List<Widget>.generate(childDelegate.childCount ?? 0, (index) {
        return childDelegate.builder(context, index) ?? Container();
      });
      return Column(
        children: children,
      );
    }
    return Container();
  }

  static int _computeSemanticChildCount(int itemCount) {
    return math.max(0, itemCount * 2 - 1);
  }

  static List<int>
      _buildSectionRealIndexes<T, S extends ExpandableListSection<T>>(
          List sectionList) {
    int calcLength = sectionList.length - 1;
    List<int> sectionRealIndexes = List<int>.empty(growable: true);
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
  double _percent = 1.0;
  int _switchingSectionIndex = -1;
  int _stickySectionIndex = -1;

  ExpandableListController();

  ///store [ExpandableSectionContainer] information. [SliverList index, layoutOffset].
  ///don't modify it.
  List<double?> containerOffsets = [];

  double get percent => _percent;

  int get switchingSectionIndex => _switchingSectionIndex;

  ///get pinned header index
  int get stickySectionIndex => _stickySectionIndex;

  updatePercent(int sectionIndex, double percent) {
    if (_percent == percent && _switchingSectionIndex == sectionIndex) {
      return;
    }
    _switchingSectionIndex = sectionIndex;
    _percent = percent;
    notifyListeners();
  }

  set stickySectionIndex(int value) {
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
    return 'ExpandableListController{_percent: $_percent, _switchingSectionIndex: $_switchingSectionIndex, _stickySectionIndex: $_stickySectionIndex} #$hashCode';
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
  int _stickyIndex = 0;

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
  final ExpandableAutoLayoutTrigger trigger;

  ///build section header
  final WidgetBuilder builder;

  const ExpandableAutoLayoutWidget(
      {Key? key, required this.builder, required this.trigger})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExpandableAutoLayoutWidgetState();
}

class _ExpandableAutoLayoutWidgetState
    extends State<ExpandableAutoLayoutWidget> {
  @override
  void initState() {
    super.initState();
    widget.trigger.controller.addListener(_onChange);
  }

  void _onChange() {
    if (widget.trigger.needBuild()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    widget.trigger.controller.removeListener(_onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: widget.builder(context),
    );
  }
}
