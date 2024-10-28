import 'package:flutter/material.dart';
import 'package:muzahir_fyp/GoogleMap/googleMapScreen.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/utils/colors.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/Cash_to_E_Money.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/drawer.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/e_Money_to_Cash.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/notification_screen.dart';
import 'package:muzahir_fyp/view/dashboard%20screens/post_screen.dart';
import 'package:muzahir_fyp/viewModel/userViewModel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:muzahir_fyp/utils/widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // final tabbarlist = ["E-Money to Cash", "Cash to E-Money"];
  int selectedIndex = 0;
  Color defaultBorderColor = white;
  Color selectedBorderColor = primaryColor;
  @override
  Widget build(BuildContext context) {
    // TabController control = TabController(length: 2, vsync: this);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
       const PostScreen().launch(context);

      },child: const Icon(Icons.add,color: white,),).paddingBottom( MediaQuery.sizeOf(context).height * .1),
      drawer: const DrawerScreen(),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                const NotificationScreen().launch(context);
              },
              icon:
                  const Icon(Icons.notifications_outlined).paddingRight(size15))
        ],
      ),
      body: Stack(alignment: Alignment.bottomCenter,
        children: [
          Consumer<UserViewModel>(builder: (context, userView, child) {
            return GoogleMapScreen(coordinates:[userView.currentLocation!.latitude,userView.currentLocation!.longitude],isBottomNav: true, currentLocation: "Current Location");

          },),
           Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  height: MediaQuery.sizeOf(context).height * .09,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: primaryColor.withOpacity(.2),
                      borderRadius: BorderRadius.circular(size10),
                      border: Border.all(width: 2, color: primaryColor)),
                  child: Center(
                    child: SizedBox(
                      height: size50,
                      // width: size100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: homeModel.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex =
                                    index; // Update selected index
                              });
                              homeModel[index].txt == "E-Money to Cash"
                                  ? E_Money_to_Cash(isAppbar: true,).launch(context)
                                  : Cash_to_E_Money(isAppbar: true,).launch(context);

                            },
                            child: Container(
                              width:
                                  MediaQuery.sizeOf(context).width * .38,
                              // width: MediaQuery.sizeOf(context).width * .3,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: index == selectedIndex
                                        ? selectedBorderColor
                                        : defaultBorderColor,
                                  ),
                                  color: index == selectedIndex
                                      ? selectedBorderColor
                                      : defaultBorderColor,
                                  borderRadius:
                                      BorderRadius.circular(8.0)),
                              child: Center(
                                child: text(homeModel[index].txt,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: size16,
                                        textColor: index == selectedIndex
                                            ? defaultBorderColor
                                            : selectedBorderColor,
                                        fontWeight: FontWeight.w500)
                                    .paddingAll(size5),
                              ),
                            ).paddingLeft(size10),
                          );
                        },
                      ),
                    ).paddingAll(size10),
                    
                  ),
                ),
              ),
            
         
       
        ],
      ),
    );
  }
}

//model
class HomeModel {
  String? txt;
  HomeModel({this.txt});
}

final homeModel = [
  HomeModel(txt: "E-Money to Cash"),
  HomeModel(txt: "Cash to E-Money"),
];
