import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../const/style.dart';

class CustomTextFormField extends StatefulWidget {
  final funValidator;
  final funOnChange;
  final funOnTap;
  final TextEditingController? controller;
  final String hintText;
  final EdgeInsetsGeometry padding;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  const CustomTextFormField({
    Key? key,
    required this.funValidator,
    this.controller,
    this.padding = const EdgeInsets.all(0),
    this.funOnChange,
    this.funOnTap,
    this.keyboardType = TextInputType.number,
    this.textInputAction = TextInputAction.next,
    this.hintText = "",
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: TextFormField(
        style: TextStyle(fontSize: 12),
        onTap: widget.funOnTap,
        controller: widget.controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.funValidator,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          hintText: widget.hintText,
        ),
        onChanged: widget.funOnChange,
      ),
    );
  }
}
