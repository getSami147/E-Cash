import 'package:flutter/material.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:muzahir_fyp/utils/widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text("Notifications"),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text("Today", fontWeight: FontWeight.bold, fontSize: size16)
                .paddingBottom(size20),
            buildNotification(
              title: "Request for E-Money",
              desc: "Someone nearby needs your assistance. Be a Helping Hand!",
              color: primaryColor.withOpacity(.3),
            ),
            buildNotification(
              title: "Order for Cash",
              desc:
                  "Your order has been acknowledge, Thank you for making a difference!",
              color: white,
            ).paddingBottom(size20),
            text("Yesterday", fontWeight: FontWeight.bold, fontSize: size16)
                .paddingBottom(size20),
            buildNotification(
              title: "Request for E-Money",
              desc: "Someone nearby needs your assistance. Be a Helping Hand!",
              color: primaryColor.withOpacity(.3),
            ),
            buildNotification(
              title: "Order for Cash",
              desc:
                  "Your order has been acknowledge, Thank you for making a difference!",
              color: white,
            ),
            buildNotification(
              title: "Order for Cash",
              desc:
                  "Your order has been acknowledge, Thank you for making a difference!",
              color: white,
            ),
            buildNotification(
              title: "Request for E-Money",
              desc: "Someone nearby needs your assistance. Be a Helping Hand!",
              color: primaryColor.withOpacity(.3),
            ),
          ],
        ).paddingAll(size20),
      ),
    );
  }
}

class buildNotification extends StatelessWidget {
  var title, desc;
  Color? color;
  buildNotification({
    this.title,
    this.desc,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text(title, fontWeight: FontWeight.bold, fontSize: size16)
              .paddingBottom(size10),
          text(desc,
                  fontWeight: FontWeight.w400,
                  textColor: gray,
                  fontSize: size14)
              .paddingBottom(size5),
          text("15 days ago",
                  fontWeight: FontWeight.w400,
                  textColor: gray,
                  fontSize: size14)
              .paddingBottom(size10),
        ],
      ).paddingAll(size12),
    );
  }
}
