import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/OnboardingScreens/onboard_model.dart';
import 'package:oneqlik/screens/Authentication/LoginScreen/login_screen.dart';
import 'package:oneqlik/utils/assets_images.dart';
import 'package:oneqlik/utils/colors.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {


  int currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    List<OnBoardModel> screens = <OnBoardModel>[
      OnBoardModel(
        img: AssetsUtilities.slider1,
        text: "${getTranslated(context, "easy_tracking")}",
        desc: "${getTranslated(context, "lorem_leo")}",
        bgimg: AssetsUtilities.slider3,
        button: Colors.white,
      ),
      OnBoardModel(
        img: AssetsUtilities.slider2,
        text: "${getTranslated(context, "save_time")}",
        desc: "${getTranslated(context, "lorem_leo")}",
        bgimg: AssetsUtilities.slider3,
        button: Colors.white,
      ),
      OnBoardModel(
        img: AssetsUtilities.slider3,
        text: "${getTranslated(context, "vehicle_mintenance")}",
        desc: "${getTranslated(context, "lorem_leo")}",
        bgimg: AssetsUtilities.slider3,
        button: Color(0xFF4756DF),
      ),
    ];


    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: ApplicationColors.whiteColorF9
        ),
        child: PageView.builder(
            itemCount: screens.length,
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text(
                              "${getTranslated(context, "skip")}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: currentIndex % 2 == 0
                                      ? ApplicationColors.black4240
                                      : ApplicationColors.black4240
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: height*0.1),
                    Image.asset(
                        screens[index].img,
                        height: height*0.35,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: height*0.1),
                    Text(
                      screens[index].text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: width*0.05,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: index % 2 == 0 ? ApplicationColors.black4240: ApplicationColors.black4240,
                      ),
                    ),
                    SizedBox(height: height*0.01),
                    Text(
                      screens[index].desc,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: width*0.035,
                        fontFamily: 'Poppins',
                        color: index % 2 == 0 ? ApplicationColors.black4240: ApplicationColors.black4240,
                      ),
                    ),
                    SizedBox(height: height*0.08),
                    Container(
                      padding: EdgeInsets.all(9),
                      height: height*0.13,
                      width: width*0.25,
                      child: InkWell(
                        onTap: () async {
                          print(index);
                          if (index == screens.length - 1) {}
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 380),
                            curve: Curves.linear,
                          );
                        },

                        child: currentIndex == 2
                            ?
                        InkWell(
                          onTap: (){

                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => LoginScreen()));
                          },
                          child: Container(
                            child: const Center(
                                child: Icon(Icons.arrow_forward_outlined,
                                    color: ApplicationColors.whiteColor, size: 36)),
                            decoration: BoxDecoration(
                              color: ApplicationColors.redColor67,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: ApplicationColors.redColor67, width: 1.5),
                            ),
                          ),
                        )
                            :
                        Container(
                          child: const Center(
                              child: Icon(Icons.arrow_forward_outlined,
                                  color: ApplicationColors.whiteColor, size: 36)),
                          decoration: BoxDecoration(
                            color: ApplicationColors.redColor67,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: ApplicationColors.redColor67, width: 1.5),
                          ),
                        ),

                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: ApplicationColors.redColor67, width: 1.5),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}