import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/vehicle_list_model.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/Provider/vehicle_list_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/custom_text_field.dart';
import 'package:oneqlik/widgets/simple_elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Immobilized extends StatefulWidget {
  VehicleLisDevice vehicleLisDevice;
  final vName,vDeviceId;
  Immobilized({Key key,this.vehicleLisDevice,this.vName,this.vDeviceId}) : super(key: key);

  @override
  _ImmobilizedState createState() => _ImmobilizedState();
}

class _ImmobilizedState extends State<Immobilized> {
  var height, width;

  VehicleListProvider vehicleListProvider;
  TextEditingController passwordController =TextEditingController ();
  UserProvider userProvider;

  GlobalKey<FormState> passwordKey = GlobalKey();

  var ignitionLock = "";
  var protocolType = "";
  bool showEye = false;

  customApi() async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");

    var data =
    {
      "user": "$id",
      "id": widget.vehicleLisDevice.id,
      "fields": "ignitionLock",
    };

    print("parking->$data");

    await vehicleListProvider.customApi(data, "devices/getDeviceCustomApi", context);
    if(vehicleListProvider.isCustomSuccess){
      setState(() {
        ignitionLock = vehicleListProvider.body['ignitionLock'];
      });
    }
  }

  getProtocolType() async{

    var data = {
      "id":"${widget.vehicleLisDevice.deviceModel.id}",
    };

    print("prototype->$data");

    await vehicleListProvider.getProtocol(data, "deviceModel/getDevModelByName", context);
    if(vehicleListProvider.isProtocolSuccess){
      setState(() {
        protocolType = vehicleListProvider.protocolBody[0]['device_type'];
        print(protocolType);
      });
    }
  }

  addCommandApi()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");
    print("ignition lock---------$ignitionLock");

    var data = {
      "imei": "${widget.vehicleLisDevice.deviceId}",
      "_id": "$id",
     // "engine_status": ignitionLock == "0" ? "1" : "0",
      "engine_status": ignitionLock,
      "protocol_type": protocolType
    };

    print(jsonEncode(data));

     await vehicleListProvider.addCommandApi(data, "devices/addCommandQueue", context,widget.vehicleLisDevice.id,widget.vDeviceId);
  }

  getUserData()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "uid":id,
    };

    print(id);

    await userProvider.getUserData(data, "users/getCustumerDetail",context);
  }

  getCommandQueueDetail()async{

    var data = {
      "imei": "${widget.vDeviceId}",
    };

    print("data-->$data");

    vehicleListProvider.getCommandQueue(data, "devices/getCommandQueue");

  }

  showBoxDialog(){
    showDialog(
      context: context,
      builder: (context) {
        var width = MediaQuery.of(context).size.width;
        var height = MediaQuery.of(context).size.height;
        return AlertDialog(
            contentPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: StatefulBuilder(
            builder: (context,StateSetter setState) {
              return Container(
                height: 251,
                decoration: BoxDecoration(
                  color: ApplicationColors.blackColor2E,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ApplicationColors.blackColor2E, width: 2),
                ),
                child: Form(
                  key: passwordKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20,left: 20,bottom: 10,top: 10),
                          child: Text(
                            ' ${getTranslated(context, "Immobilize_Password")}',
                            overflow: TextOverflow.visible,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            style: FontStyleUtilities.h24().copyWith(
                                color: ApplicationColors.black4240,
                                fontSize: 22
                            ),
                          ),
                        ),

                        Divider(
                          color: ApplicationColors.textfieldBorderColor,
                          thickness: 1,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 20,left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: height*0.03),
                              CustomTextField(
                                hintStyle: TextStyle(color: ApplicationColors.black4240,),
                                controller: passwordController,
                                suffixIcon: InkWell(
                                    onTap: () {
                                      print("value");
                                      setState(() {
                                        if(showEye == true){
                                          showEye = false;
                                        }else{
                                          showEye = true;
                                        }
                                      });
                                    },
                                    child: Container(
                                      height: 14,
                                      width: 20,
                                      padding: EdgeInsets.all(14),
                                      child: Image.asset(
                                        showEye
                                            ? "assets/images/visible_icon.png"
                                            : "assets/images/visibility_on.png",
                                        color: ApplicationColors.textfieldBorderColor,
                                      ),
                                    )
                                ),
                                textAlign: TextAlign.start,
                                obscureText: showEye,
                                // controller: _loginController.passwordController,
                                hintText: '${getTranslated(context, "password")} *',
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '${getTranslated(context, "Please_enter_password")}';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: height*0.02),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: SimpleElevatedButton(
                                        onPressed: () {

                                          Navigator.of(context).pop();
                                        },
                                        buttonName: '${getTranslated(context, "cancel")}',
                                        style: FontStyleUtilities.s18(fontColor: ApplicationColors.whiteColor),
                                        fixedSize: Size(118, 40),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5)),
                                        color: ApplicationColors.redColor67,
                                      ),
                                    ),
                                    SizedBox(width: width *0.025),
                                    Expanded(
                                      child: SimpleElevatedButton(
                                        onPressed: () {
                                          if(passwordKey.currentState.validate()){
                                            if(passwordController.text == userProvider.useModel.cust.engineCutPsd || passwordController.text  == userProvider.useModel.cust.pass){
                                              Navigator.pop(context);
                                              addCommandApi();
                                              Helper.dialogCall.showToast(context, "${getTranslated(context, "command_triggered")}");
                                            }else{
                                              Helper.dialogCall.showToast(context, "${getTranslated(context, "Password_is_wrong")}");
                                            }
                                          }

                                        },
                                        buttonName: '${getTranslated(context, "apply")}',
                                        style: FontStyleUtilities.s18(fontColor: ApplicationColors.whiteColor),
                                        fixedSize: Size(118, 40),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5)),
                                        color: ApplicationColors.redColor67,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              );
            }
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    vehicleListProvider = Provider.of<VehicleListProvider>(context,listen: false);
    userProvider = Provider.of<UserProvider>(context,listen: false);

    Future.delayed(Duration.zero, () async {
      customApi();
      getProtocolType();
      getUserData();
      getCommandQueueDetail();
    });

  }

  @override
  Widget build(BuildContext context) {

    vehicleListProvider = Provider.of<VehicleListProvider>(context,listen: true);
    userProvider = Provider.of<UserProvider>(context,listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: ApplicationColors.whiteColorF9
              /*image: DecorationImage(
                image: AssetImage(
                    "assets/images/dark_background_image.png"), // <-- BACKGROUND IMAGE
                fit: BoxFit.cover,
              ),*/
            ),
          ),
          vehicleListProvider.isCustomApi || vehicleListProvider.isProtocolLoading || userProvider.isLoading
              ?
          Helper.dialogCall.showLoader()
              :
          Scaffold(
              appBar: AppBar(
                titleSpacing: -10,
                automaticallyImplyLeading: false,
                leading: Padding(
                  padding: const EdgeInsets.only(bottom: 13.0, top: 13),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset("assets/images/vector_icon.png",color: ApplicationColors.redColor67),
                  ),
                ),
                title: Text(
                  "${getTranslated(context, "immobilize")}",
                  style: Textstyle1.appbartextstyle1,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [

                          // InkWell(
                          //   onTap: (){
                          //   },
                          //   child: Container(
                          //     width: width * .4,
                          //     height: height * .17,
                          //     padding: EdgeInsets.all(15),
                          //
                          //     decoration: Boxdec.conrad6colorblack,
                          //     child: Center(
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.center,
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           //SizedBox(height: 10,),
                          //           Center(
                          //               child: Image.asset(
                          //             "assets/images/arm_icon_immobilized.png",
                          //             width: width * .20,
                          //           )),
                          //           Spacer(),
                          //           Center(
                          //               child: Text(
                          //             "${getTranslated(context, "arm")}",
                          //             style: Textstyle1.text18bold
                          //                 .copyWith(fontSize: 14.6),
                          //           ))
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          //
                          // Container(
                          //   width: width * .4,
                          //   height: height * .17,
                          //   padding: EdgeInsets.all(15),
                          //
                          //   decoration: Boxdec.conrad6colorblack,
                          //   child: Column(
                          //     children: [
                          //       Image.asset(
                          //         "assets/images/arm_icon_immobilized.png",
                          //         width: width * .20,
                          //       ),
                          //       Spacer(),
                          //       Text(
                          //         "${getTranslated(context, "disaram")}",
                          //         style: Textstyle1.text18bold
                          //             .copyWith(fontSize: 14.6),
                          //       )
                          //     ],
                          //   ),
                          // ),

                          InkWell(
                            onTap: (){
                            //  if(ignitionLock != "0"){
                              ignitionLock="0";
                                passwordController.clear();
                                showBoxDialog();
                             // }
                            },
                            child: Container(
                              width: width * .4,
                              height: height * .17,
                              padding: EdgeInsets.all(15),
                              decoration: Boxdec.conrad6colorblack,
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/close.png",
                                        width: width * .20,
                                      ),
                                      Spacer(),
                                      // SizedBox(height: 15,),
                                      Center(
                                          child: Text(
                                        "${getTranslated(context, "stop_engine")}",
                                        textAlign: TextAlign.center,
                                        style: Textstyle1.text18bold
                                            .copyWith(fontSize: 14),
                                      ))
                                    ],
                                  ),
                                  /*ignitionLock == "0"
                                      ?
                                  Container(
                                    width: width * .4,
                                    height: height * .17,
                                    padding: EdgeInsets.all(15),
                                    decoration: Boxdec.conrad6colorblack.copyWith(
                                      color: ApplicationColors.blackColor2E1.withOpacity(0.3)
                                    ),
                                  )
                                      :
                                  SizedBox()*/
                                ],
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: (){
                             // if(ignitionLock == "0"){
                              ignitionLock="1";
                                passwordController.clear();
                                showBoxDialog();
                             // }
                            },
                            child: Container(
                              width: width * .4,
                              height: height * .17,
                              padding: EdgeInsets.all(15),

                              decoration: Boxdec.conrad6colorblack,
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Image.asset(
                                          "assets/images/open.png",
                                        width: width * .20,
                                      ),
                                      Spacer(),
                                      Text(
                                        "${getTranslated(context, "resume_engine")}",
                                        textAlign: TextAlign.center,
                                        style: Textstyle1.text18bold
                                            .copyWith(fontSize: 14),
                                      )
                                    ],
                                  ),
                                 /* ignitionLock != "0"
                                      ?
                                  Container(
                                    width: width * .4,
                                    height: height * .17,
                                    padding: EdgeInsets.all(15),
                                    decoration: Boxdec.conrad6colorblack.copyWith(
                                        color: ApplicationColors.blackColor2E1.withOpacity(0.3)
                                    ),
                                  )
                                      :
                                  SizedBox()*/
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Note:  ",
                            style: Textstyle1.appbartextstyle1.copyWith(color: Colors.black,fontSize: 15)
                        ),
                        Expanded(
                          child: Text("Only use emergency case. Please don't use where GSM network connectivity is poor",
                            style: FontStyleUtilities.h12(
                                fontColor: ApplicationColors.black4240
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text("${getTranslated(context, "Command_History")}",
                      style: Textstyle1.appbartextstyle1
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: vehicleListProvider.isCommandQueueLoading
                          ?
                      Helper.dialogCall.showLoader()
                          :
                      vehicleListProvider.getCommandQueueList.length == 0
                          ?
                      Center(
                        child: Text(
                          "${getTranslated(context, "Command_queue_detail_is_not_available")}",
                          textAlign: TextAlign.center,
                          style: Textstyle1.text18.copyWith(
                            fontSize: 18,
                            color: ApplicationColors.redColor67,
                          ),
                          maxLines: 2,
                        ),
                      )
                          :
                      ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: vehicleListProvider.getCommandQueueList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {

                            var list = vehicleListProvider.getCommandQueueList[i];
                           // print("-----------${list.queuedAt.toString()}");
                            String utcDateString=list.queuedAt.toString();
                            DateTime utcDate = DateTime.parse(utcDateString);
                            DateTime localDate = utcDate.toLocal();
                            DateFormat localDateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
                            String localDateString = localDateFormat.format(localDate);
                           // print("121-----------${localDateString}");

                            return Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: Boxdec.conrad6colorblack,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            "assets/images/car_icon.png",color: ApplicationColors.redColor67,
                                            width: 16,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${widget.vName}",
                                            style: FontStyleUtilities.s14(
                                                fontColor: ApplicationColors.redColor67
                                            ),
                                            overflow: TextOverflow.visible,
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                          ),
                                          Expanded(child: SizedBox()),
                                          Text(
                                            "${list.status}",
                                            maxLines: 1,
                                            overflow: TextOverflow.visible,
                                            style: FontStyleUtilities.h11(
                                                fontColor: ApplicationColors.black4240
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            "assets/images/clock_icon_vehicle_Page.png",color: ApplicationColors.redColor67,
                                            width: 12,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                           "$localDateString",
                                            //"${DateFormat("dd MMM yyyy").format(DateTime.parse(list.queuedAt.toString()))}",
                                            style: FontStyleUtilities.h12(
                                                fontColor: ApplicationColors.black4240
                                            ),
                                            overflow: TextOverflow.visible,
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(width: 2),
                                         /* Text(
                                            " ${DateFormat.jm().format(
                                                DateTime.parse(
                                                    list.queuedAt.toString()
                                                )
                                            )}",
                                            style: FontStyleUtilities.h12(
                                                fontColor: ApplicationColors.black4240
                                            ),
                                            overflow: TextOverflow.visible,
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                          ),*/
                                          Expanded(child: SizedBox()),
                                          Text(
                                            "${list.action.toUpperCase()}",
                                            overflow: TextOverflow.visible,
                                            maxLines: 1,
                                            style: FontStyleUtilities.hS12(
                                                fontColor: ApplicationColors.black4240
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Image.asset(
                                            "assets/images/traced_icon.png",
                                            width: 15,
                                            height: 15,
                                            color: "${list.action.toUpperCase()}"==
                                                "OFF"
                                                ?
                                            ApplicationColors.redColor67
                                                :
                                            ApplicationColors.greenColor370,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                )
                              ],
                            );
                          }),
                    )
                  ],
                ),
              ),
          )
    ]);
  }

}
