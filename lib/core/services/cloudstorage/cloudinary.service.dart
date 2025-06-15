import 'dart:async';
import 'dart:typed_data';

import 'package:app/core/di/locator.dart';
import 'package:app/core/networking/dio/interceptors/dio_interceptors.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'cloud_storage.service.dart';

mixin CloudinaryConfig {
  final String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  final String uploadPreset =
      dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';

  Uri get uploadUrl;

  Future<String> upload(
    Uint8List fileBytes, [
    String? fileName,
  ]) async {
    // Prepare the data for the request
    final formData = FormData.fromMap({
      'upload_preset': uploadPreset,
      'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
    });

    final dio = Dio()..addLogger();

    // Send the request
    final response = await dio.post(
      uploadUrl.toString(),
      data: formData,
    );

    dio.close();

    if (response.statusCode == 200) {
      return response
          .data['secure_url']; // The URL of the uploaded file
    } else {
      throw Exception("Failed to upload file: ${response.data}");
    }
  }
}

// * Cloudinary service for uploading images
@LazySingleton(as: ImageCloudStorageService)
class ImageCloudinaryService extends ImageCloudStorageService
    with CloudinaryConfig {
  @override
  Uri get uploadUrl => Uri.parse(
    "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
  );
}

// * Cloudinary service for uploading PDFs
@LazySingleton(as: PdfCloudStorageService)
class PdfCloudinaryService extends PdfCloudStorageService
    with CloudinaryConfig {
  @override
  Uri get uploadUrl => Uri.parse(
    "https://api.cloudinary.com/v1_1/$cloudName/raw/upload",
  );
}

// * Cloudinary service for uploading videos
@LazySingleton(as: VideoCloudStorageService)
class VideoCloudinaryService extends VideoCloudStorageService
    with CloudinaryConfig {
  @override
  Uri get uploadUrl => Uri.parse(
    "https://api.cloudinary.com/v1_1/$cloudName/video/upload",
  );
}
