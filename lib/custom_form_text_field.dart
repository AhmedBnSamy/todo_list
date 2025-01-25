import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/themdata_cubit.dart';

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
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, theme) {
        return TextFormField(
          style: theme == AppTheme.light ? const TextStyle(color: Colors.black,fontWeight: FontWeight.bold) : const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            focusColor: theme == AppTheme.light ? Colors.red : Colors.blueAccent,
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
                color: theme == AppTheme.light ? Colors.red : Colors.blueAccent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
                color: theme == AppTheme.light ? Colors.red : Colors.blueAccent,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: theme == AppTheme.light ? Colors.red : Colors.blueAccent,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: theme == AppTheme.light ? Colors.black : Colors.white,
            ),
            labelText: labelText,
            labelStyle: TextStyle(
              color: theme == AppTheme.light ? Colors.black : Colors.white,
            ),
            fillColor: theme == AppTheme.light ? Colors.white : Colors.black,
            filled: true,
            alignLabelWithHint: true,

            contentPadding: const EdgeInsets.all(20),
          ),
        );
      },
    );
  }
}