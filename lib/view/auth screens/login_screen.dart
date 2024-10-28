import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/components/build_button.dart';
import 'package:muzahir_fyp/components/textfield.dart';
import 'package:muzahir_fyp/utils/Images.dart';
import 'package:muzahir_fyp/utils/constant.dart';
import 'package:muzahir_fyp/utils/widget.dart';
import 'package:muzahir_fyp/view/auth%20screens/forgotPassword.dart';
import 'package:muzahir_fyp/view/auth%20screens/sign_up_screen.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/dashboard.dart';
import 'package:muzahir_fyp/viewModel/authViewModel.dart';
import 'package:muzahir_fyp/viewModel/userViewModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _value;
  var isLoading = false;
  //var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // New changes
  var active1 = true;
  Timer? timer;

  sendEmailVerification(currentUser) async {
   var provider= Provider.of<UserViewModel>(context, listen: false);
    Provider.of<UserViewModel>(context, listen: false).isVerified = currentUser;
    if (provider.isVerified==false) {
      sendVerificationEmail();
      timer = Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  Future checkEmailVerified() async {
   var provider= Provider.of<UserViewModel>(context, listen: false);
      final SharedPreferences prefs =await SharedPreferences.getInstance();
    await FirebaseAuth.instance.currentUser!.reload();
   var isVerified=FirebaseAuth.instance.currentUser!.emailVerified;
    prefs.setBool("isVerified", isVerified);
    setState(() {});
    if (provider.isVerified) {
      timer?.cancel();
      Fluttertoast.showToast(msg: "email verified succefssfully login again");
    }
  } //////////////////////////

  Future sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
   var userViewModel= Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                              onPressed: () {
                                finish(context);
                              },
                              icon: const Icon(Icons.arrow_back))
                          .paddingBottom(size20),
                    ),
                    const Spacer(),
                    text("Login into your account",
                            fontWeight: FontWeight.w500, fontSize: size18)
                        .paddingBottom(size30),
                    textField(
                      hint: "Email",
                      maxline: 1,
                      labell: text("Email"),
                      controller: emailController,
                    ),
                    textField(
                      hint: "Password",
                      controller: passwordController,
                      maxline: 1,
                      labell: text("Password"),
                      obscures: active1,
                      suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              active1 == true
                                  ? active1 = false
                                  : active1 = true;
                            });
                          },
                          icon: active1 == true
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)),
                    ),
                   InkWell(
                    onTap: () {
                      ForgotPassword().launch(context);
                    },
                     child: Align(alignment: Alignment.centerRight,
                      child: text("ForgotPassword")),
                   ),
                    const Spacer(),
                    Consumer<UserViewModel>(
                      builder: (context, authview, child) {
                        return BuildButton(
                                loading: isLoading,
                                onPressed: () async {
                                  if (emailController.text.isEmpty) {
                                    utils().toastMethod("Please enter the email",backgroundColor: redColor);
                                  } else if (!emailController.text
                                          .contains("@") ||
                                      !emailController.text.contains(".")) {
                                    utils().toastMethod("Invalid Email",backgroundColor: redColor);
                                  } else if (passwordController.text.isEmpty) {
                                    utils().toastMethod("Password is not to be is empty",backgroundColor: redColor);
                                  } else {
                                    try {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                              email: emailController.text
                                                  .toString()
                                                  .trim(),
                                              password: passwordController.text
                                                  .toString()
                                                  .trim())
                                          .then((documentSnapshot) async {
                                        if (kDebugMode) {
                                          debugPrint(
                                              "login documentSnapshot: ${documentSnapshot}");
                                        }

                                        final SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        var isVerified = documentSnapshot.user!.emailVerified;
                                        prefs.setString("uid", documentSnapshot.user!.uid);
                                        prefs.setBool("isVerified", isVerified);
                                        prefs.setBool("isgoogle", false);   
                                        if (isVerified == false) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          debugPrint("checkEmail false");
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please verify your email go to Your Gmail");
                                          sendEmailVerification(documentSnapshot
                                              .user!.emailVerified);
                                        } else {
                                          User? currenuser = await FirebaseAuth
                                              .instance.currentUser;
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(currenuser!.uid)
                                              .get()
                                              .then((DocumentSnapshot
                                                  documentSnapshot) async {
                                            debugPrint(
                                                "documentSnapshot id: ${documentSnapshot.id}");

                                            if (documentSnapshot.exists) {
                                               utils().toastMethod(
                                                    'Congratulations! You have successfully logined.');
                                              setState(() {
                                                isLoading = false;
                                              });
                                              const Dashboard()
                                                  .launch(context);
                                                  setState(() {
                                                    
                                                  });
                                                  
                                            } else {
                                              utils().toastMethod(
                                                  "no exit ${!documentSnapshot.exists}");
                                            }
                                          });
                                        }
                                      });
                                    } on FirebaseAuthException catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                                if (e.code == 'user-not-found') {
                                  utils().toastMethod("No user found with that email address.", backgroundColor: redColor);
                                }else if (e.code.contains("no user record")) {
                                  utils().toastMethod("No user found with that email address.", backgroundColor: redColor);
                                } else if (e.code == 'wrong-password') {
                                  utils().toastMethod("Wrong password provided.", backgroundColor: redColor);
                                } else {
                                  utils().toastMethod(e.message.toString(), backgroundColor: redColor);
                                }
                              }
                                  }
                                },
                                text: "Login")
                            .paddingBottom(size20);
                      },
                    ),
                         SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: OutlinedButton(onPressed: ()async {
                  await AuthViewModel().signInWithGoogle().then((value)async{
                    await Dashboard().launch(context,isNewTask: true);

                   }).onError((error, stackTrace) {
                     utils().toastMethod(error.toString());
                   },);

                  }, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                      svg_GoogleLogo,
                      height: 30,
                      width: 30,
                      fit: BoxFit.cover,
                    ),
                      text("Continue With Google",
                          fontWeight:  FontWeight.w600,textColor: Colors.black,fontSize: textSizeLargeMedium,).paddingLeft(10),
                    ],
                  )),
                ).paddingTop(spacing_twinty),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(
                          "Didn't have an account?",
                          textColor: grey,
                          fontSize: size13,
                        ),
                        textButton(
                          text: "Sign Up",
                          ontap: () {
                            const SignUpScreen().launch(context);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
