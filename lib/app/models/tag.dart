class Tag {
  final int? id;
  final String tag;
  final String iconPath;

  Tag({
    this.id,
    required this.tag,
    required this.iconPath,
  });

  factory Tag.fromMap(Map<String, Object?> data) {
    return Tag(
      id: data['id'] as int,
      tag: data['tag'] as String,
      iconPath: data['iconPath'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'tag': tag,
      'iconPath': iconPath,
    };
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
