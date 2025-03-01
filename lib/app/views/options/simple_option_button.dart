import 'package:flutter/material.dart';

class SimpleOptionButton extends StatefulWidget {
  final void Function()? onTap;
  final IconData icon;
  final String label;
  const SimpleOptionButton({
    super.key,
    this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  State<SimpleOptionButton> createState() => _SimpleOptionButtonState();
}

class _SimpleOptionButtonState extends State<SimpleOptionButton> {
  @override
  Widget build(BuildContext context) {
    bool hasFunction = widget.onTap != null;
    return MouseRegion(
      cursor: hasFunction ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      child: IgnorePointer(
        ignoring: !hasFunction,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 160,
            height: 30,
            color: Colors.transparent,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2.5),
                  child: Icon(
                    widget.icon,
                    color: Color.lerp(Colors.black, Colors.blue, 0.5)?.withValues(alpha: hasFunction ? 1.0 : 0.5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7.5),
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: Color.lerp(Colors.black, Colors.blue, 0.5)?.withValues(alpha: hasFunction ? 1.0 : 0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
