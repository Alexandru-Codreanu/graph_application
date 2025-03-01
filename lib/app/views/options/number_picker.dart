import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberPicker extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const NumberPicker({
    super.key,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 30,
      color: Colors.transparent,
      child: TextField(
        controller: controller,
        showCursor: false,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hint,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
          TextInputFormatter.withFunction(
            (oldValue, newValue) {
              final newText = newValue.text;
              if ('.'.allMatches(newText).length <= 1) {
                return newValue;
              }
              return oldValue;
            },
          ),
        ],
        keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }
}
