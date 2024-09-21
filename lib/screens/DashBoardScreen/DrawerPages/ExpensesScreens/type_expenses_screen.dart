
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/expenses_provider.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/ExpensesScreens/add_expenses_screen.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/simple_elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripDetailTypeScreen extends StatefulWidget {
  final types,vId,fromDate,toDate;
  const TripDetailTypeScreen({Key key, this.types,this.vId, this.fromDate, this.toDate}) : super(key: key);

  @override
  _TripDetailTypeScreenState createState() => _TripDetailTypeScreenState();
}

class _TripDetailTypeScreenState extends State<TripDetailTypeScreen> {


  ExpensesProvider _expensesProvider;

  tripDetailType() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "user": "$id",
      "type": widget.types,
      "fdate": widget.fromDate,
      "tdate": widget.toDate,
      "vehicle":widget.vId,
    };

    print('tripType-->$data');

    await _expensesProvider.tripDetailType(data, "expense/tripdetailbyType",context);
  }

  @override
  void initState() {
    super.initState();
    _expensesProvider = Provider.of<ExpensesProvider>(context, listen: false);
    tripDetailType();
  }

  @override
  Widget build(BuildContext context) {
    _expensesProvider = Provider.of<ExpensesProvider>(context, listen: true);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: ApplicationColors.whiteColorF9
          ),
        ),
        Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 9.0, left: 10, top: 13),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Image.asset("assets/images/vector_icon.png",color: ApplicationColors.redColor67),
              ),
            ),
            title: Text(
              "${widget.types} ${getTranslated(context, "expenses")}",textAlign: TextAlign.start,
              style: Textstyle1.appbartextstyle1,
            ),
            backgroundColor: Colors.transparent, elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: Container(
            height: height,
            width: width,
            padding: const EdgeInsets.only(right: 19,left: 14,top: 15),
            child: Stack(
              children: [
                _expensesProvider.isTripTypeLoading
                    ?
                    Helper.dialogCall.showLoader()
                    :
                _expensesProvider.tripDetailTypeList.isEmpty
                    ?
                Center(
                  child: Text(
                    "${getTranslated(context, "expense_type_not_available")}",
                    textAlign: TextAlign.center,
                    style: Textstyle1.text18.copyWith(
                      fontSize: 18,
                      color: ApplicationColors.redColor67,
                    ),
                  ),
                )
                    :
                ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _expensesProvider.tripDetailTypeList.length,
                    padding: EdgeInsets.only(bottom: 60),
                    shrinkWrap: true,
                    itemBuilder: (context,index) {
                      var list = _expensesProvider.tripDetailTypeList[index];
                      return Container(
                        padding: EdgeInsets.only(left: 15,top: 5,bottom: 5,right: 15),
                        margin: EdgeInsets.only(bottom: 15),
                        width: width * 0.95,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${list.vehicle.deviceName}",
                              style: FontStyleUtilities.h18(
                                fontColor: ApplicationColors.blackbackcolor,
                              ),
                              overflow: TextOverflow.visible,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      list.date == null
                                          ?
                                      "${getTranslated(context, "date_not_available")}"
                                          :
                                      "${DateFormat("MMM dd,yyyy hh:mm aa").format(list.date)}",
                                      style: FontStyleUtilities.h12(
                                        fontColor: ApplicationColors.blackbackcolor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),

                                Text(
                                  "${list.amount}",
                                  style: FontStyleUtilities.s18(
                                    fontColor: ApplicationColors.blackbackcolor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                ),

                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.visible,
                                    text: TextSpan(
                                      text: "${getTranslated(context, "currency")}",
                                      style: FontStyleUtilities.h11(
                                          fontColor: ApplicationColors.blackbackcolor),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: ' : ${list.currency}',
                                            style: FontStyleUtilities.h11(
                                                fontColor:
                                                ApplicationColors.blackbackcolor)),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2),
                                Flexible(
                                  child: RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.visible,
                                    text: TextSpan(
                                      text: "${getTranslated(context, "payment_mode")}",
                                      style: FontStyleUtilities.h10(
                                          fontColor: ApplicationColors.blackbackcolor),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: " : ${list.paymentMode}" == null ? "${getTranslated(context, "sada")}" : " : ${list.paymentMode}",
                                              style: FontStyleUtilities.h10(
                                                fontColor:
                                                ApplicationColors.blackbackcolor
                                              )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                              ],
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: ApplicationColors.greyColorF7,
                          borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                  color: ApplicationColors.appColors0.withOpacity(0.2),
                                  blurRadius: 4,
                                  spreadRadius: 3,
                                  offset: Offset(0.0,2.0)
                              ),
                            ],
                        ),
                      );
                    }
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: SimpleElevatedButton(
                    onPressed: () {

                    },
                    buttonName: "${getTranslated(context, "total")} ₹ ${_expensesProvider.totalExpanse}",
                    style: FontStyleUtilities.s18(
                        fontColor: ApplicationColors.whiteColor
                    ),
                    fixedSize: Size(height*0.41, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    color: ApplicationColors.redColor67,
                  ),
                ),

              ],
            ),
          ),

        ),


      ],
    );
  }
}
