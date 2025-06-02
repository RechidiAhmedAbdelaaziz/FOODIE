import 'package:flutter/material.dart';

abstract class FileDTO {
  /// Widget builder to display the file
  Widget build({
    required double width,
    required double height,
    double? borderRadius,
  });

  Future<String> get url;

  String get type;
}

extension FileDtoMapper on List<FileDTO> {
  Future<List<String>> get urls async {
    return Future.wait(map((e) => e.url));
  }
}
