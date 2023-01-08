// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uia_app/app_theme.dart';

class AddAvatar extends StatelessWidget {
  final String? currentAvatarUrl;
  final File? image;
  final Function? chooseProfilePhoto;
  final double imageSize;
  final bool isAddIconRequired;

  AddAvatar(
      {this.currentAvatarUrl,
      this.image,
      this.chooseProfilePhoto,
      required this.imageSize,
      this.isAddIconRequired = true});

  @override
  Widget build(BuildContext context) {
    if (image != null || currentAvatarUrl != null) {
      return InkWell(
        child: Stack(
          // overflow: Overflow.visible,
          children: [
            if (image != null)
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill, image: FileImage(image!)),
                ),
              ),
            if (image == null && currentAvatarUrl != null)
              CachedNetworkImage(
                imageUrl: currentAvatarUrl!,
                imageBuilder: (context, imageProvider) => Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Icon(
                    Icons.person,
                    size: 30,
                  ),
                ),
                errorWidget: (context, url, error) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Icon(
                    Icons.person,
                    size: 30,
                  ),
                ),
              ),
            if (isAddIconRequired)
              Positioned(
                top: imageSize * 0.6,
                left: imageSize * 0.6,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 18.0,
                  child:
                      new Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ),
          ],
        ),
        onTap: () async {
          await chooseProfilePhoto!();
        },
      );
    } else
      // ignore: curly_braces_in_flow_control_structures
      return Container(
        padding: EdgeInsets.all(5),
        width: imageSize,
        height: imageSize,
        decoration:
            BoxDecoration(color: AppColors.lightGrey, shape: BoxShape.circle),
        child: IconButton(
          icon: Icon(
            Icons.add_a_photo,
            color: Colors.white,
            size: 32,
          ),
          onPressed: () {
            chooseProfilePhoto!();
          },
        ),
      );
  }
}
