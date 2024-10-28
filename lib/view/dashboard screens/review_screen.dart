import 'package:flutter/material.dart';
import 'package:muzahir_fyp/utils/images.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/components/build_button.dart';
import 'package:muzahir_fyp/components/textfield.dart';
import 'package:muzahir_fyp/utils/colors.dart';
import 'package:muzahir_fyp/utils/widget.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/dashboard.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
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
                SizedBox(
                    width: MediaQuery.sizeOf(context).width * .3,
                    child: const Divider(
                      color: gray,
                      thickness: 3,
                    )).paddingBottom(size20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 5; i++) ...[
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: size25,
                      ).paddingRight(size5)
                    ]
                  ],
                ).paddingBottom(size20),
                text("Excellent",
                        fontWeight: FontWeight.w500,
                        textColor: primaryColor,
                        fontSize: size16)
                    .paddingBottom(size10),
                text("You rated E-Cash 5 stars",
                        fontWeight: FontWeight.w400,
                        textColor: gray,
                        fontSize: size14)
                    .paddingBottom(size10),
                textField(
                  height: size100,
                  hint: "write your text here...",
                  maxline: 3,
                  labell: text("Post"),
                ),
                const Spacer(
                  flex: 1,
                ),
                BuildButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: MediaQuery.sizeOf(context).height * .5,
                                child: AlertDialog(
                                  title: Image.asset(
                                    height: size100,
                                    image_thanks,
                                  ),
                                  content: text(
                                          "Thank you for your valuable feedback and tip",
                                          fontWeight: FontWeight.w400,
                                          isCentered: true,
                                          fontSize: size13)
                                      .paddingBottom(size10),
                                  actions: [
                                    BuildButton(
                                        onPressed: () {
                                          const Dashboard().launch(context);
                                        },
                                        text: "Back Home")
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        text: "Submit")
                    .paddingBottom(size30)
              ],
            ).paddingAll(size20),
          )
        ],
      ),
    );
  }
}
