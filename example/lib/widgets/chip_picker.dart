import 'package:flutter/material.dart';

typedef LabelBuilder<T> = String Function(T value);

class ChipPicker<T> extends StatelessWidget {
  final LabelBuilder<T> labelBuilder;
  final Set<T> items;
  final Set<T> values;
  final ValueChanged<Set<T>> onChanged;

  const ChipPicker({
    super.key,
    required this.labelBuilder,
    required this.items,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4.0,
      children: items
          .map(
            (item) => FilterChip(
              label: Text(
                labelBuilder(item),
              ),
              selected: values.contains(item),
              onSelected: (selected) {
                if (selected) {
                  values.add(item);
                } else {
                  values.remove(item);
                }
                onChanged(values);
              },
            ),
          )
          .toList(),
    );
  }
}
