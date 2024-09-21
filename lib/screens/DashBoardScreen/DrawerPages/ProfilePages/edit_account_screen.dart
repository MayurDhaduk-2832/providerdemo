import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/user_provider.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:oneqlik/widgets/custom_elevated_button.dart';
import 'package:oneqlik/widgets/simple_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAccountScreen extends StatefulWidget {
  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  TextEditingController _editFNameController = TextEditingController();
  TextEditingController _editLNameController = TextEditingController();
  TextEditingController _editUserIdController = TextEditingController();
  TextEditingController _editEmailIdController = TextEditingController();
  TextEditingController _editMobileNumberController = TextEditingController();
  TextEditingController _editAddressController = TextEditingController();

  final GlobalKey<FormState> _forMKey = GlobalKey<FormState>();

  var workingHoursValue;
  var timeZoneValue;

  bool showLabel = false;
  bool driverManagementLabel = false;

  UserProvider userProvider;

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");
    var data = {
      "uid": id,
    };
    await userProvider.getUserData(data, "users/getCustumerDetail", context);
  }

  updateUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "fname": _editFNameController.text,
      "lname": _editLNameController.text,
      "org": userProvider.useModel.cust.orgName,
      "noti": false,
      "uid": id,
      "show_announcement": userProvider.useModel.cust.showAnnouncement,
      "label_setting": showLabel,
      "digital_input": workingHoursValue == "Digital Input 1" ? 1 : 2,
      "driverManagement": driverManagementLabel,
      "paymentGateway": userProvider.useModel.cust.paymentgateway,
      "timezone": timeZoneValue,
      "fuel_unit": userProvider.useModel.cust.fuelUnit,
      "phone": _editMobileNumberController.text,
      "email": _editEmailIdController.text,
      "address": _editAddressController.text,
    };

    print('CheckEdit-<${jsonEncode(data)}');

    await userProvider.updateUserData(data, "users/Account_Edit", context);
    Navigator.of(context).pop();
  }

  PickedFile _image;
  var profileImage;
  File PickImage;
  bool isLoading = false;

  void _optionDialogBox() async {
    final height = MediaQuery.of(context).size.height;

    final imageSource = await showModalBottomSheet<ImageSource>(
        context: context,
        isScrollControlled: true,
        backgroundColor: ApplicationColors.containercolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
          ),
        ),
        elevation: 2,
        builder: (builder) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                    child: Wrap(
                  children: <Widget>[
                    ListTile(
                      dense: true,
                      onTap: () => Navigator.pop(context, ImageSource.camera),
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: height * 0.02),
                          ),
                          Icon(Icons.camera,
                              color: ApplicationColors.redColor67),
                          Padding(
                            padding: EdgeInsets.only(left: height * 0.02),
                          ),
                          Text(
                            "${getTranslated(context, "camera")}",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Poppins-Regular",
                                color: ApplicationColors.black4240),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      dense: true,
                      onTap: () => Navigator.pop(context, ImageSource.gallery),
                      title: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: height * 0.02),
                          ),
                          Icon(Icons.sd_storage,
                              color: ApplicationColors.redColor67),
                          Padding(
                            padding: EdgeInsets.only(left: height * 0.02),
                          ),
                          Text(
                            "${getTranslated(context, "gallery")}",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Poppins-Regular",
                                color: ApplicationColors.black4240),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))),
          );
        });
    if (imageSource != null) {
      setState(() {
        isLoading = true;
      });
      final file = await ImagePicker.platform
          .pickImage(source: imageSource, imageQuality: 50);
      if (file != null) {
        setState(() {
          _image = file;
          profileImage = _image.path;
          _updateProfileImage();
        });
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  _updateProfileImage() async {
    Helper.dialogCall.showAlertDialog(context);

    print(_image.path);

    final uri = '${Utils.http}${Utils.baseUrl}/usersV2/uploadProfilePicture';

    var request = http.MultipartRequest('POST', Uri.parse(uri));

    request.files.add(await http.MultipartFile.fromPath('photo', _image.path));

    await request.send().then((response) async {
      if (response.statusCode == 200) {
        var res = await response.stream.bytesToString();

        print("response $res");
        var getValue = json.decode(res);

        print('print file: $getValue');

        var data = getValue['path'];
        var imageUrl1 = data;

        print('imageUrlShow: $imageUrl1');

        setState(() {
          profileImage = imageUrl1;
          PickImage = File(_image.path);
        });

        Navigator.pop(context);
        print("Image Upload");

        uploadUpdateImage(imageUrl1);
      } else {
        print(request);
        Navigator.pop(context);
        print("Fail!!");
        setState(() {
          _image = null;
          profileImage = null;
        });
      }
    });
  }

  uploadUpdateImage(image) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");
    var data = {
      "_id": "$id",
      "imageDoc": ["$image"]
    };

    await userProvider.uploadNewImage(data, "users/updateImagePath", context);
  }

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    getUserDataCheck();
  }

  getUserDataCheck() {
    _editFNameController.text = '${userProvider.useModel.cust.firstName}';
    _editLNameController.text = '${userProvider.useModel.cust.lastName}';
    _editUserIdController.text = '${userProvider.useModel.cust.userId}';
    _editEmailIdController.text = '${userProvider.useModel.cust.email}';
    _editMobileNumberController.text = '${userProvider.useModel.cust.phone}';
    _editAddressController.text = '${userProvider.useModel.cust.address}';
    workingHoursValue = '${userProvider.useModel.cust.digitalInput}';
    timeZoneValue = '${userProvider.useModel.cust.timezone}';
    showLabel = userProvider.useModel.cust.labelSetting ?? false;
    driverManagementLabel =
        userProvider.useModel.cust.driverManagement ?? false;
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: true);

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ApplicationColors.whiteColor,
      key: _scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Utils.navigatorKey.currentState.openDrawer();
          },
          child: Icon(
            Icons.menu,
            color: ApplicationColors.whiteColor,
            size: 26,
          ),
        ),
        title: Text(
          "${userProvider.useModel.cust.firstName} ${userProvider.useModel.cust.lastName}",
          overflow: TextOverflow.visible,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Arial',
            color: ApplicationColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                updateUserData();
              },
              child: Icon(
                Icons.done_all,
                color: ApplicationColors.whiteColor,
                size: 26,
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xffd21938),
                Color(0xffd21938),
                Color(0xff751c1e),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Text("Update Profile",
                style: FontStyleUtilities.h16(
                    fontColor: ApplicationColors.textColorA6)),
            SizedBox(height: 10),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 134,
                    width: 134,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: PickImage != null
                          ? Image.file(
                              PickImage,
                              fit: BoxFit.fill,
                              width: 120,
                              height: 120,
                            )
                          : CachedNetworkImage(
                              imageUrl:
                                  "${Utils.http}${Utils.baseUrl}${userProvider.userImage}",
                              width: 120,
                              height: 120,
                              fit: BoxFit.fill,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress)),
                              errorWidget: (context, url, error) =>
                                  Image.asset('assets/images/profile_icon.png'),
                            ),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    padding: EdgeInsets.all(5),
                    child: InkWell(
                      onTap: () {
                        _optionDialogBox();
                      },
                      child: Icon(
                        Icons.camera_alt,
                        color: ApplicationColors.whiteColor,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(40)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _forMKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${getTranslated(context, "firstname")}",
                            style: FontStyleUtilities.h12(
                                fontColor: ApplicationColors.textColorA6)),
                        SimpleTextField(
                          maxLine: 1,
                          textAlign: TextAlign.start,
                          controller: _editFNameController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "${getTranslated(context, "enter_first_name")}";
                            }
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ],
                    ),
                    Divider(
                      color: ApplicationColors.greenColor,
                      thickness: 3,
                      endIndent: 0.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${getTranslated(context, "last_name")}",
                            style: FontStyleUtilities.h12(
                                fontColor: ApplicationColors.textColorA6)),
                        SimpleTextField(
                          maxLine: 1,
                          textAlign: TextAlign.start,
                          controller: _editLNameController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "${getTranslated(context, "Enter_lastname")}";
                            }
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ],
                    ),
                    Divider(
                      color: ApplicationColors.greenColor,
                      thickness: 3,
                      endIndent: 0.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${getTranslated(context, "userid")}",
                          style: FontStyleUtilities.h12(
                              fontColor: ApplicationColors.textColorA6),
                        ),
                        SizedBox(height: 3),
                        SimpleTextField(
                          readOnly: true,
                          maxLine: 1,
                          controller: _editUserIdController,
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'Enter User ID';
                          //   }
                          //   FocusScope.of(context)
                          //       .unfocus();
                          // },
                        ),
                      ],
                    ),
                    Divider(
                      color: ApplicationColors.greenColor,
                      thickness: 3,
                      endIndent: 0.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: FontStyleUtilities.h12(
                              fontColor: ApplicationColors.textColorA6),
                        ),
                        SizedBox(height: 3),
                        SimpleTextField(
                          // readOnly: true,
                          maxLine: 1,
                          keyboardType: TextInputType.emailAddress,
                          controller: _editEmailIdController,
                          // validator: (value) {
                          //   bool validEmail = RegExp(
                          //           r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                          //       .hasMatch(value ?? '');
                          //   if (value == null ||
                          //       value == '') {
                          //     return "Enter email id";
                          //   } else if (validEmail ==
                          //       false) {
                          //     return "Enter valid email id";
                          //   }
                          //   return null;
                          // },
                        ),
                      ],
                    ),
                    Divider(
                      color: ApplicationColors.greenColor,
                      thickness: 3,
                      endIndent: 0.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${getTranslated(context, "mobile_number")}",
                            style: FontStyleUtilities.h12(
                                fontColor: ApplicationColors.textColorA6)),
                        SizedBox(height: 3),
                        SimpleTextField(
                          // readOnly: true,
                          inputFormatter: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          maxLine: 1,
                          keyboardType: TextInputType.phone,
                          controller: _editMobileNumberController,
                          // validator: (value) {
                          //   FocusScope.of(context)
                          //       .unfocus();
                          //   if (value == null ||
                          //       value == '') {
                          //     return "Enter mobile number";
                          //   } else if (value.length < 10) {
                          //     return "Enter valid number";
                          //   } else {
                          //     return null;
                          //   }
                          // },
                        ),
                      ],
                    ),
                    Divider(
                      color: ApplicationColors.greenColor,
                      thickness: 3,
                      endIndent: 0.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${getTranslated(context, "address")}",
                            style: FontStyleUtilities.h12(
                                fontColor: ApplicationColors.textColorA6)),
                        SizedBox(height: 3),
                        SimpleTextField(
                          // readOnly: true,
                          maxLine: 1,
                          controller: _editAddressController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "${getTranslated(context, "enter_address")}";
                            }
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ],
                    ),
                    Divider(
                      color: ApplicationColors.greenColor,
                      thickness: 3,
                      endIndent: 0.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${getTranslated(context, "working_hours")}",
                          style: FontStyleUtilities.h12(
                              fontColor: ApplicationColors.textColorA6),
                        ),
                        SizedBox(height: 3),
                        DropdownButtonFormField(
                            // value: workingHoursValue,
                            iconEnabledColor: ApplicationColors.redColor67,
                            isDense: true,
                            isExpanded: true,
                            onChanged: (val) {
                              setState(() {
                                workingHoursValue = val;
                                print(workingHoursValue);
                              });
                            },
                            dropdownColor: ApplicationColors.whiteColor,
                            decoration: InputDecoration(
                              hintText: workingHoursValue != null
                                  ? "${getTranslated(context, "digital_input")} $workingHoursValue"
                                  : '${getTranslated(context, "select_working_hours")}',
                              labelStyle: FontStyleUtilities.h14(
                                  fontColor: ApplicationColors.black4240),
                              hintStyle: FontStyleUtilities.h14(
                                  fontColor: ApplicationColors.black4240),
                              contentPadding: EdgeInsets.only(left: 15),
                              border: InputBorder.none,
                            ),
                            items: [
                              '${getTranslated(context, "digital_1")}',
                              '${getTranslated(context, "digital_2")}',
                            ]
                                .map((String value) => DropdownMenuItem(
                                      child: Text(
                                        value,
                                        style: FontStyleUtilities.h14(
                                            fontColor:
                                                ApplicationColors.black4240,
                                            fontFamily: 'Poppins-Regular'),
                                      ),
                                      value: value,
                                    ))
                                .toList()),
                      ],
                    ),
                    Divider(
                      color: ApplicationColors.greenColor,
                      thickness: 3,
                      endIndent: 0.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${getTranslated(context, "time_zone")}",
                          style: FontStyleUtilities.h12(
                              fontColor: ApplicationColors.textColorA6),
                        ),
                        SizedBox(height: 3),
                        DropdownButtonFormField<String>(
                            // value: timeZoneValue,
                            iconEnabledColor: ApplicationColors.redColor67,
                            isDense: true,
                            isExpanded: true,
                            onChanged: (val) {
                              setState(() {
                                timeZoneValue = val;
                              });
                            },
                            dropdownColor: ApplicationColors.whiteColor,
                            decoration: InputDecoration(
                              hintText: timeZoneValue != null
                                  ? timeZoneValue
                                  : "${getTranslated(context, "select_time_zone")}",
                              labelStyle: FontStyleUtilities.h14(
                                  fontColor: ApplicationColors.black4240),
                              hintStyle: FontStyleUtilities.h14(
                                  fontColor: ApplicationColors.black4240),
                              contentPadding: EdgeInsets.only(left: 15),
                              border: InputBorder.none,

                              // enabledBorder: OutlineInputBorder(
                              //   borderSide: BorderSide(color: ApplicationColors.dropdownColor3D),
                              //   borderRadius: BorderRadius.circular(10),
                              // ),
                            ),
                            items: timeZonelist
                                .map((String value) => DropdownMenuItem(
                                      child: Text(
                                        value,
                                        style: FontStyleUtilities.h14(
                                            fontColor:
                                                ApplicationColors.black4240,
                                            fontFamily: 'Poppins-Regular'),
                                      ),
                                      value: value,
                                    ))
                                .toList()),
                      ],
                    ),
                    Divider(
                      color: ApplicationColors.greenColor,
                      thickness: 3,
                      endIndent: 0.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${getTranslated(context, "Announcement")}",
                          style: FontStyleUtilities.h12(
                              fontColor: ApplicationColors.textColorA6),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              height: 16,
                              width: 16,
                              child: Checkbox(
                                  side: BorderSide(
                                      color: showLabel
                                          ? ApplicationColors.redColor67
                                          : ApplicationColors.redColor67),
                                  activeColor: ApplicationColors.redColor67,
                                  checkColor: ApplicationColors.whiteColor,
                                  shape: RoundedRectangleBorder(
                                    // side: BorderSide(color: ApplicationColors.lightBlueColorB3),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  value: showLabel,
                                  onChanged: (bool value) {
                                    setState(() {
                                      showLabel = value;
                                    });
                                  }),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "${getTranslated(context, "Show_Label")}",
                              style: FontStyleUtilities.h12(
                                  fontColor: ApplicationColors.textColorA6),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            SizedBox(
                              height: 16,
                              width: 16,
                              child: Checkbox(
                                  side: BorderSide(
                                      color: driverManagementLabel
                                          ? ApplicationColors.redColor67
                                          : ApplicationColors.redColor67),
                                  activeColor: ApplicationColors.redColor67,
                                  checkColor: ApplicationColors.whiteColor,
                                  shape: RoundedRectangleBorder(
                                    // side: BorderSide(color: ApplicationColors.lightBlueColorB3),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  value: driverManagementLabel,
                                  onChanged: (bool value) {
                                    setState(() {
                                      driverManagementLabel = value;
                                    });
                                  }),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "${getTranslated(context, "Driver_Management")}",
                              style: FontStyleUtilities.h12(
                                  fontColor: ApplicationColors.textColorA6),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<String> timeZonelist = [
    "Africa/Abidjan",
    "Africa/Accra",
    "Africa/Algiers",
    "Africa/Bissau",
    "Africa/Cairo",
    "Africa/Casablanca",
    "Africa/Ceuta",
    "Africa/El_Aaiun",
    "Africa/Johannesburg",
    "Africa/Juba",
    "Africa/Khartoum",
    "Africa/Lagos",
    "Africa/Maputo",
    "Africa/Monrovia",
    "Africa/Nairobi",
    "Africa/Ndjamena",
    "Africa/Sao_Tome",
    "Africa/Tripoli",
    "Africa/Tunis",
    "Africa/Windhoek",
    "America/Adak",
    "America/Anchorage",
    "America/Araguaina",
    "America/Argentina/Buenos_Aires",
    "America/Argentina/Catamarca",
    "America/Argentina/Cordoba",
    "America/Argentina/Jujuy",
    "America/Argentina/La_Rioja",
    "America/Argentina/Mendoza",
    "America/Argentina/Rio_Gallegos",
    "America/Argentina/Salta",
    "America/Argentina/San_Juan",
    "America/Argentina/San_Luis",
    "America/Argentina/Tucuman",
    "America/Argentina/Ushuaia",
    "America/Asuncion",
    "America/Atikokan",
    "America/Bahia",
    "America/Bahia_Banderas",
    "America/Barbados",
    "America/Belem",
    "America/Belize",
    "America/Blanc-Sablon",
    "America/Boa_Vista",
    "America/Bogota",
    "America/Boise",
    "America/Cambridge_Bay",
    "America/Campo_Grande",
    "America/Cancun",
    "America/Caracas",
    "America/Cayenne",
    "America/Chicago",
    "America/Chihuahua",
    "America/Costa_Rica",
    "America/Creston",
    "America/Cuiaba",
    "America/Curacao",
    "America/Danmarkshavn",
    "America/Dawson",
    "America/Dawson_Creek",
    "America/Denver",
    "America/Detroit",
    "America/Edmonton",
    "America/Eirunepe",
    "America/El_Salvador",
    "America/Fort_Nelson",
    "America/Fortaleza",
    "America/Glace_Bay",
    "America/Goose_Bay",
    "America/Grand_Turk",
    "America/Guatemala",
    "America/Guayaquil",
    "America/Guyana",
    "America/Halifax",
    "America/Havana",
    "America/Hermosillo",
    "America/Indiana/Indianapolis",
    "America/Indiana/Knox",
    "America/Indiana/Marengo",
    "America/Indiana/Petersburg",
    "America/Indiana/Tell_City",
    "America/Indiana/Vevay",
    "America/Indiana/Vincennes",
    "America/Indiana/Winamac",
    "America/Inuvik",
    "America/Iqaluit",
    "America/Jamaica",
    "America/Juneau",
    "America/Kentucky/Louisville",
    "America/Kentucky/Monticello",
    "America/La_Paz",
    "America/Lima",
    "America/Los_Angeles",
    "America/Maceio",
    "America/Managua",
    "America/Manaus",
    "America/Martinique",
    "America/Matamoros",
    "America/Mazatlan",
    "America/Menominee",
    "America/Merida",
    "America/Metlakatla",
    "America/Mexico_City",
    "America/Miquelon",
    "America/Moncton",
    "America/Monterrey",
    "America/Montevideo",
    "America/Nassau",
    "America/New_York",
    "America/Nipigon",
    "America/Nome",
    "America/Noronha",
    "America/North_Dakota/Beulah",
    "America/North_Dakota/Center",
    "America/North_Dakota/New_Salem",
    "America/Nuuk",
    "America/Ojinaga",
    "America/Panama",
    "America/Pangnirtung",
    "America/Paramaribo",
    "America/Phoenix",
    "America/Port-au-Prince",
    "America/Port_of_Spain",
    "America/Porto_Velho",
    "America/Puerto_Rico",
    "America/Punta_Arenas",
    "America/Rainy_River",
    "America/Rankin_Inlet",
    "America/Recife",
    "America/Regina",
    "America/Resolute",
    "America/Rio_Branco",
    "America/Santarem",
    "America/Santiago",
    "America/Santo_Domingo",
    "America/Sao_Paulo",
    "America/Scoresbysund",
    "America/Sitka",
    "America/St_Johns",
    "America/Swift_Current",
    "America/Tegucigalpa",
    "America/Thule",
    "America/Thunder_Bay",
    "America/Tijuana",
    "America/Toronto",
    "America/Vancouver",
    "America/Whitehorse",
    "America/Winnipeg",
    "America/Yakutat",
    "America/Yellowknife",
    "Antarctica/Casey",
    "Antarctica/Davis",
    "Antarctica/DumontDUrville",
    "Antarctica/Macquarie",
    "Antarctica/Mawson",
    "Antarctica/Palmer",
    "Antarctica/Rothera",
    "Antarctica/Syowa",
    "Antarctica/Troll",
    "Antarctica/Vostok",
    "Asia/Almaty",
    "Asia/Amman",
    "Asia/Anadyr",
    "Asia/Aqtau",
    "Asia/Aqtobe",
    "Asia/Ashgabat",
    "Asia/Atyrau",
    "Asia/Baghdad",
    "Asia/Baku",
    "Asia/Bangkok",
    "Asia/Barnaul",
    "Asia/Beirut",
    "Asia/Bishkek",
    "Asia/Brunei",
    "Asia/Chita",
    "Asia/Choibalsan",
    "Asia/Colombo",
    "Asia/Damascus",
    "Asia/Dhaka",
    "Asia/Dili",
    "Asia/Dubai",
    "Asia/Dushanbe",
    "Asia/Famagusta",
    "Asia/Gaza",
    "Asia/Hebron",
    "Asia/Ho_Chi_Minh",
    "Asia/Hong_Kong",
    "Asia/Hovd",
    "Asia/Irkutsk",
    "Asia/Jakarta",
    "Asia/Jayapura",
    "Asia/Jerusalem",
    "Asia/Kabul",
    "Asia/Kamchatka",
    "Asia/Karachi",
    "Asia/Kathmandu",
    "Asia/Khandyga",
    "Asia/Kolkata",
    "Asia/Krasnoyarsk",
    "Asia/Kuala_Lumpur",
    "Asia/Kuching",
    "Asia/Macau",
    "Asia/Magadan",
    "Asia/Makassar",
    "Asia/Manila",
    "Asia/Nicosia",
    "Asia/Novokuznetsk",
    "Asia/Novosibirsk",
    "Asia/Omsk",
    "Asia/Oral",
    "Asia/Pontianak",
    "Asia/Pyongyang",
    "Asia/Qatar",
    "Asia/Qostanay",
    "Asia/Qyzylorda",
    "Asia/Riyadh",
    "Asia/Sakhalin",
    "Asia/Samarkand",
    "Asia/Seoul",
    "Asia/Shanghai",
    "Asia/Singapore",
    "Asia/Srednekolymsk",
    "Asia/Taipei",
    "Asia/Tashkent",
    "Asia/Tbilisi",
    "Asia/Tehran",
    "Asia/Thimphu",
    "Asia/Tokyo",
    "Asia/Tomsk",
    "Asia/Ulaanbaatar",
    "Asia/Urumqi",
    "Asia/Ust-Nera",
    "Asia/Vladivostok",
    "Asia/Yakutsk",
    "Asia/Yangon",
    "Asia/Yekaterinburg",
    "Asia/Yerevan",
    "Atlantic/Azores",
    "Atlantic/Bermuda",
    "Atlantic/Canary",
    "Atlantic/Cape_Verde",
    "Atlantic/Faroe",
    "Atlantic/Madeira",
    "Atlantic/Reykjavik",
    "Atlantic/South_Georgia",
    "Atlantic/Stanley",
    "Australia/Adelaide",
    "Australia/Brisbane",
    "Australia/Broken_Hill",
    "Australia/Darwin",
    "Australia/Eucla",
    "Australia/Hobart",
    "Australia/Lindeman",
    "Australia/Lord_Howe",
    "Australia/Melbourne",
    "Australia/Perth",
    "Australia/Sydney",
    "CET",
    "CST6CDT",
    "EET",
    "EST",
    "EST5EDT",
    "Etc/GMT",
    "Etc/GMT+1",
    "Etc/GMT+10",
    "Etc/GMT+11",
    "Etc/GMT+12",
    "Etc/GMT+2",
    "Etc/GMT+3",
    "Etc/GMT+4",
    "Etc/GMT+5",
    "Etc/GMT+6",
    "Etc/GMT+7",
    "Etc/GMT+8",
    "Etc/GMT+9",
    "Etc/GMT-1",
    "Etc/GMT-10",
    "Etc/GMT-11",
    "Etc/GMT-12",
    "Etc/GMT-13",
    "Etc/GMT-14",
    "Etc/GMT-2",
    "Etc/GMT-3",
    "Etc/GMT-4",
    "Etc/GMT-5",
    "Etc/GMT-6",
    "Etc/GMT-7",
    "Etc/GMT-8",
    "Etc/GMT-9",
    "Etc/UTC",
    "Europe/Amsterdam",
    "Europe/Andorra",
    "Europe/Astrakhan",
    "Europe/Athens",
    "Europe/Belgrade",
    "Europe/Berlin",
    "Europe/Brussels",
    "Europe/Bucharest",
    "Europe/Budapest",
    "Europe/Chisinau",
    "Europe/Copenhagen",
    "Europe/Dublin",
    "Europe/Gibraltar",
    "Europe/Helsinki",
    "Europe/Istanbul",
    "Europe/Kaliningrad",
    "Europe/Kiev",
    "Europe/Kirov",
    "Europe/Lisbon",
    "Europe/London",
    "Europe/Luxembourg",
    "Europe/Madrid",
    "Europe/Malta",
    "Europe/Minsk",
    "Europe/Monaco",
    "Europe/Moscow",
    "Europe/Oslo",
    "Europe/Paris",
    "Europe/Prague",
    "Europe/Riga",
    "Europe/Rome",
    "Europe/Samara",
    "Europe/Saratov",
    "Europe/Simferopol",
    "Europe/Sofia",
    "Europe/Stockholm",
    "Europe/Tallinn",
    "Europe/Tirane",
    "Europe/Ulyanovsk",
    "Europe/Uzhgorod",
    "Europe/Vienna",
    "Europe/Vilnius",
    "Europe/Volgograd",
    "Europe/Warsaw",
    "Europe/Zaporozhye",
    "Europe/Zurich",
    "HST",
    "Indian/Chagos",
    "Indian/Christmas",
    "Indian/Cocos",
    "Indian/Kerguelen",
    "Indian/Mahe",
    "Indian/Maldives",
    "Indian/Mauritius",
    "Indian/Reunion",
    "MET",
    "MST",
    "MST7MDT",
    "PST8PDT",
    "Pacific/Apia",
    "Pacific/Auckland",
    "Pacific/Bougainville",
    "Pacific/Chatham",
    "Pacific/Chuuk",
    "Pacific/Easter",
    "Pacific/Efate",
    "Pacific/Enderbury",
    "Pacific/Fakaofo",
    "Pacific/Fiji",
    "Pacific/Funafuti",
    "Pacific/Galapagos",
    "Pacific/Gambier",
    "Pacific/Guadalcanal",
    "Pacific/Guam",
    "Pacific/Honolulu",
    "Pacific/Kiritimati",
    "Pacific/Kosrae",
    "Pacific/Kwajalein",
    "Pacific/Majuro",
    "Pacific/Marquesas",
    "Pacific/Nauru",
    "Pacific/Niue",
    "Pacific/Norfolk",
    "Pacific/Noumea",
    "Pacific/Pago_Pago",
    "Pacific/Palau",
    "Pacific/Pitcairn",
    "Pacific/Pohnpei",
    "Pacific/Port_Moresby",
    "Pacific/Rarotonga",
    "Pacific/Tahiti",
    "Pacific/Tarawa",
    "Pacific/Tongatapu",
    "Pacific/Wake",
    "Pacific/Wallis",
    "WET"
  ];
}
