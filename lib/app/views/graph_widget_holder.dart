import 'package:flutter/material.dart';
import '../controllers/graph_controller.dart';

import 'graph_widget.dart';

class GraphWidgetHolder extends StatelessWidget {
  final GraphController controller;
  const GraphWidgetHolder({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(75),
              topRight: Radius.circular(25),
              bottomRight: Radius.circular(75),
              bottomLeft: Radius.circular(25),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: GraphWidget(controller: controller),
          ),
        ),
        ListenableBuilder(
          listenable: controller.isLoadingNotifier,
          builder: (context, child) {
            if (!controller.isLoading) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(75),
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(75),
                  bottomLeft: Radius.circular(25),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Material(
                  color: Color.lerp(Colors.black, Colors.grey, 0.5)?.withValues(alpha: 0.75),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
