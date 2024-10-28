import 'package:flutter/material.dart';
import 'package:muzahir_fyp/utils/images.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/components/build_button.dart';
import 'package:muzahir_fyp/utils/colors.dart';
import 'package:muzahir_fyp/view/auth%20screens/login_screen.dart';
import 'package:muzahir_fyp/view/auth%20screens/sign_up_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:muzahir_fyp/utils/widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  image_welcome,
                  height: orientation == Orientation.portrait
                      ? MediaQuery.sizeOf(context).height * .3
                      : MediaQuery.sizeOf(context).height * .4,
                  width: orientation == Orientation.portrait
                      ? MediaQuery.sizeOf(context).width * 1
                      : MediaQuery.sizeOf(context).width * .8,
                ).paddingSymmetric(vertical: size40),
                text("Welcome", fontWeight: FontWeight.w500, fontSize: size18)
                    .paddingBottom(size15),
                text("Have a better sharing experience",
                        fontWeight: FontWeight.w400,
                        textColor: grey,
                        fontSize: size16)
                    .paddingBottom(size20),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  BuildButton(
                          onPressed: () {
                            const SignUpScreen().launch(context);
                          },
                          text: "Create an Account")
                      .paddingBottom(size20),
                  GestureDetector(
                    onTap: () {
                      const LoginScreen().launch(context);
                    },
                    child: Container(
                      height: size50,
                      decoration: BoxDecoration(
                          border: Border.all(color: primaryColor, width: 2.0),
                          borderRadius: BorderRadius.circular(size12),
                          color: white),
                      child: Center(
                          child: text("Log In",
                              fontWeight: FontWeight.w500,
                              textColor: primaryColor,
                              fontSize: size15)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ).paddingAll(size20),
      ),
    );
  }
}
