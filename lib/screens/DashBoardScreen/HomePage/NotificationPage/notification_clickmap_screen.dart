import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../components/styleandborder.dart';
import '../../../../local/localization/language_constants.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/font_utils.dart';

class NotificationDetailScreen extends StatefulWidget {
  var lat,long,title,subtitle,odo,date,time;
   NotificationDetailScreen({Key, key, this.lat,this.long,this.title,this.subtitle,this.odo,this.date,this.time}) : super(key: key);

  @override
  State<NotificationDetailScreen> createState() => _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  @override
  CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();
   LatLng latLng;
  void initState() {
    // TODO: implement initState
    print(widget.lat);
    print(widget.long);
    latLng = LatLng(widget.lat as double, widget.long as double);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "${getTranslated(context, "notification")}",
          textAlign: TextAlign.start,
          style: Textstyle1.appbartextstyle1,
        ),

        backgroundColor: Colors.transparent, elevation: 0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
                target: LatLng(widget.lat, widget.long),
                zoom: 13
            ),
          onMapCreated: (controller) {
            _customInfoWindowController.googleMapController=controller;
          },
            onTap: (argument) {
            _customInfoWindowController.hideInfoWindow();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove();
            },
            markers: {
              Marker(


                markerId: MarkerId('myMarker'),
                position: LatLng(widget.lat, widget.long),
                //infoWindow: InfoWindow(title: widget.title,snippet:widget.subtitle),
                onTap: () {
                  _customInfoWindowController.addInfoWindow(
                   Container(
                      height: 100,
                     width: 300,
                     decoration: BoxDecoration(
                       color: Colors.white,
                       border: Border.all(color: Colors.grey),
                       borderRadius: BorderRadius.circular(10),
                     ),
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                          Text(widget.title, style: FontStyleUtilities.h18(
                           fontColor:
                           ApplicationColors
                               .black4240),
                           overflow: TextOverflow
                               .visible,
                           maxLines: 1,
                           textAlign:
                           TextAlign.start),
                           Flexible(
                               child: Text(
                                   "${widget.subtitle}",
                                   style: FontStyleUtilities.h11(
                                       fontColor:
                                       ApplicationColors
                                           .black4240),
                                   overflow: TextOverflow
                                       .visible,
                                   maxLines: 1,
                                   textAlign:
                                   TextAlign.start)),
                           Flexible(
                             child: RichText(
                               maxLines: 1,
                               overflow:
                               TextOverflow.visible,
                               text: TextSpan(
                                 children: [
                                   TextSpan(
                                     text:
                                     '${getTranslated(context, "odo")} : ',
                                     style: FontStyleUtilities.h12(
                                         fontColor:
                                         ApplicationColors
                                             .black4240,
                                         fontFamily:
                                         'Poppins-Regular'),
                                   ),
                                   TextSpan(
                                     text:
                                     "${NumberFormat("##0.0#", "en_US").format(widget.odo)} ${getTranslated(context, "km_(s)")}",
                                     style: FontStyleUtilities.h12(
                                         fontColor:
                                         ApplicationColors
                                             .redColor67,
                                         fontFamily:
                                         'Poppins-Regular'),
                                   )
                                 ],
                               ),
                             ),
                           ),
                           Flexible(
                               child: Text(
                                   "Date: ${DateFormat("MMM dd, yyyy").format(
                                     DateTime.parse(widget.date.toString())
                                         .toLocal(),
                                   )}",
                                   style: FontStyleUtilities.h12(
                                       fontColor:
                                       ApplicationColors
                                           .black4240),
                                   overflow: TextOverflow
                                       .ellipsis,
                                   maxLines: 1,
                                   textAlign:
                                   TextAlign.start)),
                           Flexible(
                               child: Text(
                                   "Time: ${DateFormat("hh:mm aa").format(
                                     DateTime.parse(widget.date
                                         .toString())
                                         .toLocal(),
                                   )}",
                                   style: FontStyleUtilities.h12(
                                       fontColor:
                                       ApplicationColors
                                           .black4240),
                                   overflow: TextOverflow
                                       .ellipsis,
                                   maxLines: 1,
                                   textAlign:
                                   TextAlign.start)),

                         ],
                       ),
                     ),
                   ),
                    latLng
                  );
                },
              ),
            },
          ),
          CustomInfoWindow(controller: _customInfoWindowController,
          width: 300,
            height: 100,
            offset: 35,
          )
        ],

      ),
    );
  }

}
