import 'package:flutter/material.dart';
import 'package:personal_expenses/app/components/tag_leading.dart';
import 'package:personal_expenses/app/models/tag.dart';

class TagsRadioButton extends StatelessWidget {
  const TagsRadioButton({
    super.key,
    required this.tags,
    required this.initialTag,
    required this.onChanged,
  });

  final List<Tag> tags;
  final Tag initialTag;
  final void Function(Tag) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.1,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => onChanged(tags[index]),
                child: TagLeading(
                  tags[index],
                  color: initialTag.tag == tags[index].tag
                      ? Theme.of(context).colorScheme.primary
                      : tags[index].color,
                ),
              ),
              initialTag.tag != tags[index].tag
                  ? Text(tags[index].tag)
                  : Text(
                      tags[index].tag,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          width: 20,
        ),
      ),
    );
  }
}
