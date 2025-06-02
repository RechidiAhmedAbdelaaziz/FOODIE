import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'cloud_storage.service.dart';

mixin CloudinaryConfig {
  //TODO : use dotenv package to load these values
  final String cloudName = "deljic9sr";
  final String uploadPreset = 'learn_flutter';

  Uri get uploadUrl;

  Future<String> upload(Uint8List fileBytes, [String? fileName]) async {
    // Prepare the data for the request
    final request = http.MultipartRequest("POST", uploadUrl)
      ..fields['upload_preset'] = uploadPreset;

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        fileBytes.toList(),
        filename: fileName,
      ),
    );

    // Send the request
    final response = await http.Response.fromStream(
      await request.send(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['secure_url']; // The URL of the uploaded image
    } else {
      throw Exception("Failed to upload image: ${response.body}");
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
