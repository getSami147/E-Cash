import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muzahir_fyp/utils/colors.dart';
import 'package:muzahir_fyp/utils/widget.dart';
import 'package:muzahir_fyp/view/auth%20screens/login_screen.dart';
import 'package:muzahir_fyp/viewModel/authViewModel.dart';
import 'package:muzahir_fyp/viewModel/userViewModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';



class VerifySignUp extends StatefulWidget {
  const VerifySignUp({
    Key? key,
  }) : super(key: key);
  @override
  State<VerifySignUp> createState() => _VerifySignUpState();
}

class _VerifySignUpState extends State<VerifySignUp> {
  final OTPController = TextEditingController();

  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
   var provider= Provider.of<UserViewModel>(context, listen: false);
   provider.isVerified =
        FirebaseAuth.instance.currentUser!.emailVerified;
    print(isEmailVerified);

    super.initState();

    if (!provider.isVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    Provider.of<UserViewModel>(context, listen: false).isVerified =
        FirebaseAuth.instance.currentUser!.emailVerified;
    setState(() {});
    if (Provider.of<UserViewModel>(context, listen: false).isVerified.toString().toBool()) {
      timer?.cancel();
    }
  } //////////////////////////

  Future sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<UserViewModel>(context, listen: false).isVerified == true
        ? const LoginScreen()
        : Scaffold(
            backgroundColor: whiteColor,
            appBar: AppBar(
                backgroundColor: primaryColor,
                title: const Text("Email Verification",
                    style: TextStyle(
                      color: Colors.white,
                    ))),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text("Email Verification ",
                        fontSize: 18.0, fontWeight: FontWeight.w500)
                    .paddingTop(20),
                text(
                    "We Sent a Verification link to Your email address Please check your email to verify your account ",
                    maxLine: 5,
                    fontSize: 14.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      sendVerificationEmail();
                    },
                    child: text("Resend Verification",
                            textColor: primaryColor,
                            maxLine: 5,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0)
                        .paddingTop(24),
                  ),
                ),
                elevatedButton(
                  context,
                  width: double.infinity,
                  child: text("GO to Login ", textColor: whiteColor),
                  onPress: () {
                    const LoginScreen().launch(context);
                  },
                ).paddingTop(10),
              ],
            ).paddingSymmetric(horizontal: 16),
          );
    //   },
    // );
  }
}