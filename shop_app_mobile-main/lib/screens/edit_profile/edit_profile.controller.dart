import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uia_app/models/user.dart';
import 'package:uia_app/utils/flushbar.dart';
import 'package:uia_app/utils/image_helper.dart';
import 'package:uia_app/utils/loader.dart';
import 'package:uia_app/utils/logger.dart';
import 'package:uia_app/utils/pages.dart';
import 'package:uia_app/utils/settings.dart';
import 'package:uia_app/utils/upload_helper.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'edit_profile.model.dart';
import 'package:path/path.dart' as p;

class Controller extends ControllerMVC {
  factory Controller([StateMVC? state]) {
    // return _this ??= Controller._(state);
    return Controller._(state);
  }
  Controller._(StateMVC? state)
      : _model = Model(),
        super(state);
  static Controller? _this;

  Model _model;

  /// Note, the count comes from a separate class, _Model.
  // int get count => _model.counter;
  // set count(value) => _model.count = value;

  LoaderStatus? get loadingStatus => _model.loadingStatus;
  String? get errorMessage => _model.errorMessage;
  User? get user => _model.user;
  User? get updateduser => _model.updatedUser;
  get formKey => _model.formKey;
  get selectedImage => _model.selectedImage;

  final log = getLogger('template');

  @override
  void dispose() {
    //runs second
    _this = null;
    super.dispose();
  }

  void init() {
    getUser();
  }

  getUser() async {
    try {
      // throw "Order list screen";
      _model.user = await _model.getUser();

      setState(() {
        _model.loadingStatus = LoaderStatus.loaded;
      });
      // print("state" + this.stateMVC.keyId);

    } catch (e) {
      log.e(e.toString());

      setState(() {
        _model.loadingStatus = LoaderStatus.error;
        _model.errorMessage = e.toString();
      });
    }
  }

  saveProfile() async {
    try {
      if (_model.selectedImage != null &&
          _model.updatedUser?.profileUrl == null) {
        String imageUrl = await uploadImage();
        _model.updatedUser?.profileUrl = imageUrl;
      }
      await Loader.startFullScreenLoader(state!.context, "Saving Profile..");

      await _model.saveProfile();
      await Loader.hideFullScreenLoader();
      FlushBarHelper.show(state!.context,
          message: "Profile Updated Successfully");
    } catch (e) {
      log.e(e.toString());
      await Loader.hideFullScreenLoader();
      FlushBarHelper.show(state!.context, message: e.toString());
    }
  }

  uploadImage() async {
    final String uuid = Uuid().generateV4();
    log.d(uuid);
    String s3Path = UploadHelper().getServiceImageLocation(uuid) +
        p.extension(_model.selectedImage!.path);

    ProgressLoader.startProgressLoader(state!.context, "Uploading Image...");
    ProgressLoader.updateProgressLoader(
        message: "Uploading Image...", progress: 0);
    // await UploadHelper().uploadImage(
    //     file: _model.selectedImage,
    //     objectAddress: s3Path,
    //     updateProgress: updateProgress,
    //     fileName: uuid +
    //         p.extension(
    //           _model.selectedImage!.path,
    //         ));
    await ProgressLoader.hideProgressLoader();
    return s3Path;
  }

  updateProgress(double value) {
    print(value);
    ProgressLoader.updateProgressLoader(
        message: "Uploading Image...", progress: value);
  }

  onSavePressed() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();

    await saveProfile();
  }

  Future<String?> pickImage() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      _model.updatedUser?.profileUrl = null;
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) throw "Please choose a picture";
      File compressedFile = await ImageHelper.compressFile(File(image.path));

      setState(() {
        _model.selectedImage = compressedFile;
      });
    } on MissingPluginException {
      FlushBarHelper.show(state!.context,
          message: "Unexpected error occured. please reopen the app");
    } on PlatformException {
      FlushBarHelper.show(state!.context,
          message: "Unable to access gallery. Please provide permission");
    } catch (e) {
      FlushBarHelper.show(state!.context, message: e.toString());
    }
  }
}
