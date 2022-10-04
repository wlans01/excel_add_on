import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../const/style.dart';

class CustomTextFormField extends StatefulWidget {
  final funValidator;
  final funOnChange;
  final funOnTap;
  final TextEditingController? controller;
  final bool isobscure;
  final String labelText;
  final bool ishelpertext;
  final bool enabled;
  final String helperText;
  final String hintText;
  final EdgeInsetsGeometry padding;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Widget? suffix;

  const CustomTextFormField({
    Key? key,
    required this.funValidator,
    required this.labelText,
    this.controller,
    this.isobscure = false,
    this.padding = const EdgeInsets.all(0),
    this.funOnChange,
    this.funOnTap,
    this.keyboardType = TextInputType.number,
    this.textInputAction = TextInputAction.next,
    this.ishelpertext = false,
    this.enabled = true,
    this.helperText = "",
    this.hintText = "",
    this.suffix,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            style: TextStyle(fontSize: 12),
            onTap: widget.funOnTap,
            controller: widget.controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: widget.isobscure ? !_obscureText : false,
            validator: widget.funValidator,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            enabled: widget.enabled,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]'))
            ],
            decoration: InputDecoration(

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              fillColor: gray010,
              filled: true,
              suffixStyle: const TextStyle(color: Colors.black87, fontSize: 12),
              suffixIcon: widget.isobscure
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black87,
                      ),
                    )
                  : widget.suffix,
              hintText: widget.hintText,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: primaryColor,
                ),
              ),
            ),
            onChanged: widget.funOnChange,
          ),
        ],
      ),
    );
  }
}
