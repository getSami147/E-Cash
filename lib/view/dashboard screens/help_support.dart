import 'package:flutter/material.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:muzahir_fyp/utils/widget.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: text("Help & Support"),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              text(
                  "Lorem ipsum dolor sit amet consectetur. Sit pulvinar mauris mauris eu nibh semper nisl pretium laoreet. Sed non faucibus ac lectus eu arcu. Nulla sit congue facilisis vestibulum egestas nisl feugiat pharetra. Odio sit tortor morbi at orci ipsum dapibus interdum. Lorem felis est aliquet arcu nullam pellentesque. Et habitasse ac arcu et nunc euismod rhoncus facilisis sollicitudin.",
                  fontSize: size14, fontWeight: FontWeight.w400,maxLine: 15)
            ],
          ).paddingAll(size20),
        ));
  }
}
