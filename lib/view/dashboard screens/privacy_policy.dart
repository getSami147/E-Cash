import 'package:flutter/material.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/utils/widget.dart';
import 'package:nb_utils/nb_utils.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: text("Privacy Policy"),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              text(
                  """Welcome to "E-Cash," where we prioritize the privacy of our users. We collect essential information during the registration process, such as your name and contact details, to facilitate the connection between individuals seeking help and those offering assistance. This data is securely stored and used exclusively for improving our platform's functionality and enhancing user experience. We adhere to industry-standard security measures to protect your information, and your preferences, including profile visibility and communication settings, are under your control. We may share aggregated, anonymized data for research purposes or with your explicit consent. Any updates to this Privacy Policy will be communicated to users. For inquiries or concerns, please contact us at [your contact details]. Thank you for being a part of the "E-Cash" community.""",
                  fontSize: size14, fontWeight: FontWeight.w400,maxLine: 5)
            ],
          ).paddingAll(size20),
        ));
  }
}
