import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:oneqlik/Provider/group_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:oneqlik/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddGroupsScreen extends StatefulWidget {
  const AddGroupsScreen({Key key}) : super(key: key);

  @override
  _AddGroupsScreenState createState() => _AddGroupsScreenState();
}

class _AddGroupsScreenState extends State<AddGroupsScreen> {

  TextEditingController _groupNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();

  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();

  Country _country = CountryPickerUtils.getCountryByPhoneCode('60');

  bool activeGroups = true;

  void _openCountryPickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.pink),
      child: CountryPickerDialog(
        searchCursorColor: Colors.pinkAccent,
        divider: Divider(),
        searchInputDecoration: InputDecoration(
            labelText: 'SearchLocationPage...',
            suffixIcon: Icon(
              Icons.search,
              // color: AppColors.black,
            ),
            labelStyle: TextStyle(fontFamily: 'Poppins-Semibold')),
        isSearchable: true,
        title: Text(
           "Select your phone code",
          style: TextStyle(fontFamily: 'Poppins-SemiBold'),
        ),
        onValuePicked: (Country country) =>
            setState(() => _country = country),
        itemBuilder: (Country country) {
          return Row(
            children: <Widget>[
              CountryPickerUtils.getDefaultFlagImage(country),
              SizedBox(width: 8.0),
              Text(
                "+${country.phoneCode}",
                style:
                TextStyle(fontSize: 15,
                    fontFamily: 'Poppins-Regular'),
              ),
              SizedBox(width: 8.0),
              Flexible(
                  child: Text(
                    country.name,
                    style:
                    TextStyle(fontSize: 15,
                        fontFamily: 'Poppins-regular'),
                  ))
            ],
          );
        },
        priorityList: [
          CountryPickerUtils.getCountryByIsoCode('IN'),
        ],
      ),
    ),
  );


  GetGroupListProvider getGroupListProvider;

  addGroups() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
        "logopath": "car",
        "name": _groupNameController.text,
        "status": activeGroups,
        "address": _addressController.text,
        "mobileNo": _mobileController.text,
        "uid": id,
    };

    getGroupListProvider.addGroup(data, "groups/addGroup", context);

  }

  @override
  void initState() {
    super.initState();
    getGroupListProvider = Provider.of<GetGroupListProvider>(context,listen: false);
  }

  @override
  Widget build(BuildContext context) {
    getGroupListProvider = Provider.of<GetGroupListProvider>(context,listen: true);
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
              "${getTranslated(context, "add_group")}",
              textAlign: TextAlign.start,
              style: Textstyle1.appbartextstyle1,
            ),

            backgroundColor: Colors.transparent, elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(right: 19,left: 14,top: 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 25,right: 25,top: 40,bottom: 100),
                    child: Form(
                      key: _forMKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomTextField(
                            hintStyle: TextStyle(color: ApplicationColors.black4240),
                            keyboardType: TextInputType.name,
                            textAlign: TextAlign.start,
                            controller: _groupNameController,
                            focusedBorder: ApplicationColors.redColor67,
                            borderColor: ApplicationColors.textfieldBorderColor,
                            hintText: "${getTranslated(context, "group_name")}",
                            validator: (value) {
                              if (value.isEmpty) {
                                return "${getTranslated(context, "enter_groupname")}";
                              }
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          const SizedBox(height: 21),
                          CustomTextField(
                            hintStyle: TextStyle(color: ApplicationColors.black4240),
                            keyboardType: TextInputType.streetAddress,
                            textAlign: TextAlign.start,
                            maxLine: 3,
                            focusedBorder: ApplicationColors.redColor67,
                            borderColor: ApplicationColors.textfieldBorderColor,
                            controller: _addressController,
                            hintText: "${getTranslated(context, "address")}",
                            validator: (value) {
                              if (value.isEmpty) {
                                return "${getTranslated(context, "enter_address")}";
                              }
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          const SizedBox(height: 21),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: (){
                                  _openCountryPickerDialog();
                                },
                                child:Container(
                                  width: 75,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: ApplicationColors.textfieldBorderColor)
                                  ),
                                  child: Center(
                                    child: Text(
                                      "+ ${_country.phoneCode}",
                                      style: TextStyle(
                                          color: ApplicationColors.black4240,
                                          fontFamily: "Poppins-Regular",
                                      ),
                                    ),
                                  ),
                                )
                              ),
                              SizedBox(width: 9),
                              Expanded(
                                child: CustomTextField(
                                  hintStyle: TextStyle(color: ApplicationColors.black4240),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.start,
                                  focusedBorder: ApplicationColors.redColor67,
                                  borderColor: ApplicationColors.textfieldBorderColor,
                                  inputFormatter: [
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  controller: _mobileController,
                                  hintText:"${getTranslated(context, "mobile_num")}",
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "${getTranslated(context, "enter_num")}";
                                    }
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 21),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${getTranslated(context, "group_status")}",
                                  style: FontStyleUtilities.s14(
                                      fontColor: ApplicationColors.black4240,
                                  ),
                              ),
                              Expanded(child: SizedBox()),
                              Text(
                                "${getTranslated(context, "inactive")}",
                                style: FontStyleUtilities.h12(
                                    fontColor: ApplicationColors.textColorA6,
                                ),
                              ),
                              SizedBox(width: width*0.025),
                              FlutterSwitch(
                                toggleSize: 10,
                                padding: 2,
                                height:
                                height * .021,
                                width:
                                width * .09,
                                switchBorder: Border.all(color: Colors.black54),
                                activeColor: ApplicationColors.whiteColor,
                                activeToggleColor: ApplicationColors.redColor67,
                                toggleColor: ApplicationColors.black4240,
                                inactiveColor: ApplicationColors.whiteColor,
                                value: activeGroups,
                                onToggle: (val) {
                                  setState(() {
                                    activeGroups = val;
                                  });
                                },
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: ApplicationColors.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(height: height*0.22),
                  Row(
                    children: [
                      Expanded(
                          child: CustomElevatedButton(
                            onPressed: () async {
                              if(_forMKey.currentState.validate()){
                                addGroups();
                              }
                            },
                            buttonText: "${getTranslated(context, "submit")}",
                            buttonColor: ApplicationColors.redColor67,
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: height*0.02),



                ],
              ),
            ),
          ),
        ),


      ],
    );
  }
}
