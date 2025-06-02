import 'dart:async';
import 'dart:io';

import 'package:app/core/di/locator.dart';
import 'package:app/core/shared/dto/filesdto/image_dto.dart';
import 'package:app/core/shared/dto/filesdto/file_dto.dart';
import 'package:app/core/shared/dto/filesdto/video_dto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

mixin FilePickerService<T extends FileDTO> {
  Future<T?> pickFile();

  Future<List<T>?> pickFiles({int? maxFiles});
}

@module
abstract class FilePickersModule {
  @lazySingleton
  ImagePicker get imagePicker => ImagePicker();

  @lazySingleton
  FilePicker get filePicker => FilePicker.platform;
}

@lazySingleton
class ImageFilePicker with FilePickerService<LocalImageDTO> {
  @override
  Future<LocalImageDTO?> pickFile() async {
    final image = await locator<ImagePicker>().pickImage(
      source: ImageSource.gallery,
    );

    return image != null
        ? LocalImageDTO(await image.readAsBytes())
        : null;
  }

  @override
  Future<List<LocalImageDTO>?> pickFiles({int? maxFiles}) async {
    final images = await locator<ImagePicker>().pickMultiImage();
    return Future.wait(
      images.map(
        (image) async => LocalImageDTO(await image.readAsBytes()),
      ),
    );
  }
}

@lazySingleton
class VideoFilePicker with FilePickerService<LocalVideoDTO> {
  @override
  Future<LocalVideoDTO?> pickFile() async {
    final video = await locator<ImagePicker>().pickVideo(
      source: ImageSource.gallery,
    );
    if (video != null) {
      return kIsWeb
          ? WebVideoDTO(file: File(video.path))
          : MobileVideoDTO(file: File(video.path));
    }
    return null;
  }

  @override
  Future<List<LocalVideoDTO>?> pickFiles({int? maxFiles}) async {
    final videos = await locator<FilePicker>().pickFiles(
      type: FileType.video,
      allowMultiple: true,
      withData: true,
    );

    if (videos == null || videos.files.isEmpty) return null;

    return videos.files.map((file) {
      if (kIsWeb) {
        return WebVideoDTO(file: File(file.path!));
      } else {
        return MobileVideoDTO(file: File(file.path!));
      }
    }).toList();
  }
}
