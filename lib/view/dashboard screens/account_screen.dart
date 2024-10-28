import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/utils/Images.dart';
import 'package:muzahir_fyp/utils/colors.dart';
import 'package:muzahir_fyp/view/auth%20screens/logOut.dart';
import 'package:muzahir_fyp/view/auth%20screens/updateProfile.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/about_us.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/drawer.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/help_support.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/setting_screen.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/your_post.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:muzahir_fyp/utils/widget.dart';


class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var username;
    var size = MediaQuery.of(context).size;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      body: SafeArea(
        child: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
              future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
               if (snapshot.connectionState==ConnectionState.waiting) {
                 return const CircularProgressIndicator();
               } else if (snapshot.hasData) {
                    username=snapshot.data!['username'].toString();
                  return Column(
                    children: [
                      snapshot.data!['userImage'] == null|| snapshot.data!['userImage']!.isEmpty
                  ? CircleAvatar(
                      radius:  size.width * .14,
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
                         snapshot.data!['userImage'].toString(),
                        height: size.width * .24,
                        width: size.width * .24,
                        fit: BoxFit.cover,
                      )),
                    ),
                    
                      text(snapshot.data!['username'].toString(),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600)
                          .paddingTop(10),
                      text(snapshot.data!['email'].toString(),
                          fontSize: 11.0, textColor: Colors.grey),
                    ],
                  );
                } else {
                  return const Column(
                    children: [
                      Center(child: CircularProgressIndicator()),
                    ],
                  );
                }
              },
            ).paddingTop(40),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    drawerRow(
                    icon: Icons.person_outline,
                    title: "Update Profile",
                    ontap: () {
                       UpdateProfileScreen(username:username,).launch(context);
                    },
                  ),
                  drawerRow(
                    icon: Icons.king_bed,
                    title: "About Us",
                    ontap: () {
                      const AboutUsScreen().launch(context);
                    },
                  ),
                  drawerRow(
                    icon: Icons.post_add,
                    title: "Yours Posts",
                    ontap: () {
                       YourPosts().launch(context);
                    },
                  ),
                  drawerRow(
                    icon: Icons.settings,
                    title: "Setting",
                    ontap: () {
                      const SettingScreen().launch(context);
                    },
                  ),
                  drawerRow(
                    icon: Icons.help,
                    title: "Help & Support",
                    ontap: () {
                      const HelpScreen().launch(context);
                    },
                  ),
                  drawerRow(
                    icon: Icons.logout,
                    title: "Logout",
                    ontap: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          // Delete Page (Dialog Box) is Called.............>>>
                          return const LogoutAccount();
                        },
                      );
                    },
                  ),
                ],
              ).paddingAll(size20),
            ),
          ),
        ],
                ),
      ),
    );
  }
}
