import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muzahir_fyp/utils/images.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/components/textfield.dart';
import 'package:muzahir_fyp/utils/colors.dart';
import 'package:muzahir_fyp/utils/widget.dart';
import 'package:muzahir_fyp/view/auth%20screens/login_screen.dart';
import 'package:muzahir_fyp/view/auth%20screens/verifySignUp.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  var selectedGender;
  var active1 = true;

  String imageUrl = '';
  File? logoImage;
  XFile? imageFile;

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                      onPressed: () {
                        finish(context);
                      },
                      icon: const Icon(Icons.arrow_back))
                  .paddingBottom(size20),
              text("Create an account",
                      fontWeight: FontWeight.w500, fontSize: size18)
                  .paddingBottom(size30),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: size.width * .14,
                    backgroundColor: primaryColor,
                    child: logoImage == null
                        ? ClipOval(
                            child: Image.asset(
                            image_profile,
                            height: size.width * .23,
                            width: size.width * .23,
                            fit: BoxFit.cover,
                          ))
                        : ClipOval(
                            child: Image.file(
                              File(logoImage!.path).absolute,
                              height: size.width * .24,
                              width: size.width * .24,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                          color: primaryColor, shape: BoxShape.circle),
                      child: IconButton(
                        onPressed: () async {
                          ImagePicker picker = ImagePicker();
                          imageFile = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (imageFile != null) {
                            logoImage = File(imageFile!.path);
                            // debugPrint("image path: ${imageFile!.path}");
                            setState(() {});
                          }
                          if (imageFile == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("No File  selected")));
                          }
                        },
                        icon: const Icon(Icons.camera_alt),
                        color: whiteColor,
                        iconSize: 20,
                      ))
                ],
              ).center(),
              textField(
                hint: "Name",
                controller: nameController,
                labell: text("Name"),
                maxline: 1,
              ).paddingTop(20),
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
                    hint: text("Choose Gender",
                        textColor: black, fontWeight: FontWeight.w400),
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    items: ['Male', 'Female'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: text(value,
                            textColor: black, fontWeight: FontWeight.w400),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // if (kDebugMode) {
                        print('Selected: $value');
                      // }
                      selectedGender = value;
                    },
                  ),
                ),
              ).paddingOnly(top: size10, bottom: size20),
              textField(
                hint: "Email",
                controller: emailController,
                maxline: 1,
                labell: text("Email"),
              ),
              textField(
                controller: passwordController,
                hint: "Password",
                maxline: 1,
                labell: text("Password"),
                obscures: active1,
                suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        active1 == true ? active1 = false : active1 = true;
                      });
                    },
                    icon: active1 == true
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off)),
              ),
              Consumer(
                builder: (context, value, child) {
                  return elevatedButton(
                    loading: isLoading,
                    context,
                    width: double.infinity,
                    child: text("Sign Up", textColor: whiteColor),
                    onPress: () {
                      if (logoImage == null) {
                        utils().toastMethod("Please Select the Image",
                            backgroundColor: redColor);
                      } else if (nameController.text.isEmpty) {
                        toast("Please enter the name", bgColor: redColor);
                      } else if (selectedGender == null) {
                        toast("Please select the gender", bgColor: redColor);
                      } else if (emailController.text.isEmpty) {
                        toast("Please the email", bgColor: redColor);
                      } else if (!emailController.text.contains("@") ||
                          !emailController.text.contains(".")) {
                        toast("Invalid Email", bgColor: redColor);
                      } else if (passwordController.text.isEmpty) {
                        toast("Please enter the password", bgColor: redColor);
                      } else if (passwordController.text.length < 6) {
                        toast("Password must be greater than 6 digits",
                            bgColor: redColor);
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        auth
                            .createUserWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim())
                            .then((value) async {
                          String uniqueName =
                              DateTime.now().microsecondsSinceEpoch.toString();
                          Reference referenceRoot =
                              FirebaseStorage.instance.ref();
                          Reference referenceDirImage =
                              referenceRoot.child('images');
                          // create refrence to the image to be Store .........................
                          Reference referenceImageUpload =
                              referenceDirImage.child(uniqueName);
                          // debugPrint("referenceDirImage");
                          // debugPrint("imageFile ${imageFile!.path}");

                          // store the file
                          await referenceImageUpload
                              .putFile(File(imageFile!.path));
                          // debugPrint("imageFile!.path");

                          imageUrl =
                              await referenceImageUpload.getDownloadURL();
                          // debugPrint("imageUrl ${imageUrl}");

                          users.doc(auth.currentUser!.uid).set({
                            'username': nameController.text.toString().trim(),
                            'email': emailController.text.toString().trim(),
                            'gender': selectedGender,
                            'id': auth.currentUser!.uid,
                            "userImage": imageUrl,
                          }).then((value) {
                            setState(() {
                              isLoading = false;
                            });
                            const VerifySignUp().launch(context);

                            setState(() {
                              isLoading = false;
                            });
                            // debugPrint("Form Data Uploaded successfully");
                            Fluttertoast.showToast(
                                msg: "First Verify your account");
                          });
                        }).onError((error, stackTrace) {
                          // debugPrint(error.toString());
                          utils().toastMethod(error.toString(),
                              backgroundColor: redColor);
                          setState(() {
                            isLoading = false;
                          });
                        });
                      }
                    },
                  ).paddingTop(20);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text(
                    "Already have an account?",
                    textColor: grey,
                    fontSize: size13,
                  ),
                  textButton(
                    text: "login",
                    ontap: () {
                      const LoginScreen().launch(context);
                    },
                  )
                ],
              )
            ],
          ).paddingAll(size20),
        ),
      ),
    );
  }
}
