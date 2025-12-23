// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gif_app_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FullResponse _$FullResponseFromJson(Map<String, dynamic> json) => FullResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => GifData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

GifData _$GifDataFromJson(Map<String, dynamic> json) => GifData(
  id: json['id'] as String,
  images: Images.fromJson(json['images'] as Map<String, dynamic>),
);

Images _$ImagesFromJson(Map<String, dynamic> json) => Images(
  original: OriginalImages.fromJson(json['original'] as Map<String, dynamic>),
);

OriginalImages _$OriginalImagesFromJson(Map<String, dynamic> json) =>
    OriginalImages(
      url: json['url'] as String,
      width: json['width'] as String,
      height: json['height'] as String,
    );
