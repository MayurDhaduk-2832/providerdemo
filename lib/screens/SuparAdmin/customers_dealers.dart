import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/customer_dealer_provider.dart';
import 'package:oneqlik/Provider/reports_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/SuparAdmin/addCustomer.dart';
import 'package:oneqlik/screens/SuparAdmin/addDealers.dart';
import 'package:oneqlik/screens/SuparAdmin/updateCustomer.dart';
import 'package:oneqlik/screens/SuparAdmin/updateDealers.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomersDealers extends StatefulWidget {
  bool isDealer;

  CustomersDealers({Key key, this.isDealer}) : super(key: key);

  @override
  State<CustomersDealers> createState() => _CustomersDealersState();
}

class _CustomersDealersState extends State<CustomersDealers> {
  ReportProvider _reportProvider;
  CustomerDealerProvider customerDealerProvider;
  var selectValue = "Customers";
  bool isCustomer = false;
  bool showSearchBar = false;
  int customerPage = 1;
  int dealerPage = 1;

  ScrollController _scrollViewController = ScrollController();
  ScrollController _scrollViewController1 = ScrollController();
  TextEditingController searchCustomerDealerCtr = TextEditingController();
  FocusNode focusNode = FocusNode();

  getDeviceByUserDropdown() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");
    var email = sharedPreferences.getString("email");

    var data = {"email": email, "id": id};

    await _reportProvider.getVehicleDropdown(
        data, "devices/getDeviceByUserDropdown");
  }

  bool showAll = false;

  void clearCustomer() {
    if (customerDealerProvider.customerList != null &&
        customerDealerProvider.customerList.isNotEmpty) {
      customerDealerProvider.customerList.clear();
      setState(() {});
    }
  }

  void clearDealer() {
    if (customerDealerProvider.dealerList != null &&
        customerDealerProvider.dealerList.isNotEmpty) {
      customerDealerProvider.dealerList.clear();
      setState(() {});
    }
  }

  getCustomer(customerPage) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");

    var data = {
      "uid": id,
      "pageNo": "$customerPage",
      "size": "10",
      "all": "$showAll",
    };
    if (searchCustomerDealerCtr.text.isNotEmpty) {
      data["search"] = searchCustomerDealerCtr.text;
    }

    await customerDealerProvider.getCustomer(data, "users/getCustomer");
  }

  getDealer(dealerPage) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("uid");

    var data = {
      "supAdmin": id,
      "pageNo": "$dealerPage",
      "size": "10",
    };
    if (searchCustomerDealerCtr.text.isNotEmpty) {
      data["search"] = searchCustomerDealerCtr.text;
    }
    await customerDealerProvider.getDealer(data, "users/getDealers");
  }

  deleteDealer(id) async {
    var data = {
      "userId": id,
      "deleteuser": true,
    };

    print(data);
    await customerDealerProvider.deleteDealer(
        data, "users/deleteUser", context);
  }

  deleteCustomer(id) async {
    var data = {
      "userId": id,
      "deleteuser": true,
    };

    print(data);
    await customerDealerProvider.deleteCustomer(
        data, "users/deleteUser", context, showAll);
  }

  showDialogBox(data, id) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return AlertDialog(
              backgroundColor: ApplicationColors.blackColor2E,
              titlePadding: EdgeInsets.zero,
              title: Container(
                decoration: BoxDecoration(
                  color: ApplicationColors.blackColor2E,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${getTranslated(context, "active")}",
                              style: Textstyle1.text14bold,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          FlutterSwitch(
                            toggleSize: 10,
                            padding: 2,
                            height: height * .021,
                            width: width * .09,
                            switchBorder: Border.all(color: Colors.white),
                            activeColor: ApplicationColors.blackColor2E,
                            activeToggleColor: ApplicationColors.redColor67,
                            toggleColor: ApplicationColors.white9F9,
                            inactiveColor: ApplicationColors.blackColor2E,
                            value: isActive,
                            onToggle: (val) {
                              setState(() {
                                isActive = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: ApplicationColors.textfieldBorderColor,
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          if (selectValue == "Customers") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        UpdateCustomer(
                                          firstName: data["firstname"],
                                          lastName: data["lastname"],
                                          emailId: data["emailid"],
                                          postalCode: data["postalcode"],
                                          mobileNo: data["mobile"],
                                          userId: data["userId"],
                                          id: data["contactId"],
                                          ex: data["expdate"],
                                        )));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        UpdateDealers(
                                          firstName: data["firstname"],
                                          lastName: data["lastname"],
                                          emailId: data["emailid"],
                                          postalCode: data["postalcode"],
                                          mobileNo: data["mobile"],
                                          userId: data["userId"],
                                          id: data["contactId"],
                                          expDate: data["expdate"],
                                          address: data["address"],
                                        )));
                          }
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/Edit_icon.png',
                              color: ApplicationColors.redColor67,
                              width: 20,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "${getTranslated(context, "edit")}",
                              style: Textstyle1.text14,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: InkWell(
                        onTap: () {
                          if (selectValue == "Customers") {
                            deleteCustomer(id);
                          } else {
                            deleteDealer(id);
                          }
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/delete_icon.png',
                              color: ApplicationColors.redColor67,
                              width: 20,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "${getTranslated(context, "delete")}",
                              style: Textstyle1.text14,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool isActive = false;

  @override
  void initState() {
    super.initState();

    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    customerDealerProvider =
        Provider.of<CustomerDealerProvider>(context, listen: false);

    getDeviceByUserDropdown();
    getCustomer(1);
    getDealer(1);

    customerDealerProvider.customerList.clear();
    customerDealerProvider.dealerList.clear();

    customerDealerProvider.changePageBool(false);
    customerDealerProvider.changeDPageBool(false);

    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!customerDealerProvider.isSucces1) {
          customerPage = customerPage + 1;
          getCustomer(customerPage);
        }
      }
    });

    _scrollViewController1.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!customerDealerProvider.isSucces) {
          dealerPage = dealerPage + 1;
          getDealer(dealerPage);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _reportProvider = Provider.of<ReportProvider>(context, listen: true);
    customerDealerProvider =
        Provider.of<CustomerDealerProvider>(context, listen: true);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_sharp,
            color: ApplicationColors.whiteColor,
            size: 26,
          ),
        ),
        title: Text(
          widget.isDealer == true
              ? "${getTranslated(context, "customer")}"
              : "${getTranslated(context, "customer_dealers")}",
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
          InkWell(
            onTap: () {
              if (widget.isDealer) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AddDealers()));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AddCustomer()));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.add,
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
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(),
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              elevation: 4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Card(
                  elevation: 3,
                  child: TextFormField(
                    controller: searchCustomerDealerCtr,
                    focusNode: focusNode,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      if (value != null && value.length > 2) {
                        if (selectValue == "Customers") {
                          clearCustomer();
                          getCustomer(1);
                        } else {
                          clearDealer();
                          getDealer(1);
                        }
                      } else if (value.isEmpty) {
                        print("value");
                        if (selectValue == "Customers") {
                          clearCustomer();
                          getCustomer(1);
                        } else {
                          clearDealer();
                          getDealer(1);
                        }
                      }
                    },
                    style: FontStyleUtilities.h14(
                      fontColor: ApplicationColors.blackColor00,
                    ),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      fillColor: ApplicationColors.whiteColor,
                      labelStyle: TextStyle(
                        color: ApplicationColors.whiteColor,
                        fontSize: 15,
                        fontFamily: "Poppins-Regular",
                        letterSpacing: 0.75,
                      ),
                      hintText: selectValue == "Customers"
                          ? "${getTranslated(context, "search_customer")}"
                          : "${getTranslated(context, "search_dealer")}",
                      hintStyle: TextStyle(
                        color: ApplicationColors.black4240,
                        fontSize: 14,
                        fontFamily: "Poppins-Regular",
                        letterSpacing: 0.75,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset(
                          'assets/images/search_icon.png',
                          color: Colors.grey,
                          width: 8,
                        ),
                      ),
                      suffixIcon: searchCustomerDealerCtr.text.isEmpty
                          ? SizedBox()
                          : InkWell(
                              onTap: () {
                                searchCustomerDealerCtr.clear();
                                focusNode.unfocus();
                                if (selectValue == "Customers") {
                                  clearCustomer();
                                  getCustomer(1);
                                } else {
                                  clearDealer();
                                  getDealer(1);
                                }
                              },
                              child: Icon(
                                Icons.cancel_outlined,
                                color: ApplicationColors.redColor67,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),

            Visibility(
              visible: !widget.isDealer,
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                        color: ApplicationColors.textfieldBorderColor)),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (selectValue != "Customers") {
                            selectValue = "Customers";
                            setState(() {});
                            if (searchCustomerDealerCtr.text.isNotEmpty) {
                              searchCustomerDealerCtr.clear();
                              focusNode.unfocus();
                              if (customerDealerProvider.dealerList != null &&
                                  customerDealerProvider
                                      .dealerList.isNotEmpty) {
                                customerDealerProvider.dealerList.clear();
                              }
                              getDealer(1);
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selectValue == "Customers"
                                ? ApplicationColors.redColor67
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            "${getTranslated(context, "customers")}",
                            style: FontStyleUtilities.h14(
                                fontColor: selectValue == "Customers"
                                    ? ApplicationColors.whiteColor
                                    : ApplicationColors.black4240),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (selectValue != "Dealers") {
                            selectValue = "Dealers";
                            setState(() {});
                            if (searchCustomerDealerCtr.text.isNotEmpty) {
                              searchCustomerDealerCtr.clear();
                              focusNode.unfocus();
                              if (customerDealerProvider.customerList != null &&
                                  customerDealerProvider
                                      .customerList.isNotEmpty) {
                                customerDealerProvider.customerList.clear();
                              }
                              getCustomer(1);
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selectValue == "Dealers"
                                ? ApplicationColors.redColor67
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            "${getTranslated(context, "dealers")}",
                            style: FontStyleUtilities.h14(
                                fontColor: selectValue == "Dealers"
                                    ? ApplicationColors.whiteColor
                                    : ApplicationColors.black4240),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            selectValue == "Customers"
                ? Visibility(
                    visible: !widget.isDealer,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${getTranslated(context, "includes_customer")}",
                                  style: FontStyleUtilities.h14(
                                      fontColor:
                                          ApplicationColors.blackbackcolor,
                                      fontweight: FWT.light),
                                ),
                              ),
                              SizedBox(width: 10),
                              FlutterSwitch(
                                toggleSize: 10,
                                padding: 2,
                                height: height * .021,
                                width: width * .09,
                                switchBorder: Border.all(color: Colors.black54),
                                activeColor: ApplicationColors.whiteColor,
                                activeToggleColor: ApplicationColors.redColor67,
                                toggleColor: ApplicationColors.black4240,
                                inactiveColor: ApplicationColors.whiteColor,
                                value: showAll,
                                onToggle: (val) {
                                  setState(() {
                                    customerPage = 1;
                                    customerDealerProvider
                                        .changePageBool(false);
                                    customerDealerProvider.customerList.clear();
                                    showAll = val;
                                    getCustomer(1);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  )
                : SizedBox(),

            // Customers list
            selectValue == "Customers"
                ? customerDealerProvider.isPageLoading == false
                    ? Expanded(child: Helper.dialogCall.showLoader())
                    : customerDealerProvider.customerList.isEmpty
                        ? Expanded(
                            child: Center(
                              child: Text(
                                "${getTranslated(context, "customer_list_not_available")}",
                                textAlign: TextAlign.center,
                                style: Textstyle1.text18.copyWith(
                                  fontSize: 18,
                                  color: ApplicationColors.redColor67,
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                                controller: _scrollViewController,
                                physics: BouncingScrollPhysics(),
                                itemCount:
                                    customerDealerProvider.customerList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var list = customerDealerProvider
                                      .customerList[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(6),
                                              height: 80,
                                              width: 80,
                                              child: Image.asset(
                                                "assets/images/costomers.png",
                                                color: ApplicationColors
                                                    .redColor67,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "${list.firstName}\n${list.lastName}",
                                                    style: FontStyleUtilities.h14(
                                                        fontColor:
                                                            ApplicationColors
                                                                .blackbackcolor,
                                                        fontweight: FWT.light),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.start),
                                                Text(
                                                    "${getTranslated(context, "userid")}: ${list.userId}",
                                                    style: FontStyleUtilities.h14(
                                                        fontColor:
                                                            ApplicationColors
                                                                .blackbackcolor,
                                                        fontweight: FWT.light),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.start),
                                                Text(
                                                    "${getTranslated(context, "password")}: ${list.pass}",
                                                    style: FontStyleUtilities.h14(
                                                        fontColor:
                                                            ApplicationColors
                                                                .blackbackcolor,
                                                        fontweight: FWT.light),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.start),
                                                Text(
                                                    list.phone == null
                                                        ? "${getTranslated(context, "contact_number_not_available")}"
                                                        : "+${91 //list.stdCode.dialcode
                                                        } ${list.phone}",
                                                    style: FontStyleUtilities.h14(
                                                        fontColor:
                                                            ApplicationColors
                                                                .blackbackcolor,
                                                        fontweight: FWT.light),
                                                    overflow:
                                                        TextOverflow.visible,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.start),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(width: 20),
                                              InkWell(
                                                onTap: () {
                                                  if (selectValue ==
                                                      "Customers") {
                                                    deleteCustomer(list.id);
                                                  } else {
                                                    deleteDealer(list.id);
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: ApplicationColors
                                                      .redColor67,
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    if (selectValue ==
                                                        "Customers") {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  UpdateCustomer(
                                                                    firstName: list
                                                                        .firstName,
                                                                    lastName: list
                                                                        .lastName,
                                                                    emailId: list
                                                                        .email,
                                                                    postalCode:
                                                                        "",
                                                                    mobileNo: list
                                                                        .phone,
                                                                    userId: list
                                                                        .userId,
                                                                    id: list.id,
                                                                    ex: list
                                                                        .expireDate,
                                                                  )));
                                                    } else {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  UpdateDealers(
                                                                    firstName: list
                                                                        .firstName,
                                                                    lastName: list
                                                                        .lastName,
                                                                    emailId: list
                                                                        .email,
                                                                    postalCode:
                                                                        "",
                                                                    mobileNo: list
                                                                        .phone,
                                                                    userId: list
                                                                        .userId,
                                                                    id: list.id,
                                                                    expDate: list
                                                                        .expireDate,
                                                                    address: "",
                                                                  )));
                                                    }
                                                  },
                                                  child: Text(
                                                    "edit",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                                height: 25,
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    customerDealerProvider
                                                        .showLogoutDialog(
                                                            context,
                                                            {
                                                              "user_id":
                                                                  list.userId,
                                                              "psd": list.pass,
                                                            },
                                                            "users/LoginWithOtp",
                                                            list.firstName +
                                                                " " +
                                                                list.lastName +
                                                                " Customer");
                                                  },
                                                  child: Text(
                                                    "ACTIVE",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                                height: 25,
                                              ),
                                              Spacer(flex: 3),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          )
                : SizedBox(),

            // Dealers list
            selectValue == "Dealers"
                ? customerDealerProvider.isDPageLoading == false
                    ? Expanded(child: Helper.dialogCall.showLoader())
                    : customerDealerProvider.dealerList.isEmpty
                        ? Expanded(
                            child: Center(
                              child: Text(
                                "${getTranslated(context, "dealer_not_available")}",
                                textAlign: TextAlign.center,
                                style: Textstyle1.text18.copyWith(
                                  fontSize: 18,
                                  color: ApplicationColors.redColor67,
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                                controller: _scrollViewController1,
                                physics: BouncingScrollPhysics(),
                                itemCount:
                                    customerDealerProvider.dealerList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var list =
                                      customerDealerProvider.dealerList[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(6),
                                              height: 80,
                                              width: 80,
                                              child: Image.asset(
                                                "assets/images/costomers.png",
                                                color: ApplicationColors
                                                    .redColor67,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "${list.firstName}\n${list.lastName}",
                                                    style: FontStyleUtilities.h14(
                                                        fontColor:
                                                            ApplicationColors
                                                                .blackbackcolor,
                                                        fontweight: FWT.light),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.start),
                                                Text(
                                                    "${getTranslated(context, "userid")}: ${list.userId}",
                                                    style: FontStyleUtilities.h14(
                                                        fontColor:
                                                            ApplicationColors
                                                                .blackbackcolor,
                                                        fontweight: FWT.light),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.start),
                                                Text(
                                                    "${getTranslated(context, "password")}: ${list.pass}",
                                                    style: FontStyleUtilities.h14(
                                                        fontColor:
                                                            ApplicationColors
                                                                .blackbackcolor,
                                                        fontweight: FWT.light),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.start),
                                                Text(
                                                    list.phone == null
                                                        ? "${getTranslated(context, "contact_number_not_available")}"
                                                        : "+${91 //list.stdCode.dialcode
                                                        } ${list.phone}",
                                                    style: FontStyleUtilities.h14(
                                                        fontColor:
                                                            ApplicationColors
                                                                .blackbackcolor,
                                                        fontweight: FWT.light),
                                                    overflow:
                                                        TextOverflow.visible,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.start),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(width: 20),
                                              InkWell(
                                                onTap: () {
                                                  if (selectValue ==
                                                      "Customers") {
                                                    deleteCustomer(list.id);
                                                  } else {
                                                    deleteDealer(list.id);
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: ApplicationColors
                                                      .redColor67,
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    if (selectValue ==
                                                        "Customers") {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  UpdateCustomer(
                                                                    firstName: list
                                                                        .firstName,
                                                                    lastName: list
                                                                        .lastName,
                                                                    emailId: list
                                                                        .email,
                                                                    postalCode:
                                                                        "",
                                                                    mobileNo: list
                                                                        .phone,
                                                                    userId: list
                                                                        .userId,
                                                                    id: list.id,
                                                                    ex: list
                                                                        .expireDate,
                                                                  )));
                                                    } else {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  UpdateDealers(
                                                                    firstName: list
                                                                        .firstName,
                                                                    lastName: list
                                                                        .lastName,
                                                                    emailId: list
                                                                        .email,
                                                                    postalCode:
                                                                        "",
                                                                    mobileNo: list
                                                                        .phone,
                                                                    userId: list
                                                                        .userId,
                                                                    id: list.id,
                                                                    expDate: list
                                                                        .expireDate,
                                                                    address: "",
                                                                  )));
                                                    }
                                                  },
                                                  child: Text(
                                                    "edit",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                                height: 25,
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    customerDealerProvider
                                                        .showLogoutDialog(
                                                            context,
                                                            {
                                                              "emailid":
                                                                  list.email,
                                                              "psd": list.pass,
                                                            },
                                                            "users/LoginWithOtp",
                                                            list.firstName +
                                                                " " +
                                                                list.lastName +
                                                                " Dealer");
                                                  },
                                                  child: Text(
                                                    "ACTIVE",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                                height: 25,
                                              ),
                                              Spacer(flex: 3),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  //   Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 15.0),
                                  //   child: InkWell(
                                  //     onTap: () {
                                  //       customerDealerProvider.showLogoutDialog(
                                  //           context,
                                  //           {
                                  //             "emailid": list.email,
                                  //             "psd": list.pass,
                                  //           },
                                  //           "users/LoginWithOtp",
                                  //           list.firstName +
                                  //               " " +
                                  //               list.lastName +
                                  //               " Dealer");
                                  //     },
                                  //     child: Stack(
                                  //       clipBehavior: Clip.none,
                                  //       alignment: Alignment.center,
                                  //       children: [
                                  //         SizedBox(
                                  //           width: width * 0.90,
                                  //           height: 112,
                                  //         ),
                                  //         Positioned(
                                  //           right: 0,
                                  //           child: Container(
                                  //             padding: EdgeInsets.only(
                                  //                 left: 35,
                                  //                 right: 14,
                                  //                 top: 05,
                                  //                 bottom: 05),
                                  //             height: 93,
                                  //             width: width * 0.88,
                                  //             child: Row(
                                  //               children: [
                                  //                 Expanded(
                                  //                   child: Column(
                                  //                     crossAxisAlignment:
                                  //                         CrossAxisAlignment
                                  //                             .start,
                                  //                     mainAxisAlignment:
                                  //                         MainAxisAlignment
                                  //                             .spaceBetween,
                                  //                     children: [
                                  //                       Text(
                                  //                           "${list.firstName} ${list.lastName}",
                                  //                           style: FontStyleUtilities.h18(
                                  //                               fontColor:
                                  //                                   ApplicationColors
                                  //                                       .blackbackcolor),
                                  //                           maxLines: 1,
                                  //                           textAlign: TextAlign
                                  //                               .start),
                                  //                       Row(
                                  //                         children: [
                                  //                           Text(
                                  //                               "${getTranslated(context, "location")} :",
                                  //                               style: FontStyleUtilities.h11(
                                  //                                   fontColor:
                                  //                                       ApplicationColors
                                  //                                           .blackbackcolor,
                                  //                                   fontweight: FWT
                                  //                                       .light),
                                  //                               overflow:
                                  //                                   TextOverflow
                                  //                                       .ellipsis,
                                  //                               maxLines: 1,
                                  //                               textAlign:
                                  //                                   TextAlign
                                  //                                       .start),
                                  //                           Text(
                                  //                               list.address ==
                                  //                                       null
                                  //                                   ? "No address"
                                  //                                   : "${list.address}",
                                  //                               style: FontStyleUtilities.h11(
                                  //                                   fontColor:
                                  //                                       ApplicationColors
                                  //                                           .blackbackcolor,
                                  //                                   fontweight: FWT
                                  //                                       .light),
                                  //                               overflow:
                                  //                                   TextOverflow
                                  //                                       .ellipsis,
                                  //                               maxLines: 1,
                                  //                               textAlign:
                                  //                                   TextAlign
                                  //                                       .start),
                                  //                         ],
                                  //                       ),
                                  //                       Text(
                                  //                           //"+${list.stdCode.dialcode} ${list.phone}",
                                  //                           "${list.phone}",
                                  //                           style: FontStyleUtilities.h11(
                                  //                               fontColor:
                                  //                                   ApplicationColors
                                  //                                       .blackbackcolor,
                                  //                               fontweight:
                                  //                                   FWT.light),
                                  //                           overflow:
                                  //                               TextOverflow
                                  //                                   .visible,
                                  //                           maxLines: 1,
                                  //                           textAlign: TextAlign
                                  //                               .start),
                                  //                       SizedBox(height: 4),
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //                 InkWell(
                                  //                   onTap: () {
                                  //                     var data = {
                                  //                       "firstname":
                                  //                           list.firstName,
                                  //                       "lastname":
                                  //                           list.lastName,
                                  //                       "emailid": list.email,
                                  //                       "postalcode": list
                                  //                           .stdCode.dialcode,
                                  //                       "mobile": list.phone,
                                  //                       "address": list.address,
                                  //                       "userId": list.userId,
                                  //                       "contactId": list.id,
                                  //                       "expdate":
                                  //                           list.expireDate,
                                  //                     };
                                  //                     showDialogBox(
                                  //                         data, list.id);
                                  //                   },
                                  //                   child: Icon(
                                  //                     Icons.more_vert,
                                  //                     color: ApplicationColors
                                  //                         .redColor67,
                                  //                   ),
                                  //                 )
                                  //               ],
                                  //             ),
                                  //             decoration: BoxDecoration(
                                  //               color: ApplicationColors
                                  //                   .blackColor2E,
                                  //               borderRadius:
                                  //                   BorderRadius.circular(5),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         Positioned(
                                  //           top: 38,
                                  //           left: 0,
                                  //           child: Container(
                                  //             padding: EdgeInsets.all(6),
                                  //             height: 35,
                                  //             width: 35,
                                  //             decoration: BoxDecoration(
                                  //               color: ApplicationColors
                                  //                   .redColor67,
                                  //               borderRadius:
                                  //                   BorderRadius.circular(32),
                                  //             ),
                                  //             child: Image.asset(
                                  //               "assets/images/costomers.png",
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // );
                                }),
                          )
                : SizedBox(),

            customerDealerProvider.isPageLoading == false ||
                    customerDealerProvider.isDPageLoading == false
                ? SizedBox()
                : customerDealerProvider.isCustomerLoading ||
                        customerDealerProvider.isDealerLoading
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Helper.dialogCall.showLoader(),
                            SizedBox(width: 20),
                            Text("${getTranslated(context, "loading_more")}",
                                style: Textstyle1.text14bold)
                          ],
                        ),
                      )
                    : SizedBox(),
          ],
        ),
      ),
    );
  }
}
