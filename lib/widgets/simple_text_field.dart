import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';

class SimpleTextField extends StatelessWidget {



  TextEditingController controller;
  String hintText;
  TextAlign textAlign;
  Widget suffixIcon;
  Color fillColor;
  Color borderColor;
  TextStyle hintStyle;
  final Function onTap;
  int maxLine;
  Function(String) validator;
  Function(String) onChange;
  TextInputType keyboardType;
  bool obscureText;
  bool readOnly;
  List<TextInputFormatter> inputFormatter;

  SimpleTextField({
    Key key,
    this.controller,
    this.hintText,
    this.validator,
    this.textAlign,
    this.fillColor,
    this.borderColor,
    this.hintStyle,
    this.maxLine,
    this.onChange,
    this.onTap,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText,
    this.readOnly = false,
    this.inputFormatter,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
        inputFormatters: inputFormatter,
      validator: validator,
      keyboardType: keyboardType,
        style: FontStyleUtilities.s14(fontweight: FWT.light,fontColor: ApplicationColors.black4240,fontFamily: "Poppins-Regular"),
        autocorrect: true,
        maxLines: maxLine,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: FontStyleUtilities.h14(
            fontColor: ApplicationColors.black4240,
            fontFamily: "Poppins-Regular",
          ),
        )
    );
  }
}
