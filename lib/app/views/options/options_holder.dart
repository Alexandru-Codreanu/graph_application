import 'package:flutter/material.dart';

class OptionsHolder extends StatelessWidget {
  final Widget child;
  final String title;
  const OptionsHolder({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: SizedBox.fromSize(
        size: const Size.fromWidth(180),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              type: MaterialType.card,
              color: Color.lerp(Colors.white, Colors.blue, 0.5),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      title,
                      style: TextStyle(color: Color.lerp(Colors.black, Colors.blue, 0.5), fontSize: 14),
                    ),
                  ),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
