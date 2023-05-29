enum ListItemType { sectionHeader, itemSeparator, sectionSeparator, item, sectionFooter }

extension PageTypeExtension on ListItemType {
  bool get isItem => this == ListItemType.item;

  bool get isSectionHeader => this == ListItemType.sectionHeader;

  bool get isItemSeparator => this == ListItemType.itemSeparator;

  bool get isSectionSeparator => this == ListItemType.sectionSeparator;

  bool get isSectionFooter => this == ListItemType.sectionFooter;
}
