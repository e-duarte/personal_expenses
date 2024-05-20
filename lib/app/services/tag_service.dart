import 'package:personal_expenses/app/models/tag.dart';
import 'package:personal_expenses/app/utils/db_utils.dart';

class TagService {
  static const table = 'tags';

  Future<void> insertTag(Tag tag) async {
    await DbUtils.insertData(table, tag.toMap());
  }

  Future<List<Tag>> getTags() async {
    final tagMaps = await DbUtils.listData(table);
    return tagMaps.map((tr) => Tag.fromMap(tr)).toList();
  }

  Future<Tag> getTag(int id) async {
    final tagMap = await DbUtils.fetchById(table, id);
    return Tag.fromMap(tagMap);
  }
}
