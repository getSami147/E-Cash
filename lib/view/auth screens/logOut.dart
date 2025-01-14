import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muzahir_fyp/utils/images.dart';
import 'package:muzahir_fyp/utils/colors.dart';
import 'package:muzahir_fyp/utils/widget.dart';
import 'package:muzahir_fyp/view/auth%20screens/welcome_screen.dart';
import 'package:muzahir_fyp/viewModel/authViewModel.dart';
import 'package:muzahir_fyp/viewModel/userViewModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class LogoutAccount extends StatefulWidget {
  const LogoutAccount({super.key});

  @override
  State<LogoutAccount> createState() => _LogoutAccountState();
}

class _LogoutAccountState extends State<LogoutAccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Sign out
  Future<void> signOut() async {
    var userViewModel=Provider.of<UserViewModel>(context,listen: false);
      showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const CircularProgressIndicator(),
    );
    try {
      await _auth.signOut().then((value) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
          userViewModel.isVerified=false;
        prefs.remove("uid").then((value) {
          const WelcomeScreen().launch(context, isNewTask: true);
        });
      });
    } catch (e) {
      finish(context);
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    svgLogout,
                    color: primaryColor,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  text("Logout Account",
                      fontSize: 20.0, fontWeight: FontWeight.w500),
                  const SizedBox(
                    height: 4,
                  ),
                  text(
                    "Do you want to logout the App?",
                    textColor: Colors.grey,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: elevatedButton(
                      context,
                      onPress: () {
                        Navigator.pop(context);
                      },
                      height: 45.0,
                      borderRadius: 25.0,
                      backgroundColor: Colors.white,
                      bodersideColor: blackColor,
                      child: text("Cancel", fontSize: 14.0),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: elevatedButton(
                      context,
                      onPress: () async {
                        var userViewModel=Provider.of<UserViewModel>(context,listen: false);
                        userViewModel.isGoogleSignup==true?AuthViewModel().signOutGoogle().then((value) {
                          signOut();
                        })
                         : signOut().then((value) {
                          
                        });
                      },
                      height: 45.0,
                      borderRadius: 25.0,
                      backgroundColor: Colors.red,
                      bodersideColor: Colors.red,
                      child: text("LogOut",
                          textColor: Colors.white, fontSize: 14.0),
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 10),
            ),
          ],
        ),
      ),
    );
  }
}
