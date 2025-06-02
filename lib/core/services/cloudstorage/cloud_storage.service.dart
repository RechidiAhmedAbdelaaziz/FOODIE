import 'dart:typed_data';

abstract class CloudStorageService {
  Future<String> upload(Uint8List fileBytes, [String? fileName]);
}

abstract class ImageCloudStorageService extends CloudStorageService {}

abstract class VideoCloudStorageService extends CloudStorageService {}

abstract class PdfCloudStorageService extends CloudStorageService {}
