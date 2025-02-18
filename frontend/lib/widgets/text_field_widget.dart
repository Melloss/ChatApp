import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String? text)? validator;
  final Widget? suffix;
  final Widget? prefix;
  final Function()? onTab;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool enableFocusColor;
  final String? prefixText;
  final bool obscurePassword;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final FocusNode? focusNode;
  final Key? globalKey;
  final Function(String)? onChanged;
  final BorderRadius? borderRadius;
  final double? fontSize;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final bool? autoFocus;
  final TextStyle? hintTextStyle;
  final int? maxLine;
  final bool autoUnfocus;
  final Function(String text)? onFieldSubmitted;

  const TextFieldWidget({
    super.key,
    required this.controller,
    this.globalKey,
    this.validator,
    this.hintText,
    this.suffix,
    this.prefix,
    this.onTab,
    this.keyboardType,
    this.readOnly = false,
    this.prefixText,
    this.enableFocusColor = true,
    this.obscurePassword = false,
    this.inputFormatters,
    this.focusNode,
    this.onChanged,
    this.borderRadius,
    this.fontSize,
    this.contentPadding,
    this.border,
    this.autoFocus,
    this.maxLine,
    this.hintTextStyle,
    this.onFieldSubmitted,
    this.errorText,
    this.autoUnfocus = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: globalKey,
      autofocus: autoFocus ?? false,
      focusNode: focusNode,
      onTap: onTab,
      onFieldSubmitted: onFieldSubmitted,
      onTapOutside: (p) {
        if (autoUnfocus) {
          FocusScope.of(context).unfocus();
        }
      },
      maxLines: maxLine ?? 1,
      onChanged: onChanged,
      obscureText: obscurePassword,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      readOnly: readOnly,
      cursorColor: Colors.brown,
      style: TextStyle(
        fontSize: fontSize ?? 15,
        fontWeight: FontWeight.w500,
      ),
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        errorText: errorText,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintText: hintText,
        hintStyle: hintTextStyle ??
            TextStyle(
              fontSize: fontSize ?? 16,
              color: const Color(0xFF8E8E8E),
              fontWeight: FontWeight.w400,
            ),
        prefixText: prefixText != null ? '$prefixText ' : null,
        prefixIcon: prefix,
        suffixIcon: suffix,
        prefixStyle: TextStyle(
          fontSize: fontSize ?? 15,
          fontWeight: FontWeight.w500,
        ),
        border: border ??
            OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(12),
            ),
        focusedBorder: border ??
            OutlineInputBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(12),
              borderSide: enableFocusColor
                  ? const BorderSide(
                      color: Colors.brown,
                      width: 2,
                    )
                  : const BorderSide(),
            ),
      ),
    );
  }
}
