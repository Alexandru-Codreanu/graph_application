import 'package:flutter/material.dart';
import '../../controllers/graph_controller.dart';
import 'options_holder.dart';
import 'simple_option_button.dart';

class FirstNodeSelectedIndicator extends StatefulWidget {
  final GraphController controller;

  const FirstNodeSelectedIndicator({
    super.key,
    required this.controller,
  });

  @override
  State<FirstNodeSelectedIndicator> createState() => _FirstNodeSelectedIndicatorState();
}

class _FirstNodeSelectedIndicatorState extends State<FirstNodeSelectedIndicator> {
  @override
  Widget build(BuildContext context) {
    return OptionsHolder(
      title: "First Node In Arc Selected",
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ValueListenableBuilder(
          valueListenable: widget.controller.firstNodeInArchSelectedNotifier,
          builder: (context, value, child) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    value <= -1 ? Icons.circle_outlined : Icons.check_circle_outline_sharp,
                    color: value <= -1 ? Colors.purple : Colors.teal,
                  ),
                  Text(
                    value <= -1 ? "No node selected..." : "Node $value was selected!",
                    style: TextStyle(
                      color: value <= -1 ? Colors.purple : Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SimpleOptionButton(
                  icon: Icons.remove_circle_outline,
                  label: "Deselect node",
                  onTap: value <= -1
                      ? null
                      : () {
                          widget.controller.firstNodeInArchSelected = -1;
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
