import 'package:app/core/shared/dto/filesdto/file_dto.dart';
import 'package:app/core/shared/dto/filesdto/image_dto.dart';
import 'package:app/core/shared/dto/filesdto/video_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'banner_model.g.dart';

@JsonSerializable(createToJson: false)
class BannerModel {
  final String? attachUrl;
  final String? attachType;

  //TODO add restaurantId if needed

  BannerModel({this.attachUrl, this.attachType});

  FileDTO get file => attachType == 'image'
      ? RemoteImageDto(attachUrl!)
      : RemoteVideoDTO(attachUrl!);

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);
}
