import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/TypeModel.dart';
import 'package:oneqlik/Model/vehicle_list_model.dart';
import 'package:oneqlik/Provider/vehicle_list_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:oneqlik/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UploadDocumentPage extends StatefulWidget {

  VehicleLisDevice vehicleLisDevice;
   UploadDocumentPage({Key key,this.vehicleLisDevice}) : super(key: key);

  @override
  _UploadDocumentPageState createState() => _UploadDocumentPageState();
}

class _UploadDocumentPageState extends State<UploadDocumentPage> {

  TextEditingController datedController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();


  String selectedtype;
  var exDate = "";

  GlobalKey<FormState> key = GlobalKey();
  VehicleListProvider vehicleListProvider;

  updateDocument() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    var mobileNumber = decodedToken['phn'] ;
    var data = {
      "imageDoc": {
        "name": nameController.text,
        "type": "$selectedtype",
        "date": "${DateTime.now().toUtc()}",
        "image": profileImage,
        "expDate": "$exDate",
        "phone": "$mobileNumber",
        "number": phoneController.text,
      },
      "device": "${widget.vehicleLisDevice.id}"
    };

    print(jsonEncode(data));
    await vehicleListProvider.uploadDoc(data, "document/add", context,);
  }


  PickedFile _image;
  var profileImage;
  File PickImage;
  bool isLoading = false,imageValid = false;

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
                              Icon(Icons.camera, color: ApplicationColors.redColor67),
                              Padding(
                                padding: EdgeInsets.only(left: height * 0.02),
                              ),
                              Text(
                                "${getTranslated(context, "camera")}",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Poppins-Regular",
                                    color: ApplicationColors.whiteColor
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          dense: true,
                          onTap: () =>
                              Navigator.pop(context, ImageSource.gallery),
                          title: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: height * 0.02),
                              ),
                              Icon(Icons.sd_storage, color: ApplicationColors.redColor67),
                              Padding(
                                padding: EdgeInsets.only(left: height * 0.02),
                              ),
                              Text(
                                "${getTranslated(context, "gallery")}",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Poppins-Regular",
                                    color: ApplicationColors.whiteColor
                                ),
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
      final file = await ImagePicker.platform.pickImage(source: imageSource,imageQuality: 50);
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
          imageValid = false;
        });

        Navigator.pop(context);
        print("Image Upload");

      } else {
        print(request);
        Navigator.pop(context);
        print("Fail!!");
        setState(() {
          _image = null;
          PickImage = null;
          profileImage = null;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    vehicleListProvider = Provider.of<VehicleListProvider>(context,listen: false);
  }

  @override
  Widget build(BuildContext context) {

    vehicleListProvider = Provider.of<VehicleListProvider>(context,listen: true);

    var height = MediaQuery.of(context).size.height;
    var  width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: ApplicationColors.whiteColorF9
            /*color: ApplicationColors.whiteColorF9*/
          ),
        ),
        Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: InkWell(
                onTap: () {

                  if(key.currentState.validate() && profileImage != null){
                    updateDocument();
                  }else{
                    setState(() {
                      imageValid = true;
                    });
                  }

                },
                child: Container(
                  decoration: Boxdec.buttonBoxDecRed_r6,
                  width: width,
                  height: height * .057,
                  child: Center(
                      child: Text(
                        "${getTranslated(context, "submit")}",
                        style: Textstyle1.text18bold.copyWith(color: Colors.white),
                      ),
                  ),
                ),
            ),
          ),
          appBar: AppBar(
            titleSpacing: -8,
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
              "${getTranslated(context, "upload_document")}",
              style: Textstyle1.appbartextstyle1,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                color: ApplicationColors.blackColor2E,
                borderRadius: BorderRadius.circular(9)
            ),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: SingleChildScrollView(
              child:  Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      "${getTranslated(context, "select_document_Type")}",
                      style: Textstyle1.text14,
                    ),

                    SizedBox(height: 10),
                    DropdownButtonFormField<TypeModel>(
                        iconEnabledColor: ApplicationColors.redColor,
                        hint: Text(
                          "${getTranslated(context, "select_type")}",
                          style: Textstyle1.text12,
                        ),
                        isExpanded: true,
                        isDense: true,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                              gapPadding: 25,
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              )),
                          focusedErrorBorder: OutlineInputBorder(
                              gapPadding: 25,
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              )),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ApplicationColors.dropdownColor3D),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: ApplicationColors.redColor67),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusColor: ApplicationColors.redColor67,
                          filled: true,
                          fillColor: ApplicationColors.blackColor2E,
                          isDense: true,
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'IBMPlexSans-Regular',
                              fontSize: 10),
                        ),
                        dropdownColor: ApplicationColors.dropdownColor3D,
                        validator: (value){
                          if( value == null){
                            return "${getTranslated(context, "please_select_document")}";

                          }
                          return null;
                        },
                        onChanged: (TypeModel newValue) {
                          setState(() {
                            selectedtype = newValue.name;
                            nameController.text = selectedtype;
                          });
                        },
                        items: vehicleListProvider.docTypeList.map<DropdownMenuItem<TypeModel>>((TypeModel value) {
                          return DropdownMenuItem<TypeModel>(
                            value:value,
                            child: Text(value.name,style:Textstyle1.text12),
                          );
                        }).toList(),
                        style: Textstyle1.text12
                    ),
                    SizedBox(height: 20),

                    Text(
                      "${getTranslated(context, "document_name")}",
                      style: Textstyle1.text14,
                    ),

                    SizedBox(height: 5),
                    CustomTextField(
                        textAlign: TextAlign.start,
                        controller: nameController,
                        filled: false,
                        borderColor: ApplicationColors.dropdownColor3D,
                        hintText: "${getTranslated(context, "name")}",
                        fillColor: Colors.transparent,
                        validator: (value) {
                          FocusScope.of(context).unfocus();
                          if (value == null || value == '') {
                            return "${getTranslated(context, "enter_document_name")}";
                          }
                          else if (value.length < 3) {
                            return "${getTranslated(context, "enter_valid_name")}";
                          }
                          else {
                            return null;
                          }
                      },
                      focusedBorder:  ApplicationColors.redColor67
                    ),
                    SizedBox(height: 20),

                    SizedBox(height: 5),
                    Text(
                      "${getTranslated(context, "document_number")}",
                      style: Textstyle1.text14,
                    ),

                    SizedBox(height: 5),
                    CustomTextField(
                      textAlign: TextAlign.start,
                      filled: false,
                      controller: phoneController,
                      borderColor: ApplicationColors.dropdownColor3D,
                      focusedBorder:  ApplicationColors.redColor67,
                      hintText: "${getTranslated(context, "document_no")}",
                      validator:
                          (value) {
                        FocusScope.of(context).unfocus();
                        if (value == null || value == '') {
                          return "${getTranslated(context, "enter_document_number")}";
                        } else {
                          return null;
                        }
                      },
                    ),

                    SizedBox(height: 20),

                    Text(
                      "${getTranslated(context, "upload")}",
                      style: Textstyle1.text14,
                    ),

                    SizedBox(height: 10),
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              _optionDialogBox();
                            },
                            child: Container(
                              padding: EdgeInsets.all(30),
                              decoration: Boxdec.conrad6colorblack.copyWith(
                                  border: Border.all(
                                      color:  imageValid ? ApplicationColors.redColor : ApplicationColors.dropdownColor3D,
                                  ),
                              ),
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                "assets/images/plus_icon.png",
                                color: imageValid ? ApplicationColors.redColor : ApplicationColors.dropdownColor3D,
                              ),
                            )),

                        SizedBox(
                          width: 10,
                        ),

                        PickImage != null
                            ?
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: Boxdec.conrad6colorblack.copyWith(
                              border: Border.all(
                                  color:
                                  ApplicationColors.dropdownColor3D)),
                          width: 100,
                          height: 100,
                          child: Image.file(
                              PickImage,
                            fit: BoxFit.contain,
                          ),
                        )
                            :
                        SizedBox(
                          width: 0,
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Text(
                      "${getTranslated(context, "expire_date")}",
                      style: Textstyle1.text14,
                    ),

                    SizedBox(height: 10),
                    TextFormField(
                      readOnly: true,
                      style: Textstyle1.signupText.copyWith(
                        color: ApplicationColors.whiteColor
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return "${getTranslated(context, "select_document_expire_date")}";

                      }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      controller: datedController,
                      focusNode: AlwaysDisabledFocusNode(),
                      onTap: () async {
                        FocusScope.of(context).unfocus();

                        DateTime newSelectedDate = await _selecttDate(context);
                        if (newSelectedDate != null) {
                          setState(() {
                            datedController.text = DateFormat("dd MMM yyyy").format(newSelectedDate);
                            exDate = newSelectedDate.toUtc().toString();
                            print(exDate);
                          });
                        }
                      },
                      decoration: fieldStyle.copyWith(
                        hintText: "${getTranslated(context, "dd_mm_yyyy")}",
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(17.0),
                          child: Image.asset(
                            "assets/images/date_icon.png",color: ApplicationColors.redColor67,
                            width: 10,
                          ),
                        ),
                        hintStyle: Textstyle1.signupText.copyWith(
                          color: Colors.white,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _selecttDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.light(
                primary: ApplicationColors.redColor67,
                onPrimary: Colors.white,
                surface: ApplicationColors.redColor67,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        });
    return newSelectedDate;
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
