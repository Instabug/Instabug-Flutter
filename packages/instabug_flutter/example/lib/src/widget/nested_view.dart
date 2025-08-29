import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter_example/main.dart';

class NestedView extends StatelessWidget {
  final int depth;
  final int breadth;
  final Widget? child;

  const NestedView({
    Key? key,
    this.depth = ComplexPage.initialDepth,
    this.breadth = ComplexPage.initialDepth,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (depth == 0) {
      return child ?? const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      padding: const EdgeInsets.all(1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$depth'),
          Row(
            children: List.generate(
              breadth,
              (index) => InstabugPrivateView(
                child: NestedView(
                  depth: depth - 1,
                  breadth: breadth,
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
