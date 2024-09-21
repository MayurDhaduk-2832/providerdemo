import 'package:flutter/material.dart';
import 'package:oneqlik/utils/colors.dart';

class SimpleElevatedButton extends StatelessWidget {
  VoidCallback onPressed;
  String buttonName;
  Color color;
  TextStyle style;
  Size fixedSize;
  OutlinedBorder shape;
  ButtonStyle Elevatedstyle;
  SimpleElevatedButton(
      {Key key, this.onPressed, this.buttonName, this.color, this.style,this.Elevatedstyle,this.fixedSize,this.shape})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(
          buttonName,
          textAlign: TextAlign.center,
          style: style,
        ),
        style: ElevatedButton.styleFrom(
          shape: shape,
          fixedSize: fixedSize,
          padding: EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 0),
          primary: color ?? ApplicationColors.redColor67,
        ));
  }
}

