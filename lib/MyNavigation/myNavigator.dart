import 'package:flutter/material.dart';

class MyNavigator {

  static void goToLoginPage(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/logIn', (route) => false);
  }

  static void goToDashBoard(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/dashBoard', (route) => false);
  }

  static void goToRegister(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/register', (route) => false);
  }

  static void goToOnboard(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/onboard', (route) => false);
  }

}