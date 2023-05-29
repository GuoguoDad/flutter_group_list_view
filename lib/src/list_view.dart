import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_group_list_view/src/list_Item_type.dart';

import 'index_path.dart';
import 'list_item.dart';

class GroupListView extends StatefulWidget {
  final int sectionCount;
  final int Function(int section) itemInSectionCount;
  final Widget Function(int section)? headerForSectionBuilder;
  final Widget? Function(int section)? sectionSeparatorBuilder;
  final Widget Function(BuildContext context, IndexPath indexPath) itemInSectionBuilder;
  final Widget? Function(IndexPath indexPath)? separatorBuilder;
  final Widget? Function(int section)? footerForSectionBuilder;

  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final double? itemExtent;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;

  const GroupListView(
      {required this.sectionCount,
      required this.itemInSectionCount,
      required this.itemInSectionBuilder,
      required this.headerForSectionBuilder,
      this.footerForSectionBuilder,
      this.separatorBuilder,
      this.sectionSeparatorBuilder,
      this.scrollDirection = Axis.vertical,
      this.reverse = false,
      this.controller,
      this.primary,
      this.physics,
      this.shrinkWrap = false,
      this.padding,
      this.itemExtent,
      this.addAutomaticKeepAlives = true,
      this.addRepaintBoundaries = true,
      this.addSemanticIndexes = true,
      this.cacheExtent,
      this.semanticChildCount,
      this.dragStartBehavior = DragStartBehavior.start,
      super.key});

  @override
  _GroupListViewState createState() => _GroupListViewState();
}

class _GroupListViewState extends State<GroupListView> {
  late List<ListItem> _indexToIndexPathList;

  @override
  void initState() {
    _indexToIndexPathList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _calcIndexPath();
    return ListView.builder(
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      itemExtent: widget.itemExtent,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addSemanticIndexes: widget.addSemanticIndexes,
      cacheExtent: widget.cacheExtent,
      semanticChildCount: widget.semanticChildCount,
      dragStartBehavior: widget.dragStartBehavior,
      itemCount: _indexToIndexPathList.length,
      itemBuilder: _itemBuilder,
    );
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
}
