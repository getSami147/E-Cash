import 'package:flutter/material.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:muzahir_fyp/utils/widget.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: text("About Us"),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              text(
                  "Welcome to 'E-Cash', a community-driven platform dedicated to fostering connections and making assistance accessible to everyone, anytime, and anywhere. Our mission is to bridge the gap between those in need, creating a supportive environment where users can provide or receive assistance seamlessly. Join us in building a network of compassion and support.",
                  fontSize: size14, fontWeight: FontWeight.w400,maxLine: 15)
            ],
          ).paddingAll(size20),
        ));
  }
}
