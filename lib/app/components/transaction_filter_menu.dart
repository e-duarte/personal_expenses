import 'package:flutter/material.dart';

class TransactionFilterMenu extends StatelessWidget {
  const TransactionFilterMenu({
    super.key,
    required this.data,
    required this.onFilterChanged,
  });

  final Map<String, bool> data;
  final void Function(Map<String, bool>) onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final filterSize = Size(
      MediaQuery.of(context).size.width * 0.5,
      MediaQuery.of(context).size.height * 0.3,
    );

    return PopupMenuButton<MapEntry>(
      constraints: BoxConstraints.tight(filterSize),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      onSelected: (entry) {
        final Map<String, bool> newData = Map.from(data);
        newData[entry.key] = !entry.value;
        onFilterChanged(newData);
      },
      itemBuilder: (context) {
        return data.entries.map((item) {
          return CheckedPopupMenuItem(
            checked: item.value,
            value: item,
            child: Text(
              item.key,
            ),
          );
        }).toList();
      },
    );
  }
}
