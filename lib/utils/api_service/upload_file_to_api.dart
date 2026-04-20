import 'dart:io';

import 'package:dio/dio.dart';

Future<MultipartFile> uploadFileToApi(File file) async {
  return await MultipartFile.fromFile(file.path, filename: file.path.split('/').last);
}

Future<File?> pickFile() async {
  return null;

  // FilePickerResult? result = await FilePicker.platform.pickFiles();
  // File file = File(result.files.single.path!);
  // return file;
}
