
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Provider/group_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/GroupsScreens/add_groups_screen.dart';
import 'package:oneqlik/screens/DashBoardScreen/DrawerPages/GroupsScreens/edit_group_screen.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key key}) : super(key: key);

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {


  bool activeGroups = true;

  GetGroupListProvider getGroupListProvider;

  getGroupDetailsList()async{


    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString("uid");

    var data = {
      "uid":id,
    };

    print("data-->$data");

    getGroupListProvider.getGroupDetailsList(data, "groups/getGroups_list");

  }

  deleteGroup(id) async {
    var data = {
      "_id": "$id",
    };
    print('Delete group -> $data');

    await getGroupListProvider.deleteGroup(data, "groups/deleteGroup",context);
  }

  updateGroups(sendData) async{
    var data = {
      "name": sendData["groupName"],
      "status": activeGroups,
      "logopath": "car",
      "mobileNo": sendData["contactNumber"],
      "_id": sendData["id"]
    };
    await getGroupListProvider.editGroups(data, "groups/updateGroup", context);
  }

  @override
  void initState() {
    super.initState();
    getGroupListProvider = Provider.of<GetGroupListProvider>(context, listen: false);
    Future.delayed(Duration.zero,(){
      getGroupDetailsList();
    });
  }

  showDialogBox(data,id){
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
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
                          switchBorder: Border.all(color: Colors.black54),
                          activeColor: ApplicationColors.whiteColor,
                          activeToggleColor: ApplicationColors.redColor67,
                          toggleColor: ApplicationColors.black4240,
                          inactiveColor: ApplicationColors.whiteColor,
                          value: activeGroups,
                          onToggle: (val) {
                            setState(() {
                              activeGroups = val;
                              updateGroups(data);
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
                      onTap: (){
                        Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EditGroupScreen(
                                          groupName: data["groupName"],
                                          status: data["status"],
                                          id:data["id"],
                                          contactNumber:data["contactNumber"],
                                          address: data["address"],
                                      )
                              ));

                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/Edit_icon.png',  color:ApplicationColors.redColor67 ,
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
                      onTap: (){
                        deleteGroup(id);
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/delete_icon.png',  color:ApplicationColors.redColor67 ,
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


  @override
  Widget build(BuildContext context) {
   var height = MediaQuery.of(context).size.height;
   var width = MediaQuery.of(context).size.width;

   getGroupListProvider = Provider.of<GetGroupListProvider>(context, listen: true);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: ApplicationColors.whiteColorF9
            /*color: ApplicationColors.whiteColorF9*/
          ),
        ),
        getGroupListProvider.isGroupDetailLoading
            ?
        Helper.dialogCall.showLoader()
            :
        getGroupListProvider.getGroupDetailList.isEmpty
            ?
        Center(
          child: Text(
            "${getTranslated(context, "groups_not_available")}",
            textAlign: TextAlign.center,
            style: Textstyle1.text18.copyWith(
              fontSize: 18,
              color: ApplicationColors.redColor67,
            ),
          ),
        )
            :
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
              "${getTranslated(context, "groups")}",
              textAlign: TextAlign.start,
              style: Textstyle1.appbartextstyle1,
            ),
            actions: [
              //SizedBox(width: 40,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 9, vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                decoration: BoxDecoration(
                    color: ApplicationColors.redColor67,
                    borderRadius: BorderRadius.circular(100),
                ),

                child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>AddGroupsScreen()));

                    },
                    child: Icon(Icons.add)),
              ),
            ],
            backgroundColor: Colors.transparent, elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 19,left: 14,top: 15,bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: getGroupListProvider.getGroupDetailList.length,
                      shrinkWrap: true,
                      itemBuilder: (context,index) {
                        var groupDetailsList = getGroupListProvider.getGroupDetailList[index];
                        return Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            SizedBox(width: width*0.90,height: 112),
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.only(left: 35,right: 14),
                                height: 93,
                                width: width*0.88,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(child: Text(groupDetailsList.name,style: FontStyleUtilities.h18(fontColor: ApplicationColors.blackColor00),overflow: TextOverflow.visible,maxLines: 1,textAlign: TextAlign.start)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(child: Text( DateFormat("MMM dd,yyyy hh:mm aa").format(groupDetailsList.lastModified),style: FontStyleUtilities.h12(fontColor: ApplicationColors.black4240),overflow: TextOverflow.ellipsis,maxLines: 1,textAlign: TextAlign.start)),
                                        InkWell(
                                          onTap: (){
                                            var data = {
                                              "groupName": groupDetailsList.name,
                                              "status": groupDetailsList.status,
                                              "id":groupDetailsList.id,
                                              "contactNumber":groupDetailsList.contactNo,
                                              "address": groupDetailsList.address,
                                            };
                                            setState(() {
                                              activeGroups = groupDetailsList.status;
                                            });
                                            showDialogBox(data,groupDetailsList.id);
                                            print(data);
                                            },
                                          child: Icon(
                                            Icons.more_vert,
                                            color: ApplicationColors.redColor67,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Flexible(
                                        child: Text(
                                            "${groupDetailsList.vehicles.length} ${getTranslated(context, "vehicles")}",
                                            style: FontStyleUtilities.h12(
                                                fontColor: ApplicationColors.black4240
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textAlign: TextAlign.start
                                        )
                                    ),
                                    // Text('Odo: 707.5 Km(s)',style: FontStyleUtilities.h12(fontColor: ApplicationColors.whiteColor),overflow: TextOverflow.ellipsis,maxLines: 1,textAlign: TextAlign.start),

                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: ApplicationColors.whiteColor,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow:  [
                                    BoxShadow(
                                      color: ApplicationColors.textfieldBorderColor,
                                      offset: Offset(
                                        0,
                                        0,
                                      ),
                                      blurRadius: 10.0,
                                      spreadRadius: -4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 38,
                              left: 0,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                height: 35,
                                width: 35,
                                child: Image.asset("assets/images/groups_ic.png"),
                                decoration: BoxDecoration(
                                  color: ApplicationColors.redColor67,
                                  borderRadius: BorderRadius.circular(32),
                                ),

                              ),
                            ),
                          ],
                        );
                      }
                  ),

                ],
              ),
            ),
          ),

        ),


      ],
    );
  }

}
