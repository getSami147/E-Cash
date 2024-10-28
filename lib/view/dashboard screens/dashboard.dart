import 'dart:io';

import 'package:flutter/material.dart';
import 'package:muzahir_fyp/utils/colors.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/account_screen.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/chatting.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/GetAllPostScreen.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/home_screen.dart';
import 'package:muzahir_fyp/viewModel/userViewModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:muzahir_fyp/utils/widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
     // TODO: implement initState
    super.initState();
    var userViewModel=Provider.of<UserViewModel>(context,listen: false);
    userViewModel.getLocationAndShowDialog(context);
    userViewModel.getCurrentLocationPermission();
    userViewModel.getUserTokens();
    debugPrint("userid:${userViewModel.userId}");
    debugPrint("current location:${userViewModel.currentLocation}");
    debugPrint("isGoogleSignup:${userViewModel.isGoogleSignup}");
   
  }
  int currentIndex = 0;
  final List<Widget> screens = [
    const HomeScreen(),
    const GetAllPostScreen(),
    const ChatScreen(),
    const AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.home_outlined),
            title: text("Home", textColor: black),
            selectedColor: primaryColor,
          ),

          /// order
          SalomonBottomBarItem(
            icon: const Icon(Icons.payment_outlined),
            title: text("Posts", textColor: black),
            selectedColor: primaryColor,
          ),

          /// chat
          SalomonBottomBarItem(
            icon: const Icon(Icons.chat),
            title: text("Chat", textColor: black),
            selectedColor: primaryColor,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(Icons.person_2_outlined),
            title: text("profile", textColor: black),
            selectedColor: primaryColor,
          ),
        ],
      ),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          if (currentIndex != 0) {
            currentIndex = 0;
            setState(() {});
          } else {
            // Show exit confirmation dialog
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Exit the app?'),
                  content: const Text('Are you sure you want to exit the app?'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: text("NO")),
                    TextButton(
                        onPressed: () {
                          exit(0);
                        },
                        child: text("Yes")),
                  ],
                );
              },
            );
          }
          return false;
        },
        child: PageView(
          children: [screens[currentIndex]],
        ),
      ),
    );
  }
}
