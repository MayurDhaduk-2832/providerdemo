import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oneqlik/utils/colors.dart';

var textStyle = TextStyle(fontFamily: "IBM Plex Sans");

var fieldStyle = InputDecoration(
  filled: true,
  isDense: true,
  fillColor: ApplicationColors.whiteColor,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: ApplicationColors.dropdownColor3D,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Appcolors.text_violet,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
    ),
  ),
);

class Appcolors {
  static const Color blue = Color(0xff111827);

  //static const Color text_white = Color(0xffFFFFFF);
  static const Color text_white = Color(0xffbb002d);
  static const Color text_grey = Color(0xff9CA3AF);
  static const Color button_text_black = Color(0xff111827);
  static const Color button_white = Color(0xffFFFFFF);
  static const Color button_grey = Color(0xff4B5563);
  static const Color button_text_white = Color(0xffFFFFFF);
  static const Color button_blue = Color(0xff1877F2);
  static const Color text_violet = Color(0xff6a40f3);
  static const Color button_black = Color(0xff1c2431);
  static const Color background_blue = Color(0xff111827);
  static const Color background_blue1 = Color(0xff1C2431);
  static const Color profile_black = Color(0xff111827);

  static const Color signupButtoncolor = Color(0xff1C2431);
  static const Color signupButtonbordercolor = Color(0xff374151);
  static const Color orange = Color(0xffF24A4A);
  static const Color sky = Color(0xff7FE3F0);
  static const Color skgradiant = Color(0xff8C80F8);
  static const Color appbarcolor = Color(0xffFFFFFF);
  static const Color backgroundwhite = Color(0xffFFFFFF);
  static const Color textfieldColot = Color(0xffF8FAFC);
  static const Color textfieldTextColot = Color(0xff3B4256);
  static const Color signupsubmitButton = Color(0xff0048D9);
  static const Color signupsubmitButtontextcolor = Color(0xffFFFFFF);
  static const Color appbartextcolor = Color(0xff586472);
  static const Color signupheadertextcolor = Color(0xff586472);
  static const Color signuptextcolor = Color(0xff6F7482);
  static const Color violet = Color(0xffA31294);
  static const Color yellow = Color(0xffE8AD21);
  static const Color sky1 = Color(0xff1DB3CE);
  static const Color purple = Color(0xff8F3BFB);
}

class Textstyle1 {
  static const TextStyle appbartextstyle = TextStyle(
      fontSize: 18,
      fontFamily: 'IBMPlexSans-Regular',
      color: Appcolors.appbartextcolor);
  static const TextStyle appbartextstyle1 = TextStyle(
      //color: Appcolors.text_white
      fontSize: 18,
      fontFamily: 'Poppins-Bold',
      color: Appcolors.text_white);
  static const TextStyle signupheadingText = TextStyle(
      fontSize: 25,
      fontFamily: 'IBMPlexSans-Regular',
      color: Appcolors.signupheadertextcolor);
  static const TextStyle signupText = TextStyle(
      fontSize: 14,
      fontFamily: 'IBMPlexSans-Regular',
      color: Appcolors.signuptextcolor);
  static const TextStyle signupText1 = TextStyle(
      fontSize: 12, fontFamily: 'IBMPlexSans-Regular', color: Colors.black);
  static const TextStyle text10 = TextStyle(
      fontSize: 10, fontFamily: 'Poppins-Regular', color: Colors.black);
  static const TextStyle text10white = TextStyle(
      fontSize: 10, fontFamily: 'Poppins-Regular', color: Colors.white);
  static const TextStyle textb10 =
      TextStyle(fontSize: 10, fontFamily: 'Poppins-Bold', color: Colors.white);
  static const TextStyle text11 = TextStyle(
      fontSize: 11, fontFamily: 'Poppins-Regular', color: Colors.black);
  static const TextStyle text11white = TextStyle(
      fontSize: 11, fontFamily: 'Poppins-Regular', color: Colors.white);
  static const TextStyle text12 = TextStyle(
      fontSize: 12, fontFamily: 'Poppins-Regular', color: Colors.white);
  static const TextStyle text12b = TextStyle(
      fontSize: 12, fontFamily: 'Poppins-Regular', color: Colors.black);
  static const TextStyle texts12 = TextStyle(
      fontSize: 12, fontFamily: 'Poppins-SemiBold', color: Colors.white);
  static const TextStyle text12black = TextStyle(
      fontSize: 12,
      fontFamily: 'Poppins-Regular',
      color: ApplicationColors.blackColor2E);
  static const TextStyle text14 = TextStyle(
      fontSize: 14, fontFamily: 'Poppins-Regular', color: Colors.black);
  static const TextStyle text14bold =
      TextStyle(fontSize: 14, fontFamily: 'Poppins-Bold', color: Colors.black);
  static const TextStyle text14boldwhite =
      TextStyle(fontSize: 14, fontFamily: 'Poppins-Bold', color: Colors.white);
  static const TextStyle text18 = TextStyle(
      fontSize: 18, fontFamily: 'Poppins-Regular', color: Colors.black);
  static const TextStyle text18boldwhite =
      TextStyle(fontSize: 18, fontFamily: 'Poppins-Bold', color: Colors.white);
  static const TextStyle text18bold =
      TextStyle(fontSize: 18, fontFamily: 'Poppins-Bold', color: Colors.black);
  static const TextStyle text18boldBlack =
      TextStyle(fontSize: 18, fontFamily: 'Poppins-Bold', color: Colors.black);
  static const TextStyle text12bold =
      TextStyle(fontSize: 12, fontFamily: 'Poppins-Bold', color: Colors.white);
  static const TextStyle text13bold = TextStyle(
      //Colors.pink
      fontSize: 18,
      fontFamily: 'Poppins-Bold',
      color: Color(0xffbb002d));
  static const TextStyle text15bold = TextStyle(
      fontSize: 18, fontFamily: 'Poppins-Bold', color: Color(0xffD1D1D1));
}

class Textfield1 {
  static TextFormField textFormField = TextFormField(
    style: TextStyle(color: Colors.white),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your data';
      }
      return null;
    },
    decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            gapPadding: 20,
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Appcolors.text_violet,
            )),
        errorBorder: OutlineInputBorder(
            gapPadding: 20,
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Colors.red,
            )),
        isDense: true,
        filled: true,
        fillColor: Appcolors.signupButtoncolor,
        // prefixIcon: Container(
        //     padding: EdgeInsets.only(top: 18, bottom: 18),
        //     height: 60,
        //     child: Image.asset('assets/icons/Message.png')),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Appcolors.text_violet,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Appcolors.textfieldColot,
            )),
        hintText: 'Enter Name',
        hintStyle: TextStyle(color: Appcolors.text_grey, fontSize: 14)),
  );
  static InputDecoration inputdec = InputDecoration(
      focusedBorder: OutlineInputBorder(
          gapPadding: 20,
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            //redColor67
            color: ApplicationColors.redColor67,
          )),
      errorBorder: OutlineInputBorder(
          gapPadding: 00,
          //borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: Colors.red,
          )),
      isDense: true,
      filled: true,
      fillColor: ApplicationColors.darkGreyBGColor,
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: ApplicationColors.dropdownColor3D,
        ),
        //borderRadius: BorderRadius.circular(12.0),
      ),
      enabledBorder: OutlineInputBorder(
          //borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: ApplicationColors.redColor67)),
      // hintText: 'Enter Name',
      hintStyle: TextStyle(color: Appcolors.text_grey, fontSize: 12));
}

class Boxdec {
  static BoxDecoration bcgreyrad6 = BoxDecoration(
      border: Border.all(color: Appcolors.button_grey),
      borderRadius: BorderRadius.circular(6),
      color: Appcolors.background_blue1);
  static BoxDecoration bcgreyrad25 = BoxDecoration(
      border: Border.all(color: ApplicationColors.dropdownColor3D),
      borderRadius: BorderRadius.circular(40),
      color: ApplicationColors.blackColor2E);
  static BoxDecoration b_backcvioletrad6 = BoxDecoration(
      border: Border.all(color: Appcolors.text_violet),
      borderRadius: BorderRadius.circular(6),
      color: Appcolors.text_violet);
  static BoxDecoration bcvioletrad6 = BoxDecoration(
      border: Border.all(color: Appcolors.text_violet),
      borderRadius: BorderRadius.circular(6),
      color: Appcolors.background_blue1);
  static BoxDecoration bcgreyrad12 = BoxDecoration(
      border: Border.all(color: Appcolors.button_grey),
      borderRadius: BorderRadius.circular(12),
      color: Appcolors.background_blue1);
  static BoxDecoration bcbluerad6 = BoxDecoration(
      border: Border.all(color: Appcolors.background_blue1),
      borderRadius: BorderRadius.circular(6),
      color: Appcolors.background_blue);
  static BoxDecoration bcbluerad6withnoborderright = BoxDecoration(
      // border: Border.all(color: Appcolors.background_blue1),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5.0),
        topRight: Radius.zero,
        bottomLeft: Radius.circular(5.0),
        bottomRight: Radius.zero,
      ),
      color: Appcolors.background_blue);
  static BoxDecoration bcbluerad6withnoborderleft = BoxDecoration(
      // border: Border.all(color: Appcolors.background_blue1),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5.0),
        topRight: Radius.circular(5.0),
        bottomLeft: Radius.circular(5.0),
        bottomRight: Radius.circular(5.0),
      ),
      color: Appcolors.background_blue);
  static BoxDecoration conrad6colorblack = BoxDecoration(
      // border: Border.all(color: ApplicationColors.blackColor2E),
      borderRadius: BorderRadius.circular(6), //blackColor2E
      // color: ApplicationColors.darkGreyBGColor.withOpacity(0.4)
      color: ApplicationColors.whiteColor);
  static BoxDecoration conrad6colorwhite = BoxDecoration(
      // border: Border.all(color: ApplicationColors.blackColor2E),
      borderRadius: BorderRadius.circular(6), // Color(0xffE0E0E0)
      color: Colors.white);
  static BoxDecoration conrad6appColors2 = BoxDecoration(
      // border: Border.all(color: ApplicationColors.blackColor2E),
      borderRadius: BorderRadius.circular(6),
      color: ApplicationColors.appColors2);
  static BoxDecoration conrad6colorgrey = BoxDecoration(
      // border: Border.all(color: ApplicationColors.blackColor2E),
      borderRadius: BorderRadius.circular(12), //dropdownColor3D,
      color: ApplicationColors.white9F9);
  static BoxDecoration buttonBoxDecRed_r6 = BoxDecoration(
      border: Border.all(color: ApplicationColors.redColor67),
      borderRadius: BorderRadius.circular(6),
      color: ApplicationColors.redColor67);
  static BoxDecoration buttonBoxDecRed_y6 = BoxDecoration(
      border: Border.all(color: ApplicationColors.yellowColorD21),
      borderRadius: BorderRadius.circular(6),
      color: ApplicationColors.yellowColorD21);
  static BoxDecoration squareBoxshadow = BoxDecoration(
    //gradient: LinearGradient(colors: [ApplicationColors.blackColor2E,Color.fromRGBO(245, 245, 245, 0.7098039215686275),]),
    borderRadius: BorderRadius.circular(100),
    boxShadow: [
      BoxShadow(
          // blurStyle: BlurStyle.outer,
          color: Color.fromRGBO(9, 9, 9, 0.7098039215686275),
          //Color.fromRGBO(245, 245, 245, 0.7098039215686275)
          offset: Offset(0, 5),
          blurRadius: 19,
          spreadRadius: 0),
      BoxShadow(
          // blurStyle: BlurStyle.outer,
          color: Color.fromRGBO(245, 245, 245, 0.7098039215686275),
          //Color.fromRGBO(245, 245, 245, 0.7098039215686275)
          offset: Offset(0, 10),
          blurRadius: 38,
          spreadRadius: 0)
    ],
  );
}
