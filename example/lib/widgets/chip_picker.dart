import 'package:flutter/material.dart';

typedef LabelBuilder<T> = String Function(T value);

class ChipPicker<T> extends StatefulWidget {
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
  _ChipPickerState<T> createState() => _ChipPickerState<T>();
}

class _ChipPickerState<T> extends State<ChipPicker<T>> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4.0,
      children: widget.items
          .map(
            (item) => FilterChip(
              label: Text(
                widget.labelBuilder(item),
              ),
              selected: widget.values.contains(item),
              onSelected: (selected) {
                if (selected) {
                  widget.values.add(item);
                } else {
                  widget.values.remove(item);
                }
                widget.onChanged(widget.values);
              },
            ),
          )
          .toList(),
    );
  }
}
