import 'package:flutter/cupertino.dart';
import 'package:oneqlik/utils/colors.dart';

enum FWT { light, regular, medium, bold, semiBold, w400 }

class FontStyleUtilities {
  static FontWeight getFontWeights({FWT fontweight = FWT.regular}) {
    switch (fontweight) {
      case FWT.bold:
        return FontWeight.w700;
      case FWT.semiBold:
        return FontWeight.w600;
      case FWT.medium:
        return FontWeight.w500;
      case FWT.regular:
        return FontWeight.w400;
      case FWT.light:
        return FontWeight.w300;
    }
  }

  static TextStyle h5({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.regular,
  }) {
    return TextStyle(
        fontSize: 5,
        fontFamily: fontFamily ?? 'Poppins-Regular',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle h8({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.regular,
  }) {
    return TextStyle(
        fontSize: 8,
        fontFamily: fontFamily ?? 'Poppins-Regular',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle h9({
    Color fontColor,
    String fontFamily,
    double letterSpacing = 0.0,
    FWT fontweight = FWT.regular,
  }) {
    return TextStyle(
        fontSize: 9,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? 'Poppins-Regular',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle h10({
    Color fontColor,
    String fontFamily,
    double letterSpacing = 0.0,
    FWT fontweight = FWT.regular,
  }) {
    return TextStyle(
        fontSize: 10,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? 'Poppins-Regular',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle h16({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.regular,
  }) {
    return TextStyle(
        fontSize: 16,
        fontFamily: fontFamily ?? 'Poppins-Regular',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle hs16({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.semiBold,
  }) {
    return TextStyle(
        fontSize: 16,
        fontFamily: fontFamily ?? 'Poppins-Regular',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle s16({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.semiBold,
  }) {
    return TextStyle(
        fontSize: 16,
        fontFamily: fontFamily ?? 'Poppins-SemiBold',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle s17({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.semiBold,
  }) {
    return TextStyle(
        fontSize: 17,
        fontFamily: fontFamily ?? 'Poppins-SemiBold',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle h18({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.bold,
  }) {
    return TextStyle(
        fontSize: 18,
        fontFamily: fontFamily ?? 'Poppins-Bold',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle b18({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.semiBold,
  }) {
    return TextStyle(
        fontSize: 18,
        fontFamily: fontFamily ?? 'Poppins-SemiBold',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle s18({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.semiBold,
  }) {
    return TextStyle(
        fontSize: 18,
        fontFamily: fontFamily ?? 'Poppins-SemiBold',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle s24({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.semiBold,
  }) {
    return TextStyle(
        fontSize: 24,
        fontFamily: fontFamily ?? 'Poppins-SemiBold',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle h11({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.regular,
  }) {
    return TextStyle(
        fontSize: 11,
        fontFamily: fontFamily ?? 'Poppins-Regular',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle h12({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.regular,
  }) {
    return TextStyle(
        fontSize: 12,
        fontFamily: fontFamily ?? 'Poppins-Regular',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle hS12({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.semiBold,
  }) {
    return TextStyle(
        fontSize: 12,
        fontFamily: fontFamily ?? 'Poppins-SemiBold',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle hS11({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.semiBold,
  }) {
    return TextStyle(
        fontSize: 11,
        fontFamily: fontFamily ?? 'Poppins-SemiBold',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle h13({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.regular,
  }) {
    return TextStyle(
        fontSize: 13,
        fontFamily: fontFamily ?? 'Poppins-Regular',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle h24({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.bold,
  }) {
    return TextStyle(
        fontSize: 24,
        fontFamily: fontFamily ?? 'Poppins-Bold',
        color: fontColor ?? ApplicationColors.whiteColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle h36({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.semiBold,
  }) {
    return TextStyle(
        fontSize: 36,
        fontFamily: fontFamily ?? 'Poppins-Regular',
        color: fontColor ?? ApplicationColors.whiteColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle h14({
    double letterSpacing = 0.0,
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.regular,
  }) {
    return TextStyle(
        fontSize: 14,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? 'Poppins-Regular',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle s14({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.semiBold,
  }) {
    return TextStyle(
        fontSize: 14,
        fontFamily: fontFamily ?? 'Poppins-Bold',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }

  static TextStyle hW14({
    Color fontColor,
    String fontFamily,
    FWT fontweight = FWT.bold,
  }) {
    return TextStyle(
        fontSize: 14,
        fontFamily: fontFamily ?? 'Poppins-Bold',
        color: fontColor ?? ApplicationColors.primaryTextColor,
        fontWeight: getFontWeights(fontweight: fontweight));
  }
}
