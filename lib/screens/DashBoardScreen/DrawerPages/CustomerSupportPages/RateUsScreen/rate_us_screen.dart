import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/simple_elevated_button.dart';
import 'package:oneqlik/widgets/simple_text_field.dart';

class RateUsPage extends StatefulWidget {
  const RateUsPage({Key key}) : super(key: key);

  @override
  _RateUsPageState createState() => _RateUsPageState();
}

class _RateUsPageState extends State<RateUsPage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: height,
        width:width,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Image.asset("assets/images/rate_us_screen.png", fit: BoxFit.fill),
            Positioned.fill(
              top: 50,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: height*0.40),
                    Image.asset("assets/images/google_play_ic.png",
                        width: 163, height: 50),
                    Text(
                      "Your opinion matter to us!",
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: FontStyleUtilities.s24(
                          fontColor: ApplicationColors.blackColor2E,
                          fontFamily: "Poppins-Bold"),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Lorem ipsum dolor sit amet,\n consectetur adipiscing elit.Mattis \n etiam ut volutpat.",
                      overflow: TextOverflow.visible,
                      maxLines: 5,
                      textAlign: TextAlign.center,
                      style: FontStyleUtilities.h14(
                          fontColor: ApplicationColors.blackColor2E,
                          fontFamily: "Poppins-SemiBold"),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 50, right: 50, top: 25,bottom: 25),
                      child: TextField(
                        maxLines: 3,
                        style: FontStyleUtilities.h14(
                            fontColor: ApplicationColors.blackColor2E),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ApplicationColors.blackColor2E
                                      .withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(5)),
                          // contentPadding:
                          // const EdgeInsets.only(top: 12, bottom: 12, left: 15, right: 15),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ApplicationColors.blackColor2E,
                                  width: 1)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ApplicationColors.blackColor2E),
                              borderRadius: BorderRadius.circular(5)),
                          hintText: 'Add Review ...',
                          hintStyle: TextStyle(
                              color: ApplicationColors.blackColor2E,
                              fontSize: 14,
                              fontFamily: "Poppins-Regular",
                              letterSpacing: 0.75),

                          // ],
                        ),
                      ),
                    ),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: ApplicationColors.redColor67,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                    SizedBox(height: height*0.05),
                    SimpleElevatedButton(
                      onPressed: () {},
                      buttonName: '${getTranslated(context, "submit")}',
                      style: FontStyleUtilities.s18(
                          fontColor: ApplicationColors.whiteColor),
                      fixedSize: Size(325, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: ApplicationColors.redColor67,
                    ),
                    SizedBox(height: height*0.08),
                  ],
                ),
              ),
            ),
            Positioned(
                top: 25,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Image.asset("assets/images/vector_icon.png",
                          color: ApplicationColors.whiteColor,
                          width: 10,
                          height: 16),
                    ),
                    Text(
                      "Rate us",
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: FontStyleUtilities.s24(
                          fontColor: ApplicationColors.whiteColor,
                          fontFamily: "Poppins-Bold"),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
