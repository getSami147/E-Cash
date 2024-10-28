
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:location/location.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/utils/colors.dart';
import 'package:muzahir_fyp/utils/widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'helper_details.dart';


class Cash_to_E_Money extends StatefulWidget {
  bool isAppbar =true;
  Cash_to_E_Money({required this.isAppbar,super.key});

  @override
  _Cash_to_E_MoneyState createState() => _Cash_to_E_MoneyState();
}

class _Cash_to_E_MoneyState extends State<Cash_to_E_Money> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GeoFlutterFire _geo = GeoFlutterFire();
  Location _location = Location();
  bool _isLoading = true;
  List<Map<String, dynamic>> _posts = [];
  String _error = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();
        if (!_serviceEnabled) {
          setState(() {
            _isLoading = false;
            _error = 'Location services are disabled.';
          });
          return;
        }
      }

      _permissionGranted = await _location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await _location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          setState(() {
            _isLoading = false;
            _error = 'Location permission denied.';
          });
          return;
        }
      }

      _locationData = await _location.getLocation();
      _queryPosts(_locationData.latitude!, _locationData.longitude!);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error getting location: $e';
      });
    }
  }

  void _queryPosts(double lat, double lng) {
    GeoFirePoint center = _geo.point(latitude: lat, longitude: lng);
    var collectionReference = _firestore.collection('posts');

    double radius = 1.0; // Radius in kilometers
    String field = 'position'; // The field in the Firestore document containing geospatial data

    Stream<List<DocumentSnapshot>> stream = _geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: field);

    stream.listen((List<DocumentSnapshot> documentList) async {
      List<Map<String, dynamic>> postsWithUserDetails = [];

      for (var document in documentList) {
        var postData = document.data() as Map<String, dynamic>;

        if (postData['paymentType'] == "Cash to E-Money") {
          var userId = postData['userId'];
        
          // Fetch user details
          var userDoc = await _firestore.collection('users').doc(userId).get();
          var userData = userDoc.data();

          if (userData != null) {
            postsWithUserDetails.add({
              'post': postData,
              'user': userData,
            });
          }
        }
      }

      setState(() {
        _posts = postsWithUserDetails;
        _isLoading = false;
        if (_posts.isEmpty) {
          _error = 'No nearby posts found.';
        }
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
        _error = 'Error querying posts: $error';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:widget.isAppbar? AppBar(
        title: text('Cash to E-Money'),
      ):null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : _posts.isEmpty
                  ? const Center(child: Text('No nearby posts found.'))
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _posts.length,
                            padding: const EdgeInsets.only(bottom: size10),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var postData = _posts[index]['post'];
                              var userData = _posts[index]['user'];
                              return InkWell(
                                onTap: () {
                                  HelperDetails(
                                    userDetails: userData,
                                    postDetails: postData,
                                  ).launch(context);
                                },
                                child: requestCash(
                                  title: 'Name: ${userData['username']}',
                                  desc: '${postData['description']}',
                                  type: 'Payment Source: ${postData['paymentSource']}',
                                  amount: 'Amount: ${postData['amount']}',
                                ).paddingBottom(size15),
                              );
                            },
                          ),
                        )
                      ],
                    ).paddingAll(size20),
    );
  }
}

class requestCash extends StatelessWidget {
  var title, desc, amount, type;
  bool isUpdate;
  Color? color;
  VoidCallback? updateOnTap;
  VoidCallback? deletOnTap;

  requestCash({
    this.isUpdate=false,
    this.title,
    this.desc,
    this.amount,
    this.type,
    this.color,
    this.deletOnTap,
    this.updateOnTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor),
        color: primaryColor.withOpacity(.3),
        borderRadius: BorderRadius.circular(size12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text(title, fontWeight: FontWeight.bold, fontSize: size16)
              .paddingBottom(size5),
          text(desc,
                  fontWeight: FontWeight.w400,
                  textColor: gray,
                  maxLine: 4,
                  fontSize: size14)
              .paddingBottom(size10),
          text(type.toString(), fontSize: size14)
              .paddingBottom(size5),
          text(amount.toString(), fontWeight: FontWeight.w500, fontSize: size14)
              .paddingBottom(size20),
       isUpdate==true? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap:deletOnTap,
                child: Container(
                  height: size50,
                  width: MediaQuery.sizeOf(context).width * .33,
                  decoration: BoxDecoration(
                      border: Border.all(color: primaryColor, width: 2.0),
                      borderRadius: BorderRadius.circular(size12),
                      color: redColor),
                  child: Center(
                      child: text("Delete",
                          fontWeight: FontWeight.w500,
                          textColor: white,
                          fontSize: size15)),
                ),
              ),
              const SizedBox(
                width: size20,
              ),
              GestureDetector(
                onTap:updateOnTap,
                child: Container(
                  height: size50,
                  width: MediaQuery.sizeOf(context).width * .33,
                  decoration: BoxDecoration(
                      border: Border.all(color: primaryColor, width: 2.0),
                      borderRadius: BorderRadius.circular(size12),
                      color: white),
                  child: Center(
                      child: text("Update",
                          fontWeight: FontWeight.w500,
                          textColor: primaryColor,
                          fontSize: size15)),
                ),
              ),
            ],
          )
       :   Container(
            height: size50,
            decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 2.0),
                borderRadius: BorderRadius.circular(size12),
                color: white),
            child: Center(
                child: text("View More",
                    fontWeight: FontWeight.w500,
                    textColor: primaryColor,
                    fontSize: size15)),
          )
        ],
      ).paddingAll(size12),
    );
  }
}
