import 'package:flutter/material.dart';
import 'package:muzahir_fyp/utils/images.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/components/build_button.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/review_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:muzahir_fyp/utils/widget.dart';

class ThanksScreen extends StatefulWidget {
  const ThanksScreen({super.key});

  @override
  State<ThanksScreen> createState() => _ThanksScreenState();
}

class _ThanksScreenState extends State<ThanksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(
                  flex: 1,
                ),
                Image.asset(
                  image_thanks,
                  height: size80,
                  width: size80,
                ).paddingBottom(size20),
                text("Thank You", fontWeight: FontWeight.w500, fontSize: size16)
                    .paddingBottom(size10),
                text("for Using our services",
                        fontWeight: FontWeight.w400, fontSize: size16)
                    .paddingBottom(size10),
                text("Be a part of a caring community. Whether you need cash or want to exchange your cash into E-Money, E-Cash is the platform where users connect to provide or receive assistance, fostering a culture of empathy and support.",
                        fontWeight: FontWeight.w400,
                        fontSize: size13,
isCentered: true,                        textColor: gray)
                    .paddingBottom(size20),
                const Spacer(
                  flex: 1,
                ),
                text("How is our App?",
                        fontWeight: FontWeight.w500, fontSize: size16)
                    .paddingBottom(size10),
                text("Your feedback will help us to improve our driving experience better",
                        isCentered: true,
                        fontWeight: FontWeight.w400,
                        fontSize: size14)
                    .paddingBottom(size10),
                BuildButton(
                        onPressed: () {
                          const ReviewScreen().launch(context);
                        },
                        text: "Please Feedback")
                    .paddingBottom(size30)
              ],
            ).paddingAll(size20),
          )
        ],
      ),
    );
  }
}
