import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uia_app/models/category.dart';
import 'package:uia_app/models/service.dart';
import 'package:path/path.dart' as p;

String chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
final Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => chars.codeUnitAt(_rnd.nextInt(chars.length))));

class ImageHelper {
  ImageHelper._();

  static compressFile(File file) async {
    final beforeCompress = await file.length();
    print("beforeCompress = $beforeCompress");
    String dir = p.dirname(file.path);
    String ext = p.extension(file.path);

    CompressFormat format = CompressFormat.jpeg;
    if (ext.contains(".jpg") || ext.contains(".jpeg")) {
      format = CompressFormat.jpeg;
    } else if (ext.contains(".png")) {
      format = CompressFormat.png;
    }

    File? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      dir + "compressed +${getRandomString(5)}" + ext,
      format: format,
      quality: 70,
    );
    final afterCompress = await result?.length();
    print("after = $afterCompress");

    return result;
    // return file;
  }
}
