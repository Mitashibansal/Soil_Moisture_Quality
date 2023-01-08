// ignore_for_file: prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:uia_app/app_theme.dart';
import 'package:uia_app/utils/loader.dart';
import 'package:uia_app/utils/scale.dart';

import 'home.controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.title = 'Flutter Demo'}) : super(key: key);

  // Fields in a StatefulWidget should always be "final".
  final String title;

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends StateMVC<HomeScreen> {
  _HomeScreenState() : super(Controller()) {
    con = controller as Controller;
  }
  late Controller con;
  late AppStateMVC appState;

  @override
  void initState() {
    super.initState();
    appState = rootState!;

    // var con = appState.controller;
    // // con = appState.controllerByType<AppController>();
    // con = appState.controllerById(con?.keyId);
    con.init();
  }

  // body(){
  //   if(con.loader ==LoaderStatus.empty){
  //     return Container();
  //   }
  //   else if (con.loader ==LoaderStatus.loaded){
  //     return Column(children: [],);
  //   }
  // }

  body() {
    if (con.loader == LoaderStatus.loading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.sh),
        child: Center(
          child: Loader.loader(context),
        ),
      );
    } else if (con.loader == LoaderStatus.error ||
        con.loader == LoaderStatus.empty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "",
              textAlign: TextAlign.center,
            ),
            // IconButton(icon: Icon(Icons.refresh, size: 24), onPressed: con.init)
          ]),
        ),
      );
    } else {
      return suggestions();
    }
  }

  suggestions() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
      children: [SizedBox(height:40.sh),
        Text("Quality of soil",style:TextStyle(fontWeight: FontWeight.w700,fontSize: 16.sf)),SizedBox(height:5.sh),
        Text(con.result!['Quality_of_the_soil'],style:TextStyle(fontWeight: FontWeight.normal,fontSize: 12.sf)),SizedBox(height:15.sh),
        Text("Suitable Crops",style:TextStyle(fontWeight: FontWeight.w700,fontSize: 16.sf)),SizedBox(height:5.sh),
        Text(con.result!['Crops_that_can_be_cultivated_in_this_soil'],style:TextStyle(fontWeight: FontWeight.normal,fontSize: 12.sf)),SizedBox(height:15.sh),
        Text("Irrigation",style:TextStyle(fontWeight: FontWeight.w700,fontSize: 16.sf)),SizedBox(height:5.sh),
        Text(con.result!['Water_required_for_Irrigation'],style:TextStyle(fontWeight: FontWeight.normal,fontSize: 12.sf)),SizedBox(height:15.sh),
        Text("Suggestions",style:TextStyle(fontWeight: FontWeight.w700,fontSize: 16.sf)),SizedBox(height:5.sh),
        Text("""${con.result!['Suggestions']}""",style:TextStyle(fontWeight: FontWeight.normal,fontSize: 12.sf)),SizedBox(height:15.sh),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text("Farmer's Desk"),actions: [IconButton(onPressed: con.onFeedbackPressed, icon: Icon(Icons.feedback))],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.sw, vertical: 15.sh),
            child: Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: con.onCaptureTapped,
                    child: Column(
                      children: [
                        Container(
                          width: 100.sd,
                          height: 100.sd,
                          padding: EdgeInsets.all(40.sd),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 40.sd,
                          ),
                        ),
                        Text(
                          "home.choose_image".tr(),
                          style: TextStyle(fontSize: 16.sf),
                        )
                      ],
                    ),
                  ),
                  body(),
                ],
              ),
            ),
          ),
        ),
      );
}
