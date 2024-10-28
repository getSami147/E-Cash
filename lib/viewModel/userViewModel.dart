

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:muzahir_fyp/view/auth%20screens/login_screen.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/dashboard.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:provider/provider.dart';

class UserViewModel with ChangeNotifier {
   UserViewModel() {
    _init();
  }

  Future _init() async {
    await getCurrentLocation();
    await getUserTokens();
  }
  //Current coordinates//..........................................
  LocationData? currentLocation;

  // Get User Token...........................................................>>>
  String? userId;
  bool isGoogleSignup=false;
 var isVerified =false;


   getUserTokens() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getString("uid");
    isGoogleSignup = sp.getBool("isgoogle")??false;
    isVerified = sp.getBool("isVerified")?? false;
    notifyListeners();
  }
  
   isCheckLogin(context) async {
    var p=Provider.of<UserViewModel>(context,listen: false);
    final SharedPreferences sp = await SharedPreferences.getInstance();
    userId = sp.getString("uid");
    isVerified = sp.getBool("isVerified")?? false;
    if (kDebugMode) {
      print("userId: $userId");
      print("isVerified: ${p.isVerified}");
    }
    userId == null ||userId!.isEmpty||isVerified!=true
        ? const LoginScreen().launch(context)
        : const Dashboard().launch(context);
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then((location) {
      currentLocation = location;
      notifyListeners();
    });
  }


// Location getLocationAndShowDialog
   Future<void> getLocationAndShowDialog(context) async {
    Position position = await Geolocator.getCurrentPosition(
      // desiredAccuracy: LocationAccuracy.high,
    );
    notifyListeners();
  }
// Location premission
  Future getCurrentLocationPermission() async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      return Future.error("Location Service are disable");
    } else {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        notifyListeners();
        if (permission == LocationPermission.denied) {
          if (kDebugMode) {
            print("Location Permission is Denied");
          }
          return Future.error("Location Permission is Denied");
        }
      }
    }
  } 
}
