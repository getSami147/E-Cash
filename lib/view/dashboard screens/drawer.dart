import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:muzahir_fyp/utils/images.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/utils/colors.dart';
import 'package:muzahir_fyp/view/auth%20screens/logOut.dart';
import 'package:muzahir_fyp/view/auth%20screens/updateProfile.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/about_us.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/help_support.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/setting_screen.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/your_post.dart';
import 'package:muzahir_fyp/viewModel/userViewModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:muzahir_fyp/utils/widget.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({
    super.key,
  });

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
    String? address;

  Future<void> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      setState(() {
        address = '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      });
    } catch (e) {
      print(e);
    }
  }

  void showAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Your Address'),
          content: address != null ? Text(address!) : Text('Address not found'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
   var username;
    var size = MediaQuery.of(context).size;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Drawer(
      width: size.width * .6,
      child: SafeArea(
        child: Column(
          children: [
            FutureBuilder<DocumentSnapshot>(
                future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
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
              ).paddingTop(20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                     Consumer<UserViewModel>(builder: (context, userView, child) {
                       return       drawerRow(
                    icon: Icons.person_outline,
                    title: "Show Address",
                    ontap: () async {               
                await getAddressFromCoordinates(userView.currentLocation!.latitude??0,userView.currentLocation!.longitude??0);
                showAddressDialog(context);
                    },
                  );
                     },),
                
                    
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

class drawerRow extends StatelessWidget {
  IconData? icon;
  var title;
  VoidCallback? ontap;
  drawerRow({
    this.icon,
    this.title,
    this.ontap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: ontap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon).paddingRight(size15),
              text(title, fontWeight: FontWeight.w400, fontSize: size14)
            ],
          ).paddingBottom(size10),
        ),
        const Divider()
      ],
    );
  }
}
