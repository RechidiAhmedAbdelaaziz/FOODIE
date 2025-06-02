
import 'package:app/core/di/locator.dart';
import 'package:app/core/services/cloudstorage/cloud_storage.service.dart';
import 'package:app/core/shared/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'file_dto.dart';

//* ABSTRACT CLASS FOR IMAGE DTO
abstract class ImageDTO extends FileDTO {
  ImageProvider get imageProvider;

  @override
  Widget build({
    required double width,
    required double height,
    double? borderRadius,
  }) {
    return ImageWidget(
      image: imageProvider,
      width: width,
      height: height,
      borderRadius: borderRadius ?? 0,
    );
  }

  @override
  String get type => 'image';
}

//**
//*     REMOTE IMAGE DTO
// */
class RemoteImageDto extends ImageDTO {
  final String _url;

  RemoteImageDto(this._url);

  @override
  ImageProvider get imageProvider => NetworkImage(_url);

  @override
  Future<String> get url async => _url;
}

//**
//*     LOCAL IMAGE DTO
// */
class LocalImageDTO extends ImageDTO {
  final Uint8List _bytes;

  LocalImageDTO(this._bytes);

  @override
  Future<String> get url async =>
      locator<ImageCloudStorageService>().upload(_bytes);

  @override
  ImageProvider<Object> get imageProvider => MemoryImage(_bytes);
}
