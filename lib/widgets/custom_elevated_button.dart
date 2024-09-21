import 'package:flutter/material.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';

class CustomElevatedButton extends StatelessWidget {
  VoidCallback onPressed;
  String buttonText;
  Color buttonColor;
  CustomElevatedButton(
      {Key key, this.onPressed, this.buttonText, this.buttonColor})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: FontStyleUtilities.hW14(
            fontColor: ApplicationColors.whiteColor ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(_screenSize.width, 48),
        // padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        maximumSize: _screenSize,
        primary: buttonColor ?? ApplicationColors.redColor67,
      ),
    );
  }
}