import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/components/textfield.dart';
import 'package:muzahir_fyp/utils/colors.dart';
import 'package:muzahir_fyp/utils/widget.dart';
import 'package:muzahir_fyp/viewModel/userViewModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class UpdatePostScreen extends StatefulWidget {
  var postdata;
   UpdatePostScreen({required this.postdata, super.key});

  @override
  State<UpdatePostScreen> createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {

  var lat, lng;
  var paymentType;
  var paymentSource;
  var isLoading = false;
  var descriptionController = TextEditingController();
  var whatsappNoController= TextEditingController();
  var amountController = TextEditingController();

  final firestore = FirebaseFirestore.instance.collection('posts');
  final geo = GeoFlutterFire();

  void createPost(double lat, double lng, String paymentType, String paymentSource, String amount,String description, int whatsAppNo,
      String userId) async {
    GeoFirePoint myLocation = geo.point(latitude: lat, longitude: lng);

    await firestore.doc(widget.postdata["_id"]).update({
      'paymentType': paymentType,
      "paymentSource":paymentSource,
      'latitude': lat,
      'longitude': lng,
      'amount': amount,
      'description': description,
      'userId': userId,
      'whatsAppNo': whatsAppNo,
      'timestamp': FieldValue.serverTimestamp(),
      'position': myLocation.data,
    }).then((value) {
    utils().toastMethod("Your post has been succussfuly Updated.");

    finish(context);
      setState(() {
        isLoading = false;
      });
    }).onError((error, stackTrace) {
      utils().toastMethod(error.toString(), backgroundColor: redColor);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    paymentType=widget.postdata["paymentType"].toString();
    paymentSource=widget.postdata["paymentSource"].toString();
    descriptionController.text=widget.postdata["description"].toString();
    whatsappNoController.text=widget.postdata["whatsAppNo"].toString();
    descriptionController.text=widget.postdata["description"];
    amountController.text=widget.postdata["amount"].toString();
    

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body:SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: text("Post Your Order",
                      fontSize: size18, fontWeight: FontWeight.w600)
                  .paddingBottom(size10),
            ),
            text("Payment type", fontSize: 14.0),
            Container(
              height: size55,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: gray),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Center(
                child: DropdownButtonFormField<String>(
                  hint: text(paymentType??"Payment Type",
                      textColor: black, fontWeight: FontWeight.w400),
                  decoration: const InputDecoration.collapsed(hintText: ''),
                  items: ['Cash to E-Money', 'E-Money to Cash']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: text(value,
                          textColor: black, fontWeight: FontWeight.w400),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (kDebugMode) {
                      print('Selected: $value');
                    }
                    paymentType = value;
                  },
                ),
              ),
            ).paddingOnly(top: size10, bottom: size20),

            text("Payment Source", fontSize: 14.0),
            Container(
              height: size55,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: gray),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Center(
                child: DropdownButtonFormField<String>(
                  hint: text(paymentSource??"Choose payment Source",
                      textColor: black, fontWeight: FontWeight.w400),
                  decoration: const InputDecoration.collapsed(hintText: ''),
                  items: ['Jazz Cash', 'Easypaisa', "Upaisa", "Sada Pay"]
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: text(value,
                          textColor: black, fontWeight: FontWeight.w400),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (kDebugMode) {
                      print('Selected: $value');
                    }
                    paymentSource = value;
                  },
                ),
              ),
            ).paddingOnly(top: size10, bottom: size20),
          
            text("Amount", fontSize: 14.0),
            textField(
              hint: "Enter your Amount",
              maxline: 1,
              controller: amountController,
              keyboardtype: TextInputType.number,
            ),
             text("whatsapp No", fontSize: 14.0),
             CustomTextFormField(
                      context,hintText: "3303333333",
                      controller: whatsappNoController,
                      filledColor: filledColor,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                    ).paddingTop(5),
            text("Description", fontSize: 14.0),
             CustomTextFormField(
                      context,hintText: "Description",
                      controller: descriptionController,
                      filledColor: filledColor,
                      maxLines: 5,maxLength: 120,
                    
                    ).paddingTop(5),
          

                    
            elevatedButton(context, loading: isLoading, onPress: () async {
              if (paymentType == null) {
                utils().toastMethod("Please select the payment type",
                    backgroundColor: dissmisable_RedColor);
              } else if (paymentSource == null) {
                utils().toastMethod("Please select the payment Source",
                    backgroundColor: dissmisable_RedColor);
              }else if (amountController.text.isEmpty) {
                utils().toastMethod("Please enter amount",
                    backgroundColor: dissmisable_RedColor);
              }  else if (whatsappNoController.text.isEmpty) {
                utils().toastMethod("Please Enter 10 digits number without 0 ",
                    backgroundColor: dissmisable_RedColor);
              } else if (descriptionController.text.isEmpty) {
                utils().toastMethod("Please Write Somthing About your Payments",
                    backgroundColor: dissmisable_RedColor);
              } else {
                setState(() {
                  isLoading = true;
                });
                createPost(
                    userViewModel.currentLocation!.latitude??0.0,
                    userViewModel.currentLocation!.longitude??0.0,
                    paymentType,
                    paymentSource,
                    amountController.text.toString().trim(),
                    descriptionController.text.toString().trim(),
                    whatsappNoController.text.trim().toInt(),
                    userViewModel.userId.toString());
              }
            }, child: text("Submit", textColor: white)).paddingTop(size30)
          ],
        ).paddingAll(size20),
      ),
    );
  }
}
