import 'package:flutter/material.dart';
import 'package:muzahir_fyp/GoogleMap/googleMapScreen.dart';
import 'package:muzahir_fyp/utils/images.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:muzahir_fyp/utils/widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HelperDetails extends StatefulWidget {
  var userDetails;
  var postDetails;
  HelperDetails({required this.userDetails,required this.postDetails, super.key});
// 
  @override
  State<HelperDetails> createState() => _HelperDetailsState();
}

class _HelperDetailsState extends State<HelperDetails> {
  @override
  Widget build(BuildContext context) {
    void openWhatsApp(phoneNumber) async {
      final Uri _url =
          Uri.parse('whatsapp://send?phone=$phoneNumber');
      if (!await launchUrl(_url)) throw 'Could not launch $_url';
    }

    void makePhoneCall(phoneNumber) async {
      final Uri phoneUrl = Uri.parse('tel:$phoneNumber');
      if (!await launchUrl(phoneUrl)) throw 'Could not launch $phoneUrl ';
    }
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body:Column(
        children: [
           Center(
                child: Column(
                  children: [
                    widget.userDetails['userImage'] == null ||
                            widget.userDetails['userImage']!.isEmpty
                        ? CircleAvatar(
                            radius: size.width * .14,
                            backgroundColor: primaryColor,
                            child: ClipOval(
                                child: Image.asset(
                              image_profile,
                              height: size.width * .24,
                              width: size.width * .24,
                              fit: BoxFit.cover,
                            )),
                          )
                        : CircleAvatar(
                            radius: size.width * .14,
                            backgroundColor: primaryColor,
                            child: ClipOval(
                                child: Image.network(
                              widget.userDetails['userImage'].toString(),
                              height: size.width * .24,
                              width: size.width * .24,
                              fit: BoxFit.cover,
                            )),
                          ),
                    text(widget.userDetails['username'].toString(),
                        fontWeight: FontWeight.bold, fontSize: size18),
                    text(widget.userDetails['email'].toString()),
                  ],
                ),
              ),
          Expanded(child: 
          GoogleMapScreen(coordinates: [widget.postDetails['latitude'],widget.postDetails['longitude']], isBottomNav: true, currentLocation: "Marchant Location").paddingTop(20)
          ),

          Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  elevatedButton(context,
                          width: MediaQuery.sizeOf(context).width * .4,
                          onPress: () {
                            makePhoneCall("+92${widget.postDetails['whatsAppNo']}");
                          },
                          child:text("Call",textColor: white))
                      .paddingRight(size10),
                      elevatedButton(context,
                          width: MediaQuery.sizeOf(context).width * .4,
                          onPress: () {
                           openWhatsApp("+92${widget.postDetails['whatsAppNo']}");
                          },
                          child:text("WhatsApp",textColor: white))
                      .paddingRight(size10),
                 
                ],
              ).paddingSymmetric(vertical: size20),
        ],
      ).paddingSymmetric(horizontal: 20)
    );
  }
}
