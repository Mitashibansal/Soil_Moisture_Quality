import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:uia_app/utils/flushbar.dart';
import 'package:uia_app/utils/loader.dart';
import 'package:uia_app/utils/logger.dart';
import 'package:uia_app/utils/pages.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'home.model.dart';

// import 'package:tflite_flutter/tflite_flutter.dart';

class Controller extends ControllerMVC {
  factory Controller([StateMVC? state]) {
    // return _this ??= Controller._(state);
    return Controller._(state);
  }
  Controller._(StateMVC? state)
      : _model = Model(),
        super(state);
  static Controller? _this;

  final Model _model;

  /// Note, the count comes from a separate class, _Model.
  LoaderStatus get loader => _model.loader;
  Map? get result => _model.result;
  set result(value) => _model.result = value;

  final log = getLogger('template');

  void init() {}

  Future<void> onCaptureTapped() async {
    await pickImage();
    setState(() {
      _model.loader = LoaderStatus.loading;
      _model.result = null;
    });
    _model.result = await getRow(60);
    setState(() {
      _model.loader = LoaderStatus.loaded;
    });
    // await checkModel();
  }
  num rvalue(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  getRow(int value) async {
    //60-160
    // int value = 120;
    num value = rvalue(50,70);
    log.d(value);
    double percent = value.toDouble();

    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "app.db");

// Delete any existing database:
    await deleteDatabase(dbPath);

// Create the writable database file from the bundled demo database file:
    ByteData data = await rootBundle.load("assets/sqlite.db");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);
    // Get a location using getDatabasesPath
    var db = await openDatabase(dbPath);

    List<Map> list = await db.rawQuery(
        'Select * from T1 where start <=$percent AND last >= $percent');
    Map row = list.first;
    // String suggestions = row['Suggestions'].replaceAll('\n', '\n');
    // Map newRow={};
    // newRow['Suggestions'] = suggestions;
    //  newRow['Quality_of_the_soil'] = row['Quality_of_the_soil'];
    //  newRow['Crops_that_can_be_cultivated_in_this_soil'] = row['Crops_that_can_be_cultivated_in_this_soil'];
    //  newRow['Water_required_for_Irrigation'] = row['Water_required_for_Irrigation'];
    return row;
  }
//   checkModel2() async {
//     // final interpreter = await tfl.Interpreter.fromAsset('your_model.tflite');

//     ImageProcessor imageProcessor = ImageProcessorBuilder()
//   .add(ResizeOp(224, 224, ResizeMethod.NEAREST_NEIGHBOUR))
//   .build();

// // Create a TensorImage object from a File
// TensorImage tensorImage = TensorImage.fromFile(_model.selectedImage!);

// // Preprocess the image.
// // The image for imageFile will be resized to (224, 224)
// tensorImage = imageProcessor.process(tensorImage);
//   }

  checkModel() async {
    // await Tflite.close();
    String? result = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/label.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );

    log.d("okay11");
    log.d(result);
    log.d(_model.selectedImage!.path);
    var recognitions = await Tflite.runModelOnImage(
        path: _model.selectedImage!.path, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true);
    log.d("rec");
    log.d(recognitions);
  }

  Future<String?> pickImage() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      // _model.updatedUser?.profileUrl = null;
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) throw "home.please_choose".tr();
      // File compressedFile = await ImageHelper.compressFile(File(image.path));

      setState(() {
        _model.selectedImage = File(image.path);
      });
    } on MissingPluginException {
      FlushBarHelper.show(state!.context,
          message: "home.unexpected_error".tr());
    } on PlatformException {
      FlushBarHelper.show(state!.context, message: "home.access_gallery".tr());
    } catch (e) {
      FlushBarHelper.show(state!.context, message: e.toString());
    }
  }

  void onFeedbackPressed() {
    // Navigator.of(state!.context).pushNamed(Pages.feedback);
  }
}
