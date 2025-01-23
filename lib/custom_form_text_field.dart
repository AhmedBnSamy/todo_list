
import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  const CustomFormTextField({
    super.key,
    required this.maxLines,
    required this.hintText,
    required this.controller,
    this.labelText,
  });

  final int maxLines;
  final String hintText;
  final TextEditingController? controller;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: hintText,
        fillColor: Colors.grey.shade100,
        filled: true,
        alignLabelWithHint: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}
