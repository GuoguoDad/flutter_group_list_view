enum ListItemType { sectionHeader, itemSeparator, sectionSeparator, item, sectionFooter }

extension PageTypeExtension on ListItemType {
  /// is the item ?
  bool get isItem => this == ListItemType.item;

  /// is the header ?
  bool get isSectionHeader => this == ListItemType.sectionHeader;

  /// is the item separator ?
  bool get isItemSeparator => this == ListItemType.itemSeparator;

  /// is the section separator ?
  bool get isSectionSeparator => this == ListItemType.sectionSeparator;

  /// is the footer ?
  bool get isSectionFooter => this == ListItemType.sectionFooter;
}
