import 'dart:async';

import 'package:flutter/material.dart';
import 'package:muzahir_fyp/utils/images.dart';
import 'package:muzahir_fyp/viewModel/userViewModel.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    var userViewModel=Provider.of<UserViewModel>(context,listen: false);
    // TODO: implement initState
    Timer(const Duration(seconds: 3), () {
      userViewModel.isCheckLogin(context);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Image.asset(
            image_logo,
            height: MediaQuery.sizeOf(context).height * .7,
            width: MediaQuery.sizeOf(context).width * .7,
          ))
        ],
      ),
    );
  }
}
