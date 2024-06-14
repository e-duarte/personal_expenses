import 'package:flutter/material.dart';

class TagLeading extends StatelessWidget {
  const TagLeading(this.tagPath, this.color, {super.key});
  final String tagPath;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 26,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(
          tagPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
