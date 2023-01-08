// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:uia_app/utils/date_time_helper.dart';
import 'package:uia_app/utils/loader.dart';
import 'package:uia_app/utils/shimmer.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:uia_app/utils/scale.dart';

import '../../app_theme.dart';
import 'feedback.controller.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key, this.title = 'Flutter Demo'})
      : super(key: key);

  // Fields in a StatefulWidget should always be "final".
  final String title;

  @override
  State createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends StateMVC<FeedbackScreen> {
  _FeedbackScreenState() : super(Controller()) {
    con = controller as Controller;
  }
  late Controller con;
  late AppStateMVC appState;

  FocusNode? nameFocus;
  FocusNode? genderFocus;
  FocusNode? doorNoFocus;
  FocusNode? buildingNameFocus;
  FocusNode? streetNameFocus;
  FocusNode? landMarkFocus;
  FocusNode? pinCodeFocus;

  @override
  void initState() {
    super.initState();
    appState = rootState!;

    // var con = appState.controller;
    // // con = appState.controllerByType<AppController>();
    // con = appState.controllerById(con?.keyId);
    con.init();
    nameFocus = FocusNode();
    genderFocus = FocusNode();
    doorNoFocus = FocusNode();
    buildingNameFocus = FocusNode();
    streetNameFocus = FocusNode();
    landMarkFocus = FocusNode();
    pinCodeFocus = FocusNode();
  }

  editProfileUi() {
    return Form(
      key: con.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20.0.sh,
          ),
          
          // Align(
          //   alignment: Alignment.center,
          //   child: CachedNetworkImage(
          //       height: 70.0.sd,
          //       width: 70.0.sd,
          //       imageUrl: "https://picsum.photos/800/500",
          //       imageBuilder: (context, provider) {
          //         return CircleAvatar(radius: 20, backgroundImage: provider);
          //       },
          //       placeholder: (context, url) => ShimmerCustom(),
          //       errorWidget: (context, url, error) => Icon(Icons.error)),
          // ),
          SizedBox(
            height: 10.0.sh,
          ),
          TextFormField(
            initialValue: con.user?.name,
            textAlign: TextAlign.start,
            maxLength: 25,
            decoration: InputDecoration(
              // hintText: "Name",
              hintStyle: TextStyle(fontSize: 16.sf),
              counterText: "",
              errorStyle: TextStyle(fontSize: 12.sf),
              label: Text("Name"),
            ),
            // inputFormatters: <TextInputFormatter>[
            //   WhitelistingTextInputFormatter.digitsOnly,
            // ],
            autofocus: false,
            enabled: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            focusNode: nameFocus,
            onFieldSubmitted: (value) {
              nameFocus?.unfocus();
            },
            style: TextStyle(fontSize: 16.sf, color: Colors.black),
            validator: (value) {
              if (value!.isEmpty) {
                return "Required";
              }
              return null;
            },
            onSaved: (value) {
              con.updateduser?.name = value;
            },
          ),
          SizedBox(
            height: 10.0.sh,
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(8.sd)),
                ),
                onPressed: () {
                  DateTime today = DateTime.now();
                  DateTime minTime = DateTime(today.year - 90);
                  DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    minTime: minTime,
                    maxTime: today,
                    onConfirm: (date) {
                      print('confirm $date');
                      setState(() {
                        con.updateduser?.dob = date;
                      });
                    },
                    currentTime: DateTime.now(),
                    //  locale: LocaleType.zh
                  );
                },
                child: Text(
                  (con.updateduser?.dob != null || con.user?.dob != null)
                      ? "Date of Birth: " +
                          DateTimeHelper.getReadableDate(
                              con.updateduser?.dob ?? con.user?.dob)
                      : 'Date of Birth',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )),
          ),
          SizedBox(
            height: 10.0.sh,
          ),
          DropdownButtonFormField<String>(
            value: con.user?.gender,
            // icon: const Icon(Icons.arrow_downward),,
            hint: Text("Gender"), isExpanded: true,
            focusNode: genderFocus,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 15.sw),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      style: BorderStyle.solid)),
              label: Text("Gender"),
            ),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),

            onChanged: (String? newValue) {
              setState(() {
                con.updateduser?.gender = newValue;
                con.user?.gender = newValue;
              });

              FocusScope.of(context).requestFocus(doorNoFocus);
            },
            items: <String>[
              'Male',
              'Female',
              'Other',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              );
            }).toList(),
          ),
          SizedBox(
            height: 7.0.sh,
          ),
          Text(
            "Address",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 14.0.sf,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 10.0.sh,
          ),
          TextFormField(
            initialValue: con.user?.doorNumber,
            textAlign: TextAlign.start,
            maxLength: 50,
            decoration: InputDecoration(
              // hintText: "Door Number",
              hintStyle: TextStyle(fontSize: 16.sf),
              counterText: "",
              errorStyle: TextStyle(fontSize: 12.sf),
              label: Text("Door Number"),
            ),
            // inputFormatters: <TextInputFormatter>[
            //   WhitelistingTextInputFormatter.digitsOnly,
            // ],
            autofocus: false,
            enabled: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            focusNode: doorNoFocus,
            onFieldSubmitted: (value) {
              doorNoFocus?.unfocus();
              FocusScope.of(context).requestFocus(buildingNameFocus);
            },
            style: TextStyle(fontSize: 16.sf, color: Colors.black),
            validator: (value) {
              if (value!.isEmpty) {
                return "Required";
              }
              return null;
            },
            onSaved: (value) {
              con.updateduser?.doorNumber = value;
            },
          ),
          TextFormField(
            initialValue: con.user?.buildingName,
            textAlign: TextAlign.start,
            maxLength: 50,
            decoration: InputDecoration(
              // hintText: "Building Name",
              hintStyle: TextStyle(fontSize: 16.sf),
              counterText: "",
              errorStyle: TextStyle(fontSize: 12.sf),
              label: Text("Building Name"),
            ),
            // inputFormatters: <TextInputFormatter>[
            //   WhitelistingTextInputFormatter.digitsOnly,
            // ],
            autofocus: false,
            enabled: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next, focusNode: buildingNameFocus,
            onFieldSubmitted: (value) {
              buildingNameFocus?.unfocus();
              FocusScope.of(context).requestFocus(streetNameFocus);
            },
            style: TextStyle(fontSize: 16.sf, color: Colors.black),
            validator: (value) {
              if (value!.isEmpty) {
                return "Required";
              }
              return null;
            },
            onSaved: (value) {
              con.updateduser?.buildingName = value;
            },
          ),
          TextFormField(
            initialValue: con.user?.streetName,
            textAlign: TextAlign.start,
            maxLength: 50,
            decoration: InputDecoration(
              // hintText: "Street name",
              hintStyle: TextStyle(fontSize: 16.sf),
              counterText: "",
              errorStyle: TextStyle(fontSize: 12.sf),
              label: Text("Street name"),
            ),
            // inputFormatters: <TextInputFormatter>[
            //   WhitelistingTextInputFormatter.digitsOnly,
            // ],
            autofocus: false,
            enabled: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next, focusNode: streetNameFocus,
            onFieldSubmitted: (value) {
              streetNameFocus?.unfocus();
              FocusScope.of(context).requestFocus(landMarkFocus);
            },
            style: TextStyle(fontSize: 16.sf, color: Colors.black),
            validator: (value) {
              if (value!.isEmpty) {
                return "Required";
              }
              return null;
            },
            onSaved: (value) {
              con.updateduser?.streetName = value;
            },
          ),
          TextFormField(
            initialValue: con.user?.landmark,
            textAlign: TextAlign.start,
            maxLength: 50,
            decoration: InputDecoration(
              // hintText: "Landmark",
              hintStyle: TextStyle(fontSize: 16.sf),
              counterText: "",
              errorStyle: TextStyle(fontSize: 12.sf),
              label: Text("Landmark"),
            ),
            // inputFormatters: <TextInputFormatter>[
            //   WhitelistingTextInputFormatter.digitsOnly,
            // ],
            autofocus: false,
            enabled: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next, focusNode: landMarkFocus,
            onFieldSubmitted: (value) {
              landMarkFocus?.unfocus();
              FocusScope.of(context).requestFocus(pinCodeFocus);
            },
            style: TextStyle(fontSize: 16.sf, color: Colors.black),
            validator: (value) {
              if (value!.isEmpty) {
                return "Required";
              }
              return null;
            },
            onSaved: (value) {
              con.updateduser?.landmark = value;
            },
          ),
          TextFormField(
            initialValue: con.user?.pincode,
            textAlign: TextAlign.start,
            maxLength: 10,
            decoration: InputDecoration(
              // hintText: "Pincode",
              hintStyle: TextStyle(fontSize: 16.sf),
              counterText: "",
              errorStyle: TextStyle(fontSize: 12.sf),
              label: Text("Pincode"),
            ),
            // inputFormatters: <TextInputFormatter>[
            //   WhitelistingTextInputFormatter.digitsOnly,
            // ],
            autofocus: false,
            enabled: true,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done, focusNode: pinCodeFocus,
            onFieldSubmitted: (value) {
              streetNameFocus?.unfocus();
              con.onSavePressed();
            },
            style: TextStyle(fontSize: 16.sf, color: Colors.black),
            validator: (value) {
              if (value!.isEmpty) {
                return "Required";
              }
              // else if (!con.isPhoneNumberValid(value)) {
              //   return Strings.mobileNumberMissing;
              // }
              return null;
            },
            onSaved: (value) {
              con.updateduser?.pincode = value;
            },
          ),
        ],
      ),
    );
  }

  body() {
    if (con.loadingStatus == LoaderStatus.loading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Loader.loader(context),
        ),
      );
    } else if (con.loadingStatus == LoaderStatus.error ||
        con.loadingStatus == LoaderStatus.empty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              con.errorMessage ?? "",
              textAlign: TextAlign.center,
            ),
            IconButton(icon: Icon(Icons.refresh, size: 24), onPressed: con.init)
          ]),
        ),
      );
    } else {
      return editProfileUi();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Edit Profile"),
          actions: [
            if (con.loadingStatus == LoaderStatus.loaded)
              TextButton(
                  onPressed: con.onSavePressed,
                  child: Text("SAVE", style: TextStyle(color: Colors.white)))
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.sw, vertical: 15.sh),
            child: SingleChildScrollView(child: body()),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          key: const Key('+'),
          onPressed: () => con.onSavePressed(),
          child: const Icon(Icons.done),
        ),
      );
}
