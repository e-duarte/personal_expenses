class Tag {
  final int? id;
  final String tag;
  final String iconPath;
  final String color;

  Tag({
    this.id,
    required this.tag,
    required this.iconPath,
    required this.color,
  });

  factory Tag.fromMap(Map<String, Object?> data) {
    return Tag(
      id: data['id'] as int,
      tag: data['tag'] as String,
      iconPath: data['iconPath'] as String,
      color: data['color'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'tag': tag,
      'iconPath': iconPath,
      'color': color,
    };
  }

  Tag copyWith({
    int? id,
    String? tag,
    String? iconPath,
    String? color,
  }) {
    return Tag(
      id: id ?? this.id,
      tag: tag ?? this.tag,
      iconPath: iconPath ?? this.iconPath,
      color: color ?? this.color,
    );
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
