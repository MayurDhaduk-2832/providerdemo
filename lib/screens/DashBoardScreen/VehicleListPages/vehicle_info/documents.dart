import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oneqlik/Helper/helper.dart';
import 'package:oneqlik/Model/vehicle_list_model.dart';
import 'package:oneqlik/Provider/vehicle_list_provider.dart';
import 'package:oneqlik/components/styleandborder.dart';
import 'package:oneqlik/local/localization/language_constants.dart';
import 'package:oneqlik/screens/DashBoardScreen/VehicleListPages/vehicle_info/update_document.dart';
import 'package:oneqlik/screens/DashBoardScreen/VehicleListPages/vehicle_info/upload_document.dart';
import 'package:oneqlik/utils/colors.dart';
import 'package:oneqlik/utils/font_utils.dart';
import 'package:oneqlik/utils/utils.dart';
import 'package:oneqlik/widgets/simple_elevated_button.dart';
import 'package:provider/provider.dart';

class DocumetsPage extends StatefulWidget {
  VehicleLisDevice vehicleLisDevice;

   DocumetsPage({Key key,this.vehicleLisDevice}) : super(key: key);

  @override
  _DocumetsPageState createState() => _DocumetsPageState();
}

class _DocumetsPageState extends State<DocumetsPage> {

  VehicleListProvider vehicleListProvider;

  getAllDocument()async{

    var data ={
       "device":"${widget.vehicleLisDevice.id}",
    };

    print("getDocument-->$data");
    await vehicleListProvider.getAllDocument(data, "document/get");

  }

  deleteDialog(id){
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            backgroundColor: ApplicationColors.blackColor2E,
            title: Text(
              "${getTranslated(context, "Are_you_sure_you_want_to_delete_this_document")}",
              textAlign: TextAlign.center,
              style: Textstyle1.appbartextstyle1.copyWith(
                  fontSize: 14
              ),
            ),

            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SimpleElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      buttonName: "${getTranslated(context, "cancel")}",
                      style: FontStyleUtilities.s18(fontColor: ApplicationColors.whiteColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: ApplicationColors.redColor67,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SimpleElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        deleteDocuemt(id);
                      },
                      buttonName: "${getTranslated(context, "ok")}",
                      style: FontStyleUtilities.s18(fontColor: ApplicationColors.whiteColor),
                      fixedSize: Size(118, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: ApplicationColors.redColor67,
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  deleteDocuemt(id) async {
    var data = {
      "id":"$id"
    };
    print('Delete Document -> $data');

    await vehicleListProvider.deleteDocument(data, "document/delete",context,"${widget.vehicleLisDevice.id}");
  }

  var userImage = "";

  showDialogBox(int index,id){
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
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

                  SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    UpdateDocumentPage(
                                        data:index,
                                    )
                            ));
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/Edit_icon.png',
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
                        // deleteDocument(id);
                        deleteDialog(id);
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/delete_icon.png',
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

  showImageDialog(list){
    showDialog(
        context: context,
        builder: (context) {
          var width = MediaQuery.of(context).size.width;
          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            backgroundColor: Colors.transparent,
            title: Container(
              width: width,
              decoration: BoxDecoration(
                  color: ApplicationColors.blackColor2E,
                  borderRadius:
                  BorderRadius.circular(13)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    Row(
                      children: [
                        Expanded(
                            child: Text(
                             /* "${list.imageDoc[0].name}",*/
                              '${list.imageDoc[0].type}',
                              style: Textstyle1.text18,
                            )),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              child: Image.asset(
                                "assets/images/close_icon.png",
                                width: 15,
                              ),
                            ))
                      ],
                    ),
                    SizedBox(height: 10),


                    Container(
                      decoration: Boxdec.conrad6colorgrey.copyWith(
                          borderRadius: BorderRadius.circular(0)
                      ),
                      child: CachedNetworkImage(
                        imageUrl: "${Utils.http}""${Utils.baseUrl}""${userImage}",
                        placeholder: (context, url) => Helper.dialogCall.showLoader(),
                        width: width,
                        height: 180,
                        fit: BoxFit.fill,
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      children: [
                        Text(
                          '${getTranslated(context, "expire_on")}',
                          style: Textstyle1.text11,
                        ),
                        Text(
                          list.imageDoc[0].expDate == null
                              ?
                          " N/A"
                              :
                          ' ${DateFormat("dd MMM yyyy").format(list.imageDoc[0].expDate)}',
                          style: Textstyle1.text11,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          );
        });
  }

  getType()async{
    var data ={
      "type":"vehicle_document"
    };

    await vehicleListProvider.getDocType(data, "typeMaster/get");
  }
  @override
  void initState() {
    super.initState();
    vehicleListProvider = Provider.of<VehicleListProvider>(context, listen: false);
    getType();
    getAllDocument();
  }

  @override
  Widget build(BuildContext context) {

    vehicleListProvider = Provider.of<VehicleListProvider>(context, listen: true);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: ApplicationColors.whiteColorF9
           /* color: ApplicationColors.whiteColorF9*/
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
                  Navigator.pop(context);
                },
                icon: Image.asset("assets/images/vector_icon.png",color: ApplicationColors.redColor67),
              ),
            ),
            title: Text(
              "${getTranslated(context, "documents")}",
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
                    borderRadius: BorderRadius.circular(100)),
                child: InkWell(
                  onTap: () async {
                    print(widget.vehicleLisDevice.id);
                    final value = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UploadDocumentPage(vehicleLisDevice: widget.vehicleLisDevice,))
                    );
                    if(value!=null){
                      getAllDocument();
                    }
                  },
                  child: Center(
                    child: Icon(Icons.add),
                  ),
                ),
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),

          backgroundColor: Colors.transparent,

          body: vehicleListProvider.isDocLoading
              ?
          Helper.dialogCall.showLoader()
              :
          vehicleListProvider.getAllDocumentModel.documents.isEmpty
              ?
          Center(
            child: Text(
              "${getTranslated(context, "documents_not_available")}",
              textAlign: TextAlign.center,
              style: Textstyle1.text18.copyWith(
                fontSize: 18,
                color: ApplicationColors.redColor67,
              ),
            ),
          )
              :
          Padding(
            padding: const EdgeInsets.only(right: 19, left: 14, top: 20),
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: vehicleListProvider.getAllDocumentModel.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var list = vehicleListProvider.getAllDocumentModel.documents[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        userImage = "";
                        if(list.imageDoc[0].image != null){
                          var data1 = list.imageDoc[0].image.split("/");

                          for(int i = 1; i<data1.length; i++){
                            userImage = "$userImage" + "/" + data1[i];
                          }
                        }
                      });

                      showImageDialog(list);
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [

                        SizedBox(width: width * 0.90, height: 112),

                        Positioned(
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.only(left: 35, right: 14),
                            height: 93,
                            width: width * 0.88,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                    child: Text(
                                      '${list.imageDoc[0].type}',

                                      style: FontStyleUtilities.h18(
                                        fontColor: ApplicationColors.whiteColor,
                                      ),
                                      overflow: TextOverflow.visible,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                    ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        child: Text(
                                          "${list.imageDoc[0].number}",
                                           /* list.imageDoc[0].expDate == null
                                                ?
                                            "N/A"
                                                :
                                            '${DateFormat("dd MMM yyyy hh:mm aa").format(list.imageDoc[0].date)} ',*/

                                            style: FontStyleUtilities.h12(
                                                fontColor: ApplicationColors.whiteColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                        ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        showDialogBox(index,list.id);
                                      },
                                      child: Icon(
                                        Icons.more_vert,
                                        color: ApplicationColors.redColor67,
                                      ),
                                    )
                                  ],
                                ),

                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Flexible(
                                        child: Text(
                                            '${getTranslated(context, "expire_on")}',
                                            style: FontStyleUtilities.h12(
                                                fontColor: ApplicationColors.whiteColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                        ),
                                    ),

                                    Flexible(
                                        child: Text(
                                            list.imageDoc[0].expDate == null
                                                ?
                                            " N/A"
                                                :
                                            ' ${DateFormat("dd MMM yyyy").format(list.imageDoc[0].expDate)}',
                                            style: FontStyleUtilities.h12(
                                                fontColor: ApplicationColors.whiteColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                        ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: ApplicationColors.blackColor2E,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 02,),
                                  blurRadius: 6.0,
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
                            padding: EdgeInsets.all(7),
                            height: 35,
                            width: 35,
                            child: Image.asset(
                              "assets/images/document_image_icon.png",
                            ),
                            decoration: BoxDecoration(
                              color: ApplicationColors.redColor67,
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                        ),

                      ],
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}

