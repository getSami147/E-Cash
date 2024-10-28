import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muzahir_fyp/utils/images.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/components/build_button.dart';
import 'package:muzahir_fyp/components/textfield.dart';
import 'package:muzahir_fyp/utils/widget.dart';
import 'package:muzahir_fyp/view/auth%20screens/login_screen.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _value;
  File? _imageFile;
//cover image of store
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              text("Set Your Profile ",
                      fontWeight: FontWeight.w500, fontSize: size18)
                  .paddingBottom(size30),
              Stack(
                alignment: Alignment.center,
                children: [
                  _imageFile == null
                      ? Container(
                          height: size100,
                          width: size100,
                          decoration: const BoxDecoration(
                              // borderRadius: BorderRadius.circular(20.0),
                              shape: BoxShape.circle),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(80.0),
                            child: Image.asset(
                              image_profile,
                              height: 65,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          height: size100,
                          width: size100,
                          decoration: const BoxDecoration(
                              // borderRadius: BorderRadius.circular(20.0),
                              shape: BoxShape.circle),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(80.0),
                            child: Image.file(
                              _imageFile!,
                              height: 65,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  Positioned(
                    top: 15,
                    right: 15,
                    bottom: 15,
                    left: 15,
                    child: GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: const Center(
                        child: Icon(
                          Icons.camera_alt,
                          color: white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ).paddingBottom(size20),
              textField(
                hint: "Full Name",
                labell: text("Full Name"),
                maxline: 1,
              ),
              textField(
                hint: "Email",
                maxline: 1,
                labell: text("Email"),
              ),
              textField(
                hint: "street",
                maxline: 1,
                labell: text("street"),
              ),
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
                    hint: text("City",
                        textColor: black, fontWeight: FontWeight.w400),
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    items: ['lahore', 'peshawar', 'faisalabad']
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
                    },
                  ),
                ),
              ).paddingOnly(top: size10, bottom: size20),
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
                    hint: text("District",
                        textColor: black, fontWeight: FontWeight.w400),
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    items: ['waziristan', 'kohat', 'karak', 'lakki', 'peshawar']
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
                    },
                  ),
                ),
              ).paddingOnly(top: size10, bottom: size20),
              Row(
                children: [
                  BuildButton(
                          width: MediaQuery.sizeOf(context).width * .4,
                          onPressed: () {
                            finish(context);
                          },
                          text: "Cancel")
                      .paddingRight(size10),
                  BuildButton(
                      width: MediaQuery.sizeOf(context).width * .4,
                      onPressed: () {
                        const LoginScreen().launch(context);
                      },
                      text: "Save"),
                ],
              ),
            ],
          ).paddingAll(size20),
        ),
      ),
    );
  }
}
