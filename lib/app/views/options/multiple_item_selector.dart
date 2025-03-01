import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/mode_enum.dart';

class MultipleItemSelector extends StatelessWidget {
  final ValueListenable<InteractionMode> listenable;
  final void Function(InteractionMode value) onChange;

  const MultipleItemSelector({
    super.key,
    required this.listenable,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size(180, 90),
      child: ValueListenableBuilder(
        valueListenable: listenable,
        builder: (context, value, child) => Column(
          children: InteractionMode.values
              .map(
                (element) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.5),
                  child: MouseRegion(
                    cursor: element == value ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
                    child: IgnorePointer(
                      ignoring: element == value,
                      child: Material(
                        color: element == value
                            ? Color.lerp(Colors.blueGrey, Colors.blue, 0.5)?.withValues(alpha: 0.5)
                            : Color.lerp(Colors.white, Colors.blue, 0.75),
                        child: InkWell(
                          onTap: () {
                            onChange.call(element);
                          },
                          child: Container(
                            width: 100,
                            height: 25,
                            color: Colors.transparent,
                            child: Center(
                              child: Text(
                                element.label,
                                style: TextStyle(
                                  color: element == value ? Color.lerp(Colors.black, Colors.blue, 0.25) : Color.lerp(Colors.black, Colors.blue, 0.5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
