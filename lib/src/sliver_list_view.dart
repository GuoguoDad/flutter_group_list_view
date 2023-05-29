import 'package:flutter/material.dart';

import 'index_path.dart';
import 'list_Item_type.dart';
import 'list_item.dart';

class GroupSliverListView extends StatefulWidget {
  final int sectionCount;
  final int Function(int section) itemInSectionCount;
  final Widget? Function(int section)? headerForSectionBuilder;
  final Widget? Function(int section)? sectionSeparatorBuilder;
  final Widget Function(BuildContext context, IndexPath indexPath) itemInSectionBuilder;
  final Widget? Function(IndexPath indexPath)? separatorBuilder;
  final Widget? Function(int section)? footerForSectionBuilder;

  final ChildIndexGetter? findChildIndexCallback;

  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
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
