import 'dart:io';

import 'package:app/core/di/locator.dart';
import 'package:app/core/services/cloudstorage/cloud_storage.service.dart';
import 'package:app/core/shared/dto/filesdto/file_dto.dart';
import 'package:app/core/shared/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

//* ABSTRACT CLASS FOR VIDEO DTO
abstract class VideoDTO extends FileDTO {
  VideoPlayerController get videoController;

  @override
  Widget build({
    required double width,
    required double height,
    double? borderRadius,
  }) {
    return VideoWidget(
      width: width,
      height: height,
      borderRadius: borderRadius ?? 0,
      controller: videoController,
      showControls: true,
      loop: true,
    );
  }

  @override
  String get type => 'video';
}

//**
//*     LOCAL VIDEO DTO
// */
abstract class LocalVideoDTO extends VideoDTO {
  final File file;

  LocalVideoDTO({required this.file});

  @override
  Future<String> get url async => locator<VideoCloudStorageService>()
      .upload(await file.readAsBytes());
}

//**
//*     MOBILE VIDEO DTO
// */
class MobileVideoDTO extends LocalVideoDTO {
  MobileVideoDTO({required super.file});

  @override
  VideoPlayerController get videoController =>
      VideoPlayerController.file(File(file.path));
}

//**
//*     WEB VIDEO DTO
// */
class WebVideoDTO extends LocalVideoDTO {
  WebVideoDTO({required super.file});

  @override
  VideoPlayerController get videoController =>
      VideoPlayerController.networkUrl(Uri.parse(file.path));
}

//**
//*     REMOTE VIDEO DTO
// */
class RemoteVideoDTO extends VideoDTO {
  final String _url;

  RemoteVideoDTO(this._url);

  @override
  VideoPlayerController get videoController =>
      VideoPlayerController.networkUrl(Uri.parse(_url));

  @override
  Future<String> get url async => _url;
}
