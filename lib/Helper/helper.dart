import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';

class Helper {
  static final Helper dialogCall = Helper._();

  Helper._();

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: ApplicationColors.whiteColorF9,
      content: Row(
        children: [
          const CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor:
                AlwaysStoppedAnimation<Color>(ApplicationColors.redColor67),
          ),
          Container(
              margin: const EdgeInsets.only(left: 5),
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "${getTranslated(context, "loading")}",
                  // " Loading ...",
                  style: TextStyle(
                    fontSize: 18,
                    color: ApplicationColors.black4240,
                  ),
                ),
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showToast(context, String messages) {
    Fluttertoast.showToast(
        msg: messages,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: ApplicationColors.whiteColor,
        textColor: ApplicationColors.black4240,
        fontSize: 16.0);
  }

  showLoader() {
    return SpinKitThreeBounce(
      color: ApplicationColors.redColor67,
      size: 25,
    );
  }
}
