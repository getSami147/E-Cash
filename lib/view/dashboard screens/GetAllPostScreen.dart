import 'package:flutter/material.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/utils/colors.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/Cash_to_E_Money.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/e_Money_to_Cash.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:muzahir_fyp/utils/widget.dart';

class GetAllPostScreen extends StatefulWidget {
  const GetAllPostScreen({super.key});

  @override
  State<GetAllPostScreen> createState() => _GetAllPostScreenState();
}

class _GetAllPostScreenState extends State<GetAllPostScreen>
    with TickerProviderStateMixin {
  final tabbarlist = ["E-Money to Cash", "Cash to E-Money"];
  @override
  Widget build(BuildContext context) {
    TabController control = TabController(length: 2, vsync: this);
    return Scaffold(
      appBar: AppBar(
        title: text("All Posts", fontWeight: FontWeight.bold),
      ),
      body: Column(
        children: [
          DefaultTabController(
              length: tabbarlist.length,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size8),
                        color: primaryColor.withOpacity(.5)),
                    height: size50,
                    child: TabBar(
                        onTap: (value) {
                          setState(() {});
                        },
                        dividerColor: transparentColor,
                        controller: control,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelPadding: const EdgeInsets.only(right: 6),
                        labelColor: Colors.white,
                        unselectedLabelColor: white,
                        indicatorColor: primaryColor,
                        indicator: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        tabs: [
                          text("E-Money to Cash", textColor: white),
                          text("Cash to E-Money", textColor: white),
                        ]),
                  )
                ],
              )).paddingSymmetric(vertical: 20),
          Expanded(
              child: TabBarView(controller: control, children: [
             E_Money_to_Cash(isAppbar: false,),
             Cash_to_E_Money(isAppbar: false,),
          ]))
        ],
      ).paddingSymmetric(horizontal: 15),
    );
  }
}
