import 'package:flutter/material.dart';

import 'index_path.dart';
import 'list_Item_type.dart';
import 'list_item.dart';

class GroupSliverListView extends StatefulWidget {
  //The number of sections in the ListView.
  final int sectionCount;

  ///Function which returns the number of items in a section.
  final int Function(int section) itemInSectionCount;

  ///Function which returns an Widget which defines the section header for each group.
  final Widget? Function(int section)? headerForSectionBuilder;

  ///Function which returns an Widget which defines the separator at the specified section.
  ///
  /// Separators only appear between sections: separator 0 appears after section
  /// 0 and the last separator appears after the last section.
  ///
  ///[sectionSeparatorBuilder] provides the current section.
  final Widget? Function(int section)? sectionSeparatorBuilder;

  ///Function which returns an Widget which defines the item at the specified IndexPath.
  ///
  ///[itemInSectionBuilder] provides the current section and index.
  final Widget Function(BuildContext context, IndexPath indexPath) itemInSectionBuilder;

  ///Function which returns an Widget which defines the separator at the specified IndexPath.
  ///
  /// Separators only appear between list items: separator 0 appears after item
  /// 0 and the last separator appears after the last item.
  ///
  ///[separatorBuilder] provides the current section and index.
  final Widget? Function(IndexPath indexPath)? separatorBuilder;

  ///Function which returns an Widget which defines the section footer for each group.
  final Widget? Function(int section)? footerForSectionBuilder;

  /// {@template flutter.widgets.SliverChildBuilderDelegate.findChildIndexCallback}
  /// Called to find the new index of a child based on its key in case of reordering.
  ///
  /// If not provided, a child widget may not map to its existing [RenderObject]
  /// when the order of children returned from the children builder changes.
  /// This may result in state-loss.
  ///
  /// This callback should take an input [Key], and it should return the
  /// index of the child element with that associated key, or null if not found.
  /// {@endtemplate}
  final ChildIndexGetter? findChildIndexCallback;

  /// {@template flutter.widgets.SliverChildBuilderDelegate.addAutomaticKeepAlives}
  /// Whether to wrap each child in an [AutomaticKeepAlive].
  ///
  /// Typically, children in lazy list are wrapped in [AutomaticKeepAlive]
  /// widgets so that children can use [KeepAliveNotification]s to preserve
  /// their state when they would otherwise be garbage collected off-screen.
  ///
  /// This feature (and [addRepaintBoundaries]) must be disabled if the children
  /// are going to manually maintain their [KeepAlive] state. It may also be
  /// more efficient to disable this feature if it is known ahead of time that
  /// none of the children will ever try to keep themselves alive.
  ///
  /// Defaults to true.
  /// {@endtemplate}
  final bool addAutomaticKeepAlives;

  /// {@template flutter.widgets.SliverChildBuilderDelegate.addRepaintBoundaries}
  /// Whether to wrap each child in a [RepaintBoundary].
  ///
  /// Typically, children in a scrolling container are wrapped in repaint
  /// boundaries so that they do not need to be repainted as the list scrolls.
  /// If the children are easy to repaint (e.g., solid color blocks or a short
  /// snippet of text), it might be more efficient to not add a repaint boundary
  /// and instead always repaint the children during scrolling.
  ///
  /// Defaults to true.
  /// {@endtemplate}
  final bool addRepaintBoundaries;

  /// {@template flutter.widgets.SliverChildBuilderDelegate.addSemanticIndexes}
  /// Whether to wrap each child in an [IndexedSemantics].
  ///
  /// Typically, children in a scrolling container must be annotated with a
  /// semantic index in order to generate the correct accessibility
  /// announcements. This should only be set to false if the indexes have
  /// already been provided by an [IndexedSemantics] widget.
  ///
  /// Defaults to true.
  ///
  /// See also:
  ///
  ///  * [IndexedSemantics], for an explanation of how to manually
  ///    provide semantic indexes.
  /// {@endtemplate}
  final bool addSemanticIndexes;

  const GroupSliverListView(
      {required this.sectionCount,
      required this.itemInSectionCount,
      required this.itemInSectionBuilder,
      required this.headerForSectionBuilder,
      this.separatorBuilder,
      this.sectionSeparatorBuilder,
      this.footerForSectionBuilder,
      this.findChildIndexCallback,
      this.addAutomaticKeepAlives = true,
      this.addRepaintBoundaries = true,
      this.addSemanticIndexes = true,
      super.key});

  @override
  State<StatefulWidget> createState() => _GroupSliverListViewState();
}

class _GroupSliverListViewState extends State<GroupSliverListView> {
  late List<ListItem> _indexToIndexPathList;

  @override
  void initState() {
    _indexToIndexPathList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _calcIndexPath();
    return SliverList.builder(
        findChildIndexCallback: widget.findChildIndexCallback,
        addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
        addRepaintBoundaries: widget.addRepaintBoundaries,
        addSemanticIndexes: widget.addSemanticIndexes,
        itemCount: _indexToIndexPathList.length,
        itemBuilder: _itemBuilder);
  }

  Widget? _itemBuilder(BuildContext context, int index) {
    final ListItem listItem = _indexToIndexPathList[index];
    final IndexPath indexPath = listItem.indexPath;
    if (listItem.type.isSectionHeader) {
      return widget.headerForSectionBuilder!(indexPath.section);
    } else if (listItem.type.isSectionSeparator) {
      return widget.sectionSeparatorBuilder!(indexPath.section);
    } else if (listItem.type.isItemSeparator) {
      return widget.separatorBuilder!(indexPath);
    } else if (listItem.type.isSectionFooter) {
      return widget.footerForSectionBuilder!(indexPath.section);
    }
    return widget.itemInSectionBuilder(context, indexPath);
  }

  void _calcIndexPath() {
    _indexToIndexPathList = [];
    ListItem listItem;
    for (int section = 0; section < widget.sectionCount; section++) {
      listItem = ListItem(indexPath: IndexPath(section: section, index: 0), type: ListItemType.sectionHeader);
      _indexToIndexPathList.add(listItem);

      final int itemCountInSection = widget.itemInSectionCount(section);
      for (int index = 0; index < itemCountInSection; index++) {
        listItem = ListItem(indexPath: IndexPath(section: section, index: index), type: ListItemType.item);
        _indexToIndexPathList.add(listItem);

        if (widget.separatorBuilder != null) {
          listItem = ListItem(indexPath: IndexPath(section: section, index: index), type: ListItemType.itemSeparator);
          _indexToIndexPathList.add(listItem);
        }
      }

      if (widget.footerForSectionBuilder != null) {
        listItem = ListItem(indexPath: IndexPath(section: section, index: 0), type: ListItemType.sectionFooter);
        _indexToIndexPathList.add(listItem);
      }

      if (widget.sectionSeparatorBuilder != null) {
        listItem = ListItem(indexPath: IndexPath(section: section, index: 0), type: ListItemType.sectionSeparator);
        _indexToIndexPathList.add(listItem);
      }
    }
  }
}
