class IndexPath {
  /// The Class that contains the [section] number
  /// and the [index] number in this section.
  const IndexPath({required this.section, required this.index});

  /// The the index of the section.
  final int section;

  /// The the index of the item in the [section].
  final int index;
}
