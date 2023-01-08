import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mime_type/mime_type.dart';

import 'logger.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart';

class UploadHelper {
  static final UploadHelper _singleton = UploadHelper._internal();
  bool isPermissionRequested = false;
  factory UploadHelper() {
    return _singleton;
  }
  final log = getLogger('permission handler');
  UploadHelper._internal();

  getServiceImageLocation(String? filename) {
    return "service_images/" + filename!;
  }

  getRequirementImageLocation(String? filename) {
    return "requirement_images/" + filename!;
  }

  // uploadImage(
  //     {File? file,
  //     required String objectAddress,
  //     String? fileName,
  //     Function? updateProgress}) async {
  //   final minio = Minio(
  //       endPoint: 's3.amazonaws.com',
  //       accessKey: 'AKIASRUCD7YPEUJBZW4U',
  //       secretKey: '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',
  //       region: 'ap-south-1');
  //   Stream<Uint8List>? image = file?.readAsBytes().asStream();

  //   int fileSize = await file!.length();
  //   String? mimeType = mime(fileName) ?? 'image/jpg';

  //   Map<String, String>? headers = {"Content-Type": mimeType};
  //   await minio.putObject(
  //     'liftyplus',
  //     objectAddress,
  //     image!,
  //     metadata: headers,
  //     onProgress: (bytes) {
  //       updateProgress!(bytes / fileSize * 100);
  //     },
  //   );
  // }

  getProductImageLocation(String? filename) {
    return "product_images/${filename!}";
  }

  getCategoryImageLocation(String? filename) {
    return "category_images/${filename!}";
  }

  Future uploadImageToFirebase(
      {required File file,
      required String path,
      String? fileName,
      Function? updateProgress}) async {
    final Reference firestorageRef = FirebaseStorage.instance.ref();
    final snapshot = await firestorageRef
        .child(path)
        .putFile(file, SettableMetadata(cacheControl: "public"));
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
