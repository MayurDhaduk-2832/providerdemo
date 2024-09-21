import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';


class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  TextAlign textAlign;
  Widget suffixIcon;
  Color fillColor;
  Color borderColor;
  Color focusedBorder;
  Color color;
  TextStyle hintStyle;
  final Function onTap;
  int maxLine;
  Function(String) validator;
  Function(String) onChange;
  TextInputType keyboardType;
  bool obscureText;
  bool readOnly;
  bool filled;
  EdgeInsetsGeometry contentPadding;
  List<TextInputFormatter> inputFormatter;

  CustomTextField({
    Key key,
    this.controller,
    this.hintText,
    this.textAlign,
    this.fillColor,
    this.borderColor,
    this.focusedBorder,
    this.hintStyle,
    this.maxLine,
    this.color,
    this.onChange,
    this.onTap,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.obscureText,
    this.readOnly,
    this.inputFormatter,
    this.contentPadding,
    this.filled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatter,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      maxLines: maxLine ?? 1,
      textAlign: textAlign ?? TextAlign.center,
      controller: controller,
      readOnly: readOnly ?? false,
      onChanged: onChange,
      onTap: onTap,
      style: TextStyle(color: ApplicationColors.black4240,fontFamily: "Poppins-Regular"),
      decoration: InputDecoration(
        contentPadding: contentPadding,
        isDense: true,
        suffixIcon: suffixIcon,
        // fillColor: fillColor ?? ApplicationColors.textFielfForegroundColor,
        filled: filled,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusedBorder ?? ApplicationColors.redColor67.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(5)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: borderColor ?? ApplicationColors.redColor67,width: 1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ApplicationColors.redColor67),
            borderRadius: BorderRadius.circular(5)),
        hintText: hintText,
        errorStyle: FontStyleUtilities.h12(
          fontColor: ApplicationColors.redColor,
        ),
        hintStyle: hintStyle ??
            FontStyleUtilities.h12(fontColor: ApplicationColors.whiteColor,fontFamily: "Poppins-Regular"),
      ),
      validator: validator,
    );
  }
}
